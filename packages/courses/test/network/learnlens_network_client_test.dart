import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courses/network/learnlens_network_client.dart';
import 'package:courses/providers/learnlens_provider.dart';
import 'package:courses/repositories/learnlens_repository.dart';
import 'package:core/data/data.dart';

class MockDioAdapter implements HttpClientAdapter {
  final dynamic Function(RequestOptions options) handler;

  MockDioAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final responseData = handler(options);
    return ResponseBody.fromString(
      jsonEncode(responseData),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class FakeDataSource extends MockDataSource {}

void main() {
  group('LearnLensNetworkClient & LearnLensRepository Chat Persistence', () {
    late Dio dio;
    late LearnLensNetworkClient networkClient;
    late LearnLensRepository repository;
    RequestOptions? lastRequest;

    setUp(() {
      dio = Dio();
      dio.httpClientAdapter = MockDioAdapter((options) {
        lastRequest = options;
        if (options.path.contains('/chats/')) {
          if (options.path.contains('/messages/')) {
            return {
              'items': [
                {
                  'message_id': 'msg-1',
                  'role': 'user',
                  'content': 'Hello tutor',
                  'message_type': 'text',
                },
                {
                  'message_id': 'msg-2',
                  'role': 'assistant',
                  'content': 'Hello learner! How can I help?',
                  'message_type': 'text',
                },
              ],
            };
          }
          return {
            'items': [
              {
                'chat_id': 'chat-123',
                'title': 'Hello tutor',
                'updated_at': '2026-09-02T10:00:05Z',
              },
            ],
          };
        } else if (options.path.contains('/chat/')) {
          return {
            'answer': 'Sure, here is the explanation.',
            'chat_id': 'chat-123',
            'conversation_id': 'chat-123',
          };
        }
        return {};
      });

      networkClient = LearnLensNetworkClient(dio, () async => 'learner-1');
      repository = LearnLensRepository(
        networkClient,
        FakeDataSource(),
      );
    });

    test('listChats fetches chat sessions for asset', () async {
      final chats = await repository.fetchChats(
        orgUuid: 'org-1',
        assetId: 'asset-1',
        sessionToken: 'token-123',
      );

      expect(chats.length, 1);
      expect(chats.first.id, 'chat-123');
      expect(chats.first.title, 'Hello tutor');
      expect(lastRequest?.path, contains('/v2/org-1/assets/asset-1/chats/'));
      expect(lastRequest?.headers['X-Session-Token'], 'token-123');
    });

    test('fetchChatMessages fetches messages for a chat', () async {
      final messages = await repository.fetchChatMessages(
        orgUuid: 'org-1',
        chatId: 'chat-123',
        sessionToken: 'token-123',
      );

      expect(messages.length, 2);
      expect(messages.first.id, 'msg-1');
      expect(messages.first.isUser, true);
      expect(messages.first.content, 'Hello tutor');
      expect(messages.last.id, 'msg-2');
      expect(messages.last.isAi, true);
      expect(messages.last.content, 'Hello learner! How can I help?');
      expect(lastRequest?.path, contains('/v2/org-1/chats/chat-123/messages/'));
    });

    test('listChats passes limit, cursor, and before query parameters',
        () async {
      await repository.fetchChats(
        orgUuid: 'org-1',
        assetId: 'asset-1',
        sessionToken: 'token-123',
        limit: 20,
        cursor: 'cur-abc',
        before: 'msg-999',
      );

      expect(lastRequest?.queryParameters['limit'], 20);
      expect(lastRequest?.queryParameters['cursor'], 'cur-abc');
      expect(lastRequest?.queryParameters['before'], 'msg-999');
    });

    test('fetchChatMessages passes limit, cursor, and before query parameters',
        () async {
      await repository.fetchChatMessages(
        orgUuid: 'org-1',
        chatId: 'chat-123',
        sessionToken: 'token-123',
        limit: 50,
        cursor: 'cur-def',
        before: 'msg-111',
      );

      expect(lastRequest?.queryParameters['limit'], 50);
      expect(lastRequest?.queryParameters['cursor'], 'cur-def');
      expect(lastRequest?.queryParameters['before'], 'msg-111');
    });

    test('submitChat passes chatId and parses chat_id from response', () async {
      final response = await repository.submitChat(
        orgUuid: 'org-1',
        assetId: 'asset-1',
        sessionToken: 'token-123',
        query: 'Explain quantum physics',
        chatId: 'chat-123',
      );

      expect(response.answer, 'Sure, here is the explanation.');
      expect(response.chatId, 'chat-123');
      expect((lastRequest?.data as Map)['chat_id'], 'chat-123');
      expect((lastRequest?.data as Map)['query'], 'Explain quantum physics');
      expect((lastRequest?.data as Map)['learner_id'], 'learner-1');
    });
  });

  group('isSessionExpired helper tests', () {
    test('returns true for null or empty session map', () {
      expect(isSessionExpired(null), isTrue);
      expect(isSessionExpired({}), isTrue);
      expect(isSessionExpired({'session_token': ''}), isTrue);
    });

    test('returns false when no expiry is specified', () {
      expect(isSessionExpired({'session_token': 'valid-token'}), isFalse);
    });

    test(
        'returns true when session is expired or within 60s buffer (ISO8601 string)',
        () {
      // Expired in past
      final past = DateTime.now()
          .toUtc()
          .subtract(const Duration(minutes: 5))
          .toIso8601String();
      expect(
          isSessionExpired({'session_token': 't', 'expiresAt': past}), isTrue);

      // Expiring in 30 seconds (within 60s buffer)
      final nearFuture = DateTime.now()
          .toUtc()
          .add(const Duration(seconds: 30))
          .toIso8601String();
      expect(isSessionExpired({'session_token': 't', 'expiresAt': nearFuture}),
          isTrue);

      // Expiring in 5 minutes (valid)
      final future = DateTime.now()
          .toUtc()
          .add(const Duration(minutes: 5))
          .toIso8601String();
      expect(isSessionExpired({'session_token': 't', 'expiresAt': future}),
          isFalse);
    });

    test('handles epoch timestamps (seconds and milliseconds)', () {
      final nowSec = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      expect(
          isSessionExpired({'session_token': 't', 'expires_at': nowSec - 100}),
          isTrue);
      expect(
          isSessionExpired({'session_token': 't', 'expires_at': nowSec + 300}),
          isFalse);

      final nowMs = DateTime.now().toUtc().millisecondsSinceEpoch;
      expect(isSessionExpired({'session_token': 't', 'exp': nowMs - 10000}),
          isTrue);
      expect(isSessionExpired({'session_token': 't', 'exp': nowMs + 300000}),
          isFalse);
    });
  });

  group('LearnLensNetworkClient 401 Automatic Retry Interceptor', () {
    test('automatically refreshes token and retries on 401', () async {
      final dio = Dio();
      int callCount = 0;
      final requestedTokens = <String?>[];

      dio.httpClientAdapter = MockDioAdapter((options) {
        callCount++;
        requestedTokens.add(options.headers['X-Session-Token'] as String?);
        if (callCount == 1) {
          throw DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {'detail': 'Invalid session token'},
            ),
            type: DioExceptionType.badResponse,
          );
        }
        return {
          'items': [
            {'chat_id': 'chat-retried', 'title': 'Retried chat'}
          ]
        };
      });

      int refreshCount = 0;
      final client = LearnLensNetworkClient(
        dio,
        () async => 'learner-1',
        retryDelay: Duration.zero,
        onRefreshToken: (options) async {
          refreshCount++;
          expect(options.extra['content_id'], 101);
          return 'fresh-refreshed-token';
        },
      );

      final result = await client.listChats(
        orgUuid: 'org-1',
        assetId: 'asset-1',
        sessionToken: 'stale-token',
        contentId: 101,
      );

      expect(callCount, 2);
      expect(refreshCount, 1);
      expect(requestedTokens, ['stale-token', 'fresh-refreshed-token']);
      expect(result.length, 1);
      expect(result.first.id, 'chat-retried');
    });

    test('propagates 401 error when second attempt also fails with 401',
        () async {
      final dio = Dio();
      int callCount = 0;

      dio.httpClientAdapter = MockDioAdapter((options) {
        callCount++;
        throw DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            data: {'detail': 'Invalid session token'},
          ),
          type: DioExceptionType.badResponse,
        );
      });

      int refreshCount = 0;
      final client = LearnLensNetworkClient(
        dio,
        () async => 'learner-1',
        retryDelay: Duration.zero,
        onRefreshToken: (options) async {
          refreshCount++;
          return 'fresh-token';
        },
      );

      expect(
        () => client.listChats(
          orgUuid: 'org-1',
          assetId: 'asset-1',
          sessionToken: 'stale-token',
        ),
        throwsA(isA<DioException>()
            .having((e) => e.response?.statusCode, 'statusCode', 401)),
      );

      // Should have attempted twice: initial + 1 retry
      await pumpEventQueue();
      expect(callCount, 2);
      expect(refreshCount, 1);
    });

    test('propagates error when onRefreshToken returns null', () async {
      final dio = Dio();
      int callCount = 0;

      dio.httpClientAdapter = MockDioAdapter((options) {
        callCount++;
        throw DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            data: {'detail': 'Invalid session token'},
          ),
          type: DioExceptionType.badResponse,
        );
      });

      final client = LearnLensNetworkClient(
        dio,
        () async => 'learner-1',
        retryDelay: Duration.zero,
        onRefreshToken: (options) async => null,
      );

      expect(
        () => client.listChats(
          orgUuid: 'org-1',
          assetId: 'asset-1',
          sessionToken: 'stale-token',
        ),
        throwsA(isA<DioException>()),
      );

      await pumpEventQueue();
      expect(callCount, 1);
    });
  });
}
