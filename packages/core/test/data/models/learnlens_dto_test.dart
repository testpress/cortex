import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/learnlens_dto.dart';

void main() {
  group('AiChatPolicyDto', () {
    test('parses full json correctly', () {
      final json = {
        'max_messages_per_conversation': 25,
        'max_messages_per_hour': 30,
        'max_new_conversations_per_day': 15,
        'max_message_characters': 5000,
        'institute_timezone': 'Asia/Dubai',
      };

      final policy = AiChatPolicyDto.fromJson(json);

      expect(policy.maxMessagesPerConversation, 25);
      expect(policy.maxMessagesPerHour, 30);
      expect(policy.maxNewConversationsPerDay, 15);
      expect(policy.maxMessageCharacters, 5000);
      expect(policy.instituteTimezone, 'Asia/Dubai');
    });

    test('uses sensible defaults for empty or null json values', () {
      final policy = AiChatPolicyDto.fromJson({});

      expect(policy.maxMessagesPerConversation, 20);
      expect(policy.maxMessagesPerHour, 20);
      expect(policy.maxNewConversationsPerDay, 10);
      expect(policy.maxMessageCharacters, 4000);
      expect(policy.instituteTimezone, 'Asia/Kolkata');
    });
  });

  group('AiChatSessionDto', () {
    test(
      'parses session response and strips trailing slashes from baseUrl',
      () {
        final nowMs = DateTime.now().millisecondsSinceEpoch + 7200000;
        final json = {
          'session_token': 'test-session-123',
          'expiresAt': nowMs,
          'base_url': 'https://learnlens.example/api/v2/org1/generic///',
          'policy': {'max_messages_per_conversation': 20},
          'attachments_enabled': false,
        };

        final session = AiChatSessionDto.fromJson(json);

        expect(session.sessionToken, 'test-session-123');
        expect(
          session.baseUrl,
          'https://learnlens.example/api/v2/org1/generic',
        );
        expect(session.expiresAtMs, nowMs);
        expect(session.isExpired, isFalse);
        expect(session.attachmentsEnabled, isFalse);
        expect(session.policy.maxMessagesPerConversation, 20);
      },
    );

    test('detects expired session correctly', () {
      final pastMs = DateTime.now().millisecondsSinceEpoch - 10000;
      final json = {
        'session_token': 'expired-token',
        'expiresAt': pastMs,
        'base_url': 'https://learnlens.example',
      };

      final session = AiChatSessionDto.fromJson(json);

      expect(session.isExpired, isTrue);
    });
  });

  group('AiGenerationDto', () {
    test('parses completed generation correctly', () {
      final json = {
        'generation_id': 'gen-123',
        'request_id': 'req-abc',
        'user_message_id': 'usr-msg-1',
        'assistant_message_id': 'ast-msg-1',
        'status': 'completed',
        'error_code': null,
        'error_message': null,
        'created_at': '2026-10-12T12:00:00Z',
        'finished_at': '2026-10-12T12:00:05Z',
      };

      final gen = AiGenerationDto.fromJson(json);

      expect(gen.generationId, 'gen-123');
      expect(gen.requestId, 'req-abc');
      expect(gen.userMessageId, 'usr-msg-1');
      expect(gen.assistantMessageId, 'ast-msg-1');
      expect(gen.isCompleted, isTrue);
      expect(gen.isProcessing, isFalse);
      expect(gen.isFailed, isFalse);
      expect(gen.finishedAt, isNotNull);
    });

    test('parses processing generation correctly with null finishedAt', () {
      final json = {
        'generation_id': 'gen-123',
        'request_id': 'req-abc',
        'user_message_id': 'usr-msg-1',
        'assistant_message_id': null,
        'status': 'processing',
        'created_at': '2026-10-12T12:00:00Z',
        'finished_at': null,
      };

      final gen = AiGenerationDto.fromJson(json);

      expect(gen.isProcessing, isTrue);
      expect(gen.isCompleted, isFalse);
      expect(gen.assistantMessageId, isNull);
      expect(gen.finishedAt, isNull);
    });

    test('parses failed generation with error_code and error_message', () {
      final json = {
        'generation_id': 'gen-123',
        'request_id': 'req-abc',
        'user_message_id': 'usr-msg-1',
        'assistant_message_id': null,
        'status': 'failed',
        'error_code': 'generation_failed',
        'error_message': 'Unable to generate response',
        'created_at': '2026-10-12T12:00:00Z',
        'finished_at': '2026-10-12T12:00:05Z',
      };

      final gen = AiGenerationDto.fromJson(json);

      expect(gen.isFailed, isTrue);
      expect(gen.errorCode, 'generation_failed');
      expect(gen.errorMessage, 'Unable to generate response');
    });
  });

  group('AiConversationDto & AiConversationListDto', () {
    test('parses conversation items and cursor', () {
      final json = {
        'items': [
          {
            'chat_id': 'chat-1',
            'title': "Newton's Laws",
            'updated_at': '2026-10-12T12:00:05Z',
          },
          {'chat_id': 'chat-2', 'title': '', 'updated_at': null},
        ],
        'next_cursor': 'cursor-xyz',
      };

      final list = AiConversationListDto.fromJson(json);

      expect(list.items.length, 2);
      expect(list.items[0].chatId, 'chat-1');
      expect(list.items[0].title, "Newton's Laws");
      expect(list.items[1].title, '');
      expect(list.nextCursor, 'cursor-xyz');
    });
  });

  group('AiMessageDto & AiMessageListDto', () {
    test('parses messages with generation metadata', () {
      final json = {
        'items': [
          {
            'message_id': 'msg-1',
            'role': 'user',
            'message_type': 'text',
            'content': 'What is inertia?',
            'citations': [],
            'created_at': '2026-10-12T12:00:00Z',
            'generation': {
              'generation_id': 'gen-1',
              'request_id': 'req-1',
              'user_message_id': 'msg-1',
              'assistant_message_id': 'msg-2',
              'status': 'completed',
              'created_at': '2026-10-12T12:00:00Z',
            },
          },
          {
            'message_id': 'msg-2',
            'role': 'assistant',
            'message_type': 'text',
            'content': 'Inertia is resistance to change in motion.',
            'citations': [],
            'created_at': '2026-10-12T12:00:05Z',
            'generation': null,
          },
        ],
        'next_cursor': null,
      };

      final list = AiMessageListDto.fromJson(json);

      expect(list.items.length, 2);
      expect(list.items[0].isUser, isTrue);
      expect(list.items[0].generation, isNotNull);
      expect(list.items[0].generation!.isCompleted, isTrue);
      expect(list.items[1].isAssistant, isTrue);
      expect(list.items[1].generation, isNull);
      expect(list.nextCursor, isNull);
    });
  });

  group('AiChatTurnResponseDto', () {
    test('parses synchronous response with answer and generation', () {
      final json = {
        'answer': 'F = ma',
        'chat_id': 'chat-100',
        'title': "Newton's Law",
        'generation': {
          'generation_id': 'gen-100',
          'request_id': 'req-100',
          'user_message_id': 'usr-100',
          'assistant_message_id': 'ast-100',
          'status': 'completed',
          'created_at': '2026-10-12T12:00:00Z',
        },
      };

      final turn = AiChatTurnResponseDto.fromJson(json);

      expect(turn.answer, 'F = ma');
      expect(turn.chatId, 'chat-100');
      expect(turn.title, "Newton's Law");
      expect(turn.generation.isCompleted, isTrue);
    });
  });

  group('AiChatQuotaErrorDto', () {
    test('parses object detail with limit and retry_at', () {
      final detail = {
        'code': 'hourly_message_limit',
        'message': 'You have reached your hourly limit.',
        'limit': 20,
        'retry_at': '2026-10-12T13:00:00Z',
      };

      final error = AiChatQuotaErrorDto.fromDetail(detail);

      expect(error.code, 'hourly_message_limit');
      expect(error.message, 'You have reached your hourly limit.');
      expect(error.limit, 20);
      expect(error.retryAt, isNotNull);
      expect(error.retryAt!.toIso8601String(), contains('2026-10-12T13:00:00'));
    });

    test('parses string detail', () {
      final error = AiChatQuotaErrorDto.fromDetail('Session expired.');

      expect(error.code, 'error');
      expect(error.message, 'Session expired.');
    });

    test('parses array validation error', () {
      final detail = [
        {
          'type': 'missing',
          'loc': ['body', 'request_id'],
          'msg': 'Field required',
        },
      ];

      final error = AiChatQuotaErrorDto.fromDetail(detail);

      expect(error.code, 'validation_error');
      expect(error.message, 'Field required (body.request_id)');
    });
  });
}
