import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/auth/auth_provider.dart';
import 'package:core/network/api_endpoints.dart';
import 'package:core/network/dio_provider.dart';
import 'package:core/network/learnlens_session_manager.dart';

void main() {
  group('LearnLensSessionManager', () {
    late Dio mockDio;
    int requestCount = 0;
    Map<String, dynamic>? mockResponseData;

    setUp(() {
      requestCount = 0;
      mockResponseData = {
        'session_token': 'session-token-1',
        'expiresAt': DateTime.now().millisecondsSinceEpoch + 3600000,
        'base_url': 'https://learnlens.example/api/v2/org1/generic',
        'policy': {'max_messages_per_conversation': 20},
        'attachments_enabled': false,
      };

      mockDio = Dio(BaseOptions(baseUrl: 'https://testpress.example'));
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        if (options.path == ApiEndpoints.genericAiChatSessionCreate) {
          requestCount++;
          return ResponseBody.fromString(
            '{"session_token": "${mockResponseData!['session_token']}", "expiresAt": ${mockResponseData!['expiresAt']}, "base_url": "${mockResponseData!['base_url']}", "policy": {"max_messages_per_conversation": 20}, "attachments_enabled": false}',
            201,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }
        return ResponseBody.fromString('Not Found', 404);
      });
    });

    test('acquires a new session when none is cached', () async {
      final manager = LearnLensSessionManager(dio: mockDio);

      expect(manager.hasValidSession, isFalse);
      final session = await manager.getSession();

      expect(requestCount, 1);
      expect(session.sessionToken, 'session-token-1');
      expect(session.baseUrl, 'https://learnlens.example/api/v2/org1/generic');
      expect(manager.hasValidSession, isTrue);
      expect(manager.policy?.maxMessagesPerConversation, 20);
    });

    test(
      'reuses cached session without making another network call when still valid',
      () async {
        final manager = LearnLensSessionManager(dio: mockDio);

        final session1 = await manager.getSession();
        final session2 = await manager.getSession();

        expect(requestCount, 1);
        expect(identical(session1, session2), isTrue);
      },
    );

    test('refreshes session when forceRefresh is true', () async {
      final manager = LearnLensSessionManager(dio: mockDio);

      await manager.getSession();
      expect(requestCount, 1);

      mockResponseData!['session_token'] = 'session-token-2';
      final refreshed = await manager.getSession(forceRefresh: true);

      expect(requestCount, 2);
      expect(refreshed.sessionToken, 'session-token-2');
    });

    test(
      'coalesces concurrent getSession calls into a single network call',
      () async {
        final manager = LearnLensSessionManager(dio: mockDio);

        final results = await Future.wait([
          manager.getSession(forceRefresh: true),
          manager.getSession(forceRefresh: true),
          manager.getSession(forceRefresh: true),
        ]);

        expect(requestCount, 1);
        expect(results[0].sessionToken, 'session-token-1');
        expect(results[1].sessionToken, 'session-token-1');
        expect(results[2].sessionToken, 'session-token-1');
      },
    );

    test('clearSession resets in-memory cached state', () async {
      final manager = LearnLensSessionManager(dio: mockDio);

      await manager.getSession();
      expect(manager.hasValidSession, isTrue);

      manager.clearSession();
      expect(manager.hasValidSession, isFalse);
      expect(manager.currentSession, isNull);
    });

    test(
      'in-flight refresh completing after clearSession does not resurrect session in cache',
      () async {
        final delayedCompleter = Completer<ResponseBody>();
        final delayedDio = Dio(
          BaseOptions(baseUrl: 'https://testpress.example'),
        );
        delayedDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          return delayedCompleter.future;
        });

        final manager = LearnLensSessionManager(dio: delayedDio);

        // Start in-flight getSession()
        final future = manager.getSession();

        // User logs out before getSession completes
        manager.clearSession();
        expect(manager.currentSession, isNull);

        // In-flight network response arrives later
        delayedCompleter.complete(
          ResponseBody.fromString(
            '{"session_token": "revoked-token", "expiresAt": ${DateTime.now().millisecondsSinceEpoch + 3600000}, "base_url": "https://learnlens.example/api/v2/org1/generic", "policy": {}, "attachments_enabled": false}',
            201,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          ),
        );

        // The in-flight future rejects due to session clear
        try {
          await future;
        } catch (_) {}

        // Revoked session MUST NOT be stored in cache
        expect(manager.currentSession, isNull);
        expect(manager.hasValidSession, isFalse);
      },
    );

    test(
      'getContentSession: clearAllSessions during in-flight request prevents writing stale session to cache',
      () async {
        final delayedCompleter = Completer<ResponseBody>();
        final delayedDio = Dio(
          BaseOptions(baseUrl: 'https://testpress.example'),
        );
        delayedDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          return delayedCompleter.future;
        });

        final manager = LearnLensSessionManager(dio: delayedDio);

        final future = manager.getContentSession(42);

        // Student logs out or clears all sessions while request is in flight
        manager.clearAllSessions();

        delayedCompleter.complete(
          ResponseBody.fromString(
            '{"session_token": "stale-content-token", "expiresAt": ${DateTime.now().millisecondsSinceEpoch + 3600000}, "base_url": "https://learnlens.example"}',
            201,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          ),
        );

        try {
          await future;
        } catch (_) {}

        // Stale session MUST NOT be written back into content cache
        expect(manager.getCachedContentSession(42), isNull);
      },
    );

    test(
      'offline network error does not leak unhandled async completer error',
      () async {
        final offlineDio = Dio(
          BaseOptions(baseUrl: 'https://testpress.example'),
        );
        offlineDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          throw DioException(
            requestOptions: options,
            error: 'No Internet connection',
            type: DioExceptionType.connectionError,
          );
        });

        final manager = LearnLensSessionManager(dio: offlineDio);

        // Single caller triggers offline error without concurrent callers
        expect(
          () async => await manager.getSession(),
          throwsA(isA<DioException>()),
        );
      },
    );
  });

  group('LearnLensSessionInterceptor', () {
    late Dio learnLensDio;
    late LearnLensSessionManager sessionManager;
    late Dio mockDio;
    int learnLensRequestCount = 0;
    int testpressSessionCreateCount = 0;
    int sessionTokenCounter = 1;

    setUp(() {
      learnLensRequestCount = 0;
      testpressSessionCreateCount = 0;
      sessionTokenCounter = 1;

      mockDio = Dio(BaseOptions(baseUrl: 'https://testpress.example'));
      mockDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        testpressSessionCreateCount++;
        final token = 'token-$sessionTokenCounter';
        return ResponseBody.fromString(
          '{"session_token": "$token", "expiresAt": ${DateTime.now().millisecondsSinceEpoch + 3600000}, "base_url": "https://learnlens.example/api/v2/org1/generic", "policy": {}, "attachments_enabled": false}',
          201,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      sessionManager = LearnLensSessionManager(dio: mockDio);

      learnLensDio = Dio(
        BaseOptions(baseUrl: 'https://learnlens.example/api/v2/org1/generic'),
      );
      learnLensDio.interceptors.add(
        LearnLensSessionInterceptor(
          sessionManager: sessionManager,
          dio: learnLensDio,
        ),
      );
    });

    test('attaches X-Session-Token header to outgoing requests', () async {
      learnLensDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        learnLensRequestCount++;
        final sessionToken = options.headers['X-Session-Token'];
        expect(sessionToken, 'token-1');

        return ResponseBody.fromString(
          '{"items":[], "next_cursor": null}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final response = await learnLensDio.get('/chats/');
      expect(response.statusCode, 200);
      expect(learnLensRequestCount, 1);
      expect(testpressSessionCreateCount, 1);
    });

    test(
      'intercepts 401, refreshes session from Testpress, and retries request successfully',
      () async {
        learnLensDio.httpClientAdapter = _MockHttpClientAdapter((
          options,
        ) async {
          learnLensRequestCount++;
          final sessionToken = options.headers['X-Session-Token'];

          if (sessionToken == 'token-1') {
            // Simulate expired session on LearnLens
            sessionTokenCounter =
                2; // Next session token returned by Testpress will be token-2
            return ResponseBody.fromString(
              '{"detail": "Session expired"}',
              401,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          // Second attempt with token-2 succeeds
          expect(sessionToken, 'token-2');
          return ResponseBody.fromString(
            '{"items":[{"chat_id":"chat-1","title":"History"}],"next_cursor":null}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        final response = await learnLensDio.get('/chats/');

        expect(response.statusCode, 200);
        expect(learnLensRequestCount, 2); // Initial 401 + retry
        expect(testpressSessionCreateCount, 2); // Initial + forced refresh
        expect(sessionManager.currentSession?.sessionToken, 'token-2');
      },
    );

    test(
      'does not retry 401 when caller provides an explicit session token',
      () async {
        int learnLensRequestCount = 0;
        int testpressSessionCreateCount = 0;

        mockDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          testpressSessionCreateCount++;
          return ResponseBody.fromString(
            '{"session_token":"generic-token","org_uuid":"org-1","expires_at":"2099-01-01T00:00:00Z","policy":{}}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        learnLensDio.httpClientAdapter = _MockHttpClientAdapter((
          options,
        ) async {
          learnLensRequestCount++;
          return ResponseBody.fromString(
            '{"detail": "Unauthorized"}',
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        try {
          await learnLensDio.get(
            '/chats/',
            options: Options(
              headers: {'X-Session-Token': 'custom-lesson-token'},
            ),
          );
          fail('Should throw DioException');
        } on DioException catch (e) {
          expect(e.response?.statusCode, 401);
          // Must not retry and must not acquire generic session
          expect(learnLensRequestCount, 1);
          expect(testpressSessionCreateCount, 0);
        }
      },
    );

    test(
      'does not deadlock or loop when retried request fails with 500',
      () async {
        int learnLensRequestCount = 0;
        int testpressSessionCreateCount = 0;

        mockDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          testpressSessionCreateCount++;
          return ResponseBody.fromString(
            '{"session_token":"token-$testpressSessionCreateCount","org_uuid":"org-1","expires_at":"2099-01-01T00:00:00Z","policy":{}}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        learnLensDio.httpClientAdapter = _MockHttpClientAdapter((
          options,
        ) async {
          learnLensRequestCount++;
          if (learnLensRequestCount == 1) {
            return ResponseBody.fromString(
              '{"detail": "Token expired"}',
              401,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else {
            return ResponseBody.fromString(
              '{"detail": "Internal Server Error"}',
              500,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
        });

        try {
          await learnLensDio.get('/chats/');
          fail('Should throw DioException');
        } on DioException catch (e) {
          expect(e.response?.statusCode, 500);
          expect(learnLensRequestCount, 2);
          expect(testpressSessionCreateCount, 2);
        }
      },
    );

    test(
      'does not loop infinitely when retried request returns 401 a second time',
      () async {
        int learnLensRequestCount = 0;
        int testpressSessionCreateCount = 0;

        mockDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          testpressSessionCreateCount++;
          return ResponseBody.fromString(
            '{"session_token":"token-$testpressSessionCreateCount","org_uuid":"org-1","expires_at":"2099-01-01T00:00:00Z","policy":{}}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        learnLensDio.httpClientAdapter = _MockHttpClientAdapter((
          options,
        ) async {
          learnLensRequestCount++;
          return ResponseBody.fromString(
            '{"detail": "Still Unauthorized"}',
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        try {
          await learnLensDio.get('/chats/');
          fail('Should throw DioException');
        } on DioException catch (e) {
          expect(e.response?.statusCode, 401);
          // Crucial: exactly 1 initial + 1 retry, does not loop infinitely
          expect(learnLensRequestCount, 2);
          expect(testpressSessionCreateCount, 2);
        }
      },
    );

    test(
      'attaches refresh error to requestOptions.extra when 401 refresh fails',
      () async {
        // Pre-acquire a valid session so onRequest succeeds and sends the request
        await sessionManager.getSession();

        learnLensDio.httpClientAdapter = _MockHttpClientAdapter((
          options,
        ) async {
          return ResponseBody.fromString(
            '{"detail": "Unauthorized"}',
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        mockDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
          return ResponseBody.fromString('Testpress Server Error', 500);
        });

        try {
          await learnLensDio.get('/chats/');
          fail('Should throw DioException');
        } on DioException catch (e) {
          expect(e.response?.statusCode, 401);
          expect(
            e.requestOptions.extra.containsKey('session_refresh_error'),
            isTrue,
          );
          expect(e.requestOptions.extra['session_refresh_error'], isNotNull);
        }
      },
    );
  });

  group('learnLensSessionManagerProvider', () {
    late Dio mockTestpressDio;
    int sessionCreateCount = 0;

    setUp(() {
      sessionCreateCount = 0;
      mockTestpressDio = Dio(BaseOptions(baseUrl: 'https://testpress.example'));
      mockTestpressDio.httpClientAdapter = _MockHttpClientAdapter((
        options,
      ) async {
        if (options.path == ApiEndpoints.genericAiChatSessionCreate) {
          sessionCreateCount++;
          return ResponseBody.fromString(
            '{"session_token": "token-user-$sessionCreateCount", "expiresAt": ${DateTime.now().millisecondsSinceEpoch + 3600000}, "base_url": "https://learnlens.example", "policy": {"max_messages_per_conversation": 20}, "attachments_enabled": false}',
            201,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }
        return ResponseBody.fromString('Not Found', 404);
      });
    });

    test(
      'disposes and purges cached session when userIdProvider changes or emits null on logout',
      () async {
        final userController = StreamController<String?>.broadcast();
        addTearDown(userController.close);

        final container = ProviderContainer(
          overrides: [
            dioProvider.overrideWithValue(mockTestpressDio),
            userIdProvider.overrideWith((ref) => userController.stream),
          ],
        );
        addTearDown(container.dispose);

        // 1. Initial user login: User A ('user_1')
        userController.add('user_1');
        await Future<void>.delayed(Duration.zero);

        final managerUserA = container.read(learnLensSessionManagerProvider);
        final sessionUserA = await managerUserA.getSession();

        expect(sessionUserA.sessionToken, 'token-user-1');
        expect(managerUserA.hasValidSession, isTrue);
        expect(sessionCreateCount, 1);

        // 2. User A logs out (userId becomes null)
        userController.add(null);
        await Future<void>.delayed(Duration.zero);

        // Session manager provider should have been recreated / cleared
        final managerAfterLogout = container.read(
          learnLensSessionManagerProvider,
        );
        expect(identical(managerUserA, managerAfterLogout), isFalse);
        expect(managerAfterLogout.hasValidSession, isFalse);

        // 3. User B logs in ('user_2')
        userController.add('user_2');
        await Future<void>.delayed(Duration.zero);

        final managerUserB = container.read(learnLensSessionManagerProvider);
        final sessionUserB = await managerUserB.getSession();

        expect(sessionUserB.sessionToken, 'token-user-2');
        expect(managerUserB.hasValidSession, isTrue);
        expect(sessionCreateCount, 2);
      },
    );
  });
}

class _MockHttpClientAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  _MockHttpClientAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}
