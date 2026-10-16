import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/repositories/learnlens_repository.dart';
import 'package:core/network/learnlens_network_client.dart';
import 'package:core/network/learnlens_session_manager.dart';
import 'package:core/network/uuid_utils.dart';

void main() {
  group('LearnLensNetworkClient', () {
    late Dio mockClientDio;
    late LearnLensSessionManager sessionManager;
    late LearnLensNetworkClient client;
    late List<Map<String, dynamic>> capturedRequests;

    setUp(() {
      capturedRequests = [];

      final testSession = AiChatSessionDto(
        sessionToken: 'test-session-token',
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        expiresAtMs: DateTime.now().millisecondsSinceEpoch + 3600000,
        baseUrl: 'https://learnlens.example/api/v2/org1/generic',
        policy: const AiChatPolicyDto(maxMessagesPerConversation: 20),
      );

      final dummyTestpressDio = Dio(
        BaseOptions(baseUrl: 'https://testpress.example'),
      );
      sessionManager = LearnLensSessionManager(
        dio: dummyTestpressDio,
        initialSession: testSession,
      );

      mockClientDio = Dio(
        BaseOptions(baseUrl: 'https://learnlens.example/api/v2/org1/generic'),
      );

      mockClientDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        capturedRequests.add({
          'method': options.method,
          'path': options.path,
          'queryParameters': options.queryParameters,
          'data': options.data,
          'headers': options.headers,
        });

        if (options.path.endsWith('/chats/')) {
          if (options.method == 'GET') {
            return ResponseBody.fromString(
              '{"items":[{"chat_id":"chat-1","title":"Chat 1","updated_at":"2026-10-12T12:00:00Z"}],"next_cursor":"cursor-123"}',
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else if (options.method == 'POST') {
            return ResponseBody.fromString(
              '{"answer":"First answer","chat_id":"chat-new","title":"New Chat","generation":{"generation_id":"gen-1","request_id":"req-1","user_message_id":"usr-1","assistant_message_id":"ast-1","status":"completed","created_at":"2026-10-12T12:00:00Z"}}',
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
        }

        if (options.path.contains('/messages/')) {
          if (options.method == 'POST') {
            return ResponseBody.fromString(
              '{"answer":"Follow up answer","chat_id":"chat-1","title":"Chat 1","generation":{"generation_id":"gen-2","request_id":"req-2","user_message_id":"usr-2","assistant_message_id":"ast-2","status":"completed","created_at":"2026-10-12T12:01:00Z"}}',
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else if (options.method == 'GET') {
            return ResponseBody.fromString(
              '{"items":[{"message_id":"msg-1","role":"user","content":"Hi","created_at":"2026-10-12T12:00:00Z"}],"next_cursor":null}',
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
        }

        if (options.path.endsWith('/chats/chat-1/')) {
          return ResponseBody.fromString(
            '{"chat_id":"chat-1","title":"Chat 1","updated_at":"2026-10-12T12:00:00Z","generation":{"generation_id":"gen-1","request_id":"req-1","user_message_id":"usr-1","assistant_message_id":"ast-1","status":"completed","created_at":"2026-10-12T12:00:00Z"}}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        return ResponseBody.fromString('Not Found', 404);
      });

      client = LearnLensNetworkClient(
        dio: mockClientDio,
        sessionManager: sessionManager,
      );
    });

    test(
      'listConversations calls GET /chats/ with pagination query parameters',
      () async {
        final result = await client.listConversations(
          limit: 10,
          cursor: 'prev-cur',
        );

        expect(result.items.length, 1);
        expect(result.items.first.chatId, 'chat-1');
        expect(result.nextCursor, 'cursor-123');

        final req = capturedRequests.first;
        expect(req['method'], 'GET');
        expect(req['path'], contains('/chats/'));
        expect(req['queryParameters']['limit'], 10);
        expect(req['queryParameters']['cursor'], 'prev-cur');
        expect(req['headers']['X-Session-Token'], 'test-session-token');
      },
    );

    test(
      'startConversation sends POST /chats/ with request_id and query',
      () async {
        final result = await client.startConversation(
          requestId: 'req-1',
          query: 'What is physics?',
        );

        expect(result.chatId, 'chat-new');
        expect(result.answer, 'First answer');
        expect(result.generation.status, 'completed');

        final req = capturedRequests.first;
        expect(req['method'], 'POST');
        expect(req['data']['request_id'], 'req-1');
        expect(req['data']['query'], 'What is physics?');
      },
    );

    test(
      'sendFollowUpMessage sends POST /chats/<id>/messages/ with query',
      () async {
        final result = await client.sendFollowUpMessage(
          chatId: 'chat-1',
          requestId: 'req-2',
          query: 'Explain further.',
        );

        expect(result.chatId, 'chat-1');
        expect(result.answer, 'Follow up answer');

        final req = capturedRequests.first;
        expect(req['method'], 'POST');
        expect(req['path'], contains('/chats/chat-1/messages/'));
        expect(req['data']['request_id'], 'req-2');
        expect(req['data']['query'], 'Explain further.');
      },
    );

    test('getConversationStatus sends GET /chats/<id>/', () async {
      final result = await client.getConversationStatus(chatId: 'chat-1');

      expect(result.chatId, 'chat-1');
      expect(result.title, 'Chat 1');
      expect(result.generation, isNotNull);

      final req = capturedRequests.first;
      expect(req['method'], 'GET');
      expect(req['path'], contains('/chats/chat-1/'));
    });

    test(
      'getMessages sends GET /chats/<id>/messages/ with before cursor',
      () async {
        final result = await client.getMessages(
          chatId: 'chat-1',
          limit: 20,
          before: 'before-cursor-token',
        );

        expect(result.items.length, 1);
        expect(result.items.first.content, 'Hi');

        final req = capturedRequests.first;
        expect(req['method'], 'GET');
        expect(req['queryParameters']['before'], 'before-cursor-token');
      },
    );

    test(
      'maps 429 quota error to LearnLensException with code and retryAt',
      () async {
        mockClientDio.httpClientAdapter = _MockHttpClientAdapter((
          options,
        ) async {
          return ResponseBody.fromString(
            '{"detail":{"code":"hourly_message_limit","message":"Rate limited","limit":20,"retry_at":"2026-10-12T13:00:00Z"}}',
            429,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        expect(
          () => client.startConversation(requestId: 'req-err', query: 'Hello'),
          throwsA(
            isA<LearnLensException>()
                .having((e) => e.statusCode, 'statusCode', 429)
                .having((e) => e.code, 'code', 'hourly_message_limit')
                .having((e) => e.limit, 'limit', 20)
                .having((e) => e.retryAt, 'retryAt', isNotNull),
          ),
        );
      },
    );
  });

  group('LearnLensNetworkClient streaming', () {
    late Dio streamDio;
    late LearnLensSessionManager sessionManager;
    late LearnLensNetworkClient client;
    late List<RequestOptions> capturedRequests;

    ResponseBody sseResponse(List<String> chunks, {int statusCode = 200}) {
      return ResponseBody(
        Stream.fromIterable(
          chunks.map((c) => Uint8List.fromList(utf8.encode(c))),
        ),
        statusCode,
        headers: {
          Headers.contentTypeHeader: ['text/event-stream; charset=utf-8'],
          'cache-control': ['no-cache'],
        },
      );
    }

    ResponseBody jsonResponse(String body, int statusCode) {
      return ResponseBody.fromString(
        body,
        statusCode,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    void useHandler(Future<ResponseBody> Function(RequestOptions) handler) {
      streamDio.httpClientAdapter = _MockHttpClientAdapter((options) {
        capturedRequests.add(options);
        return handler(options);
      });
    }

    setUp(() {
      capturedRequests = [];
      final testSession = AiChatSessionDto(
        sessionToken: 'stream-session-token',
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        expiresAtMs: DateTime.now().millisecondsSinceEpoch + 3600000,
        baseUrl: 'https://learnlens.example/api/v2/org1/generic',
        policy: const AiChatPolicyDto(),
      );
      sessionManager = LearnLensSessionManager(
        dio: Dio(BaseOptions(baseUrl: 'https://testpress.example')),
        initialSession: testSession,
      );
      streamDio = Dio();
      client = LearnLensNetworkClient(
        dio: streamDio,
        sessionManager: sessionManager,
      );
    });

    const acceptedData =
        '{"answer": null, "chat_id": "chat-s1", "title": "What is F?", '
        '"generation": {"generation_id": "gen-s1", "request_id": "req-s1", '
        '"user_message_id": "usr-s1", "assistant_message_id": null, '
        '"status": "processing", "created_at": "2026-10-12T12:00:00Z"}}';
    const doneData =
        '{"answer": "F = ma", "chat_id": "chat-s1", "title": "Newton", '
        '"generation": {"generation_id": "gen-s1", "request_id": "req-s1", '
        '"user_message_id": "usr-s1", "assistant_message_id": "ast-s1", '
        '"status": "completed", "created_at": "2026-10-12T12:00:00Z", '
        '"finished_at": "2026-10-12T12:00:05Z"}}';

    test(
      'streamConversation POSTs /chats/stream/ with SSE headers and emits parsed events from fragmented chunks',
      () async {
        useHandler((options) async {
          return sseResponse([
            ': keep-alive\n\n',
            'event: accepted\ndata: $acceptedData\n\n',
            'event: delta\ndata: {"text": "F = ',
            'm',
            'a"}\n\nevent: del',
            'ta\ndata: {"text": " → ∑F"}\n\n',
            'event: done\ndata: $doneData\n\n',
          ]);
        });

        final events = await client
            .streamConversation(requestId: 'req-s1', query: 'What is F?')
            .toList();

        final req = capturedRequests.single;
        expect(req.method, 'POST');
        expect(
          req.uri.toString(),
          'https://learnlens.example/api/v2/org1/generic/chats/stream/',
        );
        expect(req.headers['Accept'], 'text/event-stream');
        expect(req.headers['X-Session-Token'], 'stream-session-token');
        expect(req.responseType, ResponseType.stream);
        expect(req.data, {'request_id': 'req-s1', 'query': 'What is F?'});

        expect(events.map((e) => e.type), [
          AiChatStreamEventType.accepted,
          AiChatStreamEventType.delta,
          AiChatStreamEventType.delta,
          AiChatStreamEventType.done,
        ]);
        expect(events[0].turn!.chatId, 'chat-s1');
        expect(events[0].turn!.generation.isProcessing, isTrue);
        expect(events[1].text, 'F = ma');
        expect(events[2].text, ' → ∑F');
        expect(events[3].turn!.answer, 'F = ma');
        expect(events[3].turn!.generation.assistantMessageId, 'ast-s1');
      },
    );

    test(
      'streamFollowUpMessage POSTs /chats/<chat_id>/messages/stream/',
      () async {
        useHandler((options) async {
          return sseResponse([
            'event: accepted\ndata: $acceptedData\n\n',
            'event: done\ndata: $doneData\n\n',
          ]);
        });

        final events = await client
            .streamFollowUpMessage(
              chatId: 'chat-s1',
              requestId: 'req-s2',
              query: 'Example?',
            )
            .toList();

        expect(
          capturedRequests.single.uri.toString(),
          'https://learnlens.example/api/v2/org1/generic/chats/chat-s1/messages/stream/',
        );
        expect(capturedRequests.single.data['request_id'], 'req-s2');
        expect(events.length, 2);
        expect(events.last.isDone, isTrue);
      },
    );

    test('stops after a terminal error event', () async {
      useHandler((options) async {
        return sseResponse([
          'event: accepted\ndata: $acceptedData\n\n',
          'event: error\ndata: {"code":"stream_failed","message":"The response stream could not be completed."}\n\n',
          'event: delta\ndata: {"text": "should not be emitted"}\n\n',
        ]);
      });

      final events = await client
          .streamConversation(requestId: 'req-s1', query: 'Q')
          .toList();

      expect(events.length, 2);
      expect(events.last.isError, isTrue);
      expect(events.last.errorCode, 'stream_failed');
    });

    test(
      'completes without a terminal event when the connection closes early',
      () async {
        useHandler((options) async {
          return sseResponse([
            'event: accepted\ndata: $acceptedData\n\n',
            'event: delta\ndata: {"text": "partial"}\n\n',
          ]);
        });

        final events = await client
            .streamConversation(requestId: 'req-s1', query: 'Q')
            .toList();

        expect(events.length, 2);
        expect(events.last.isDelta, isTrue);
      },
    );

    test(
      'normalizes a 429 JSON error received before streaming starts',
      () async {
        useHandler((options) async {
          return jsonResponse(
            '{"detail":{"code":"hourly_message_limit","message":"Rate limited","limit":20,"retry_at":"2026-10-12T13:00:00Z"}}',
            429,
          );
        });

        expect(
          client.streamConversation(requestId: 'req-s1', query: 'Q').toList(),
          throwsA(
            isA<LearnLensException>()
                .having((e) => e.statusCode, 'statusCode', 429)
                .having((e) => e.code, 'code', 'hourly_message_limit')
                .having((e) => e.limit, 'limit', 20)
                .having((e) => e.retryAt, 'retryAt', isNotNull)
                .having((e) => e.isQuotaOrRateLimit, 'isQuota', isTrue),
          ),
        );
      },
    );

    test('normalizes a 409 generation_in_progress error', () async {
      useHandler((options) async {
        return jsonResponse(
          '{"detail":{"code":"generation_in_progress","message":"Another message is being answered."}}',
          409,
        );
      });

      expect(
        client
            .streamFollowUpMessage(
              chatId: 'chat-s1',
              requestId: 'req-s3',
              query: 'Q',
            )
            .toList(),
        throwsA(
          isA<LearnLensException>()
              .having((e) => e.statusCode, 'statusCode', 409)
              .having((e) => e.code, 'code', 'generation_in_progress'),
        ),
      );
    });

    test(
      'normalizes a 422 validation array error with a readable message',
      () async {
        useHandler((options) async {
          return jsonResponse(
            '{"detail":[{"type":"missing","loc":["body","request_id"],"msg":"Field required"}]}',
            422,
          );
        });

        expect(
          client.streamConversation(requestId: 'req-s1', query: 'Q').toList(),
          throwsA(
            isA<LearnLensException>()
                .having((e) => e.statusCode, 'statusCode', 422)
                .having((e) => e.code, 'code', 'validation_error')
                .having(
                  (e) => e.message,
                  'message',
                  contains('Field required'),
                ),
          ),
        );
      },
    );

    test(
      'falls back to a single done event when the server returns JSON',
      () async {
        useHandler((options) async => jsonResponse(doneData, 200));

        final events = await client
            .streamConversation(requestId: 'req-s1', query: 'Q')
            .toList();

        expect(events.length, 1);
        expect(events.single.isDone, isTrue);
        expect(events.single.turn!.answer, 'F = ma');
      },
    );

    test('surfaces malformed event JSON as a LearnLensException', () async {
      useHandler((options) async {
        return sseResponse([
          'event: accepted\ndata: $acceptedData\n\n',
          'event: delta\ndata: {not json}\n\n',
        ]);
      });

      final received = <AiChatStreamEvent>[];
      Object? error;
      try {
        await for (final event in client.streamConversation(
          requestId: 'req-s1',
          query: 'Q',
        )) {
          received.add(event);
        }
      } catch (e) {
        error = e;
      }

      expect(received.length, 1);
      expect(
        error,
        isA<LearnLensException>().having(
          (e) => e.code,
          'code',
          'malformed_stream_event',
        ),
      );
    });

    test('rejects an unexpected non-JSON, non-SSE body', () async {
      useHandler((options) async {
        return ResponseBody.fromString(
          '<html>gateway</html>',
          200,
          headers: {
            Headers.contentTypeHeader: ['text/html'],
          },
        );
      });

      expect(
        client.streamConversation(requestId: 'req-s1', query: 'Q').toList(),
        throwsA(
          isA<LearnLensException>().having(
            (e) => e.code,
            'code',
            'malformed_stream',
          ),
        ),
      );
    });

    test('repository validates the query before opening a stream', () {
      final repository = LearnLensRepository(
        client: client,
        sessionManager: sessionManager,
      );

      expect(
        () => repository.streamConversation(requestId: 'req-x', query: '   '),
        throwsA(
          isA<LearnLensException>().having(
            (e) => e.code,
            'code',
            'invalid_message',
          ),
        ),
      );
      expect(capturedRequests, isEmpty);
    });
  });

  group('LearnLensRepository', () {
    late LearnLensRepository repository;
    late LearnLensNetworkClient client;
    late LearnLensSessionManager sessionManager;

    setUp(() {
      final testSession = AiChatSessionDto(
        sessionToken: 'test-session-token',
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        expiresAtMs: DateTime.now().millisecondsSinceEpoch + 3600000,
        baseUrl: 'https://learnlens.example/api/v2/org1/generic',
        policy: const AiChatPolicyDto(maxMessagesPerConversation: 25),
      );

      final mockRepoDio = Dio(
        BaseOptions(baseUrl: 'https://learnlens.example/api/v2/org1/generic'),
      );
      mockRepoDio.httpClientAdapter = _MockHttpClientAdapter((options) async {
        if (options.path.endsWith('/chats/chat-1/')) {
          return ResponseBody.fromString(
            '{"chat_id":"chat-1","title":"Chat 1","generation":{"generation_id":"gen-1","request_id":"req-1","user_message_id":"usr-1","status":"completed","created_at":"2026-10-12T12:00:00Z"}}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }
        if (options.path.contains('/messages/')) {
          return ResponseBody.fromString(
            '{"items":[{"message_id":"msg-ast-1","role":"assistant","content":"Recovered answer","created_at":"2026-10-12T12:00:05Z"}],"next_cursor":null}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }
        return ResponseBody.fromString('{}', 200);
      });

      sessionManager = LearnLensSessionManager(
        dio: Dio(),
        initialSession: testSession,
      );

      client = LearnLensNetworkClient(
        dio: mockRepoDio,
        sessionManager: sessionManager,
      );

      repository = LearnLensRepository(
        client: client,
        sessionManager: sessionManager,
      );
    });

    test('exposes policy from sessionManager', () {
      expect(repository.policy?.maxMessagesPerConversation, 25);
    });

    test('validates message query length and rejects empty query', () {
      expect(
        () => repository.validateMessage('   '),
        throwsA(
          isA<LearnLensException>().having(
            (e) => e.code,
            'code',
            'invalid_message',
          ),
        ),
      );

      final oversized = 'a' * 4001;
      expect(
        () => repository.validateMessage(oversized),
        throwsA(
          isA<LearnLensException>()
              .having((e) => e.code, 'code', 'message_too_long')
              .having((e) => e.limit, 'limit', 4000),
        ),
      );
    });

    test(
      'prependMessages combines older and current messages with deduplication',
      () {
        final now = DateTime.now().toUtc();
        final older = [
          AiMessageDto(
            messageId: 'msg-1',
            role: 'user',
            content: 'First',
            createdAt: now.subtract(const Duration(minutes: 5)),
          ),
          AiMessageDto(
            messageId: 'msg-2',
            role: 'assistant',
            content: 'Second',
            createdAt: now.subtract(const Duration(minutes: 4)),
          ),
        ];

        final current = [
          AiMessageDto(
            messageId: 'msg-2', // duplicate
            role: 'assistant',
            content: 'Second duplicate',
            createdAt: now.subtract(const Duration(minutes: 4)),
          ),
          AiMessageDto(
            messageId: 'msg-3',
            role: 'user',
            content: 'Third',
            createdAt: now,
          ),
        ];

        final combined = repository.prependMessages(
          currentMessages: current,
          olderMessages: older,
        );

        expect(combined.length, 3);
        expect(combined[0].messageId, 'msg-1');
        expect(combined[1].messageId, 'msg-2');
        expect(combined[2].messageId, 'msg-3');
      },
    );
  });

  group('UuidUtils', () {
    test('generates valid RFC 4122 v4 UUID format', () {
      final uuid1 = UuidUtils.v4();
      final uuid2 = UuidUtils.v4();

      final regex = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );

      expect(regex.hasMatch(uuid1), isTrue);
      expect(regex.hasMatch(uuid2), isTrue);
      expect(uuid1, isNot(equals(uuid2)));
    });
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
