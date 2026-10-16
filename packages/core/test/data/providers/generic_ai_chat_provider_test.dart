import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/repositories/learnlens_repository.dart';

class _FakeLearnLensRepository implements LearnLensRepository {
  int startConversationCalls = 0;
  int sendFollowUpCalls = 0;
  int getStatusCalls = 0;
  int getMessagesCalls = 0;
  int listConversationsCalls = 0;
  int ensureSessionCalls = 0;

  String? lastQuery;
  String? lastRequestId;
  String? lastChatId;

  AiChatTurnResponseDto? nextTurnResponse;
  AiConversationDto? nextStatusResponse;
  AiMessagePageResult? nextMessagePage;
  AiConversationListDto? nextConversationList;
  Object? errorToThrow;
  Completer<AiChatTurnResponseDto>? turnCompleter;
  Completer<AiMessagePageResult>? messagePageCompleter;

  @override
  AiChatPolicyDto? get policy =>
      const AiChatPolicyDto(maxMessageCharacters: 4000);

  Object? ensureSessionError;

  @override
  Future<void> ensureGenericChatSession() async {
    ensureSessionCalls++;
    if (ensureSessionError != null) {
      throw ensureSessionError!;
    }
  }

  @override
  Future<AiChatTurnResponseDto> startConversation({
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) async {
    startConversationCalls++;
    lastRequestId = requestId;
    lastQuery = query;

    if (errorToThrow != null) {
      throw errorToThrow!;
    }

    if (turnCompleter != null) {
      return turnCompleter!.future;
    }

    return nextTurnResponse ??
        AiChatTurnResponseDto(
          chatId: 'chat-123',
          title: 'Title of $query',
          answer: 'Answer to $query',
          generation: AiGenerationDto(
            generationId: 'gen-1',
            requestId: requestId,
            userMessageId: 'usr-1',
            status: 'completed',
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  @override
  Future<AiChatTurnResponseDto> sendFollowUpMessage({
    required String chatId,
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) async {
    sendFollowUpCalls++;
    lastChatId = chatId;
    lastRequestId = requestId;
    lastQuery = query;

    if (errorToThrow != null) {
      throw errorToThrow!;
    }

    return nextTurnResponse ??
        AiChatTurnResponseDto(
          chatId: chatId,
          title: 'Follow-up Title',
          answer: 'Follow-up answer to $query',
          generation: AiGenerationDto(
            generationId: 'gen-2',
            requestId: requestId,
            userMessageId: 'usr-2',
            status: 'completed',
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Completer<AiConversationDto>? statusCompleter;

  @override
  Future<AiConversationDto> getConversationStatus({
    required String chatId,
    CancelToken? cancelToken,
  }) async {
    getStatusCalls++;
    if (statusCompleter != null) {
      return statusCompleter!.future;
    }
    return nextStatusResponse ??
        AiConversationDto(
          chatId: chatId,
          title: 'Conversation Status',
          generation: AiGenerationDto(
            generationId: 'gen-poll',
            requestId: 'req-poll',
            userMessageId: 'usr-poll',
            status: 'completed',
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Object? getMessagesError;

  @override
  Future<AiMessagePageResult> getMessages({
    required String chatId,
    int limit = 20,
    String? before,
    CancelToken? cancelToken,
  }) async {
    getMessagesCalls++;
    if (getMessagesError != null) {
      throw getMessagesError!;
    }
    if (messagePageCompleter != null) {
      return messagePageCompleter!.future;
    }
    return nextMessagePage ??
        AiMessagePageResult(
          items: [
            AiMessageDto(
              messageId: 'msg-1',
              role: 'user',
              content: 'What is Newton second law?',
              createdAt: DateTime(2026, 10, 16, 10, 0),
            ),
            AiMessageDto(
              messageId: 'msg-2',
              role: 'assistant',
              content: 'F = ma',
              createdAt: DateTime(2026, 10, 16, 10, 1),
            ),
          ],
        );
  }

  Object? listConversationsError;

  @override
  Future<AiConversationListDto> listConversations({
    int limit = 20,
    String? cursor,
  }) async {
    listConversationsCalls++;
    if (listConversationsError != null) {
      throw listConversationsError!;
    }
    return nextConversationList ??
        const AiConversationListDto(
          items: [
            AiConversationDto(chatId: 'hist-1', title: 'Calculus Help'),
            AiConversationDto(chatId: 'hist-2', title: 'Physics Vectors'),
          ],
        );
  }

  @override
  void validateMessage(String query) {}

  @override
  List<AiMessageDto> prependMessages({
    required List<AiMessageDto> olderMessages,
    required List<AiMessageDto> currentMessages,
  }) {
    return [...olderMessages, ...currentMessages];
  }

  @override
  Future<Map<String, dynamic>> createSession(int contentId) async => {};

  @override
  Future<LearnLensQuizResponseDto> fetchQuiz({
    required String orgUuid,
    required String assetId,
    String? sessionToken,
    int? contentId,
    String difficulty = 'medium',
    int questionCount = 5,
  }) async {
    return LearnLensQuizResponseDto(questions: []);
  }

  @override
  Future<LearnLensChatResponseDto> submitChat({
    required String orgUuid,
    required String assetId,
    String? sessionToken,
    int? contentId,
    required String query,
    required String conversationId,
  }) async {
    return LearnLensChatResponseDto(answer: '', conversationId: '');
  }
}

void main() {
  late _FakeLearnLensRepository fakeRepository;
  late ProviderContainer container;

  setUp(() {
    fakeRepository = _FakeLearnLensRepository();
    container = ProviderContainer(
      overrides: [
        learnLensRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('GenericAiChatNotifier - Conversation & Turns', () {
    test('initialize prepares the generic chat session', () async {
      final notifier = container.read(genericAiChatProvider.notifier);

      await notifier.initialize();

      expect(fakeRepository.ensureSessionCalls, 1);
      expect(container.read(genericAiChatProvider).hasInitError, isFalse);
    });

    test(
      'initialize sets hasInitError to true when session creation fails and recovers',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);
        fakeRepository.ensureSessionError = Exception('Session network failed');

        await notifier.initialize();

        expect(container.read(genericAiChatProvider).hasInitError, isTrue);

        // Retry succeeding resets hasInitError
        fakeRepository.ensureSessionError = null;
        await notifier.initialize();

        expect(container.read(genericAiChatProvider).hasInitError, isFalse);
      },
    );

    test('initial state is empty with no active conversation', () {
      final state = container.read(genericAiChatProvider);
      expect(state.currentChatId, isNull);
      expect(state.messages, isEmpty);
      expect(state.isSending, isFalse);
      expect(state.isGenerating, isFalse);
    });

    test(
      'sendMessage creates optimistic user message and dispatches startConversation when no chatId',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);

        final future = notifier.sendMessage('Explain thermodynamics');

        // Optimistic message should be present while waiting
        expect(container.read(genericAiChatProvider).messages.length, 1);
        expect(
          container.read(genericAiChatProvider).messages.first.text,
          'Explain thermodynamics',
        );
        expect(
          container.read(genericAiChatProvider).messages.first.isSending,
          isTrue,
        );

        await future;

        final state = container.read(genericAiChatProvider);
        expect(fakeRepository.startConversationCalls, 1);
        expect(state.currentChatId, 'chat-123');
        expect(state.messages.length, 2);
        expect(state.messages[0].isUser, isTrue);
        expect(state.messages[0].isSending, isFalse);
        expect(state.messages[1].isUser, isFalse);
        expect(state.messages[1].text, 'Answer to Explain thermodynamics');
        expect(state.isSending, isFalse);
        expect(state.isGenerating, isFalse);
      },
    );

    test(
      'sendMessage calls sendFollowUpMessage when chatId is already active',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);

        // First message
        await notifier.sendMessage('First query');
        expect(container.read(genericAiChatProvider).currentChatId, 'chat-123');

        // Follow up
        await notifier.sendMessage('Can you give an example?');

        expect(fakeRepository.sendFollowUpCalls, 1);
        expect(fakeRepository.lastChatId, 'chat-123');
        expect(container.read(genericAiChatProvider).messages.length, 4);
      },
    );

    test('empty or whitespace query is ignored', () async {
      final notifier = container.read(genericAiChatProvider.notifier);

      await notifier.sendMessage('   ');

      expect(fakeRepository.startConversationCalls, 0);
      expect(container.read(genericAiChatProvider).messages, isEmpty);
    });
  });

  group('GenericAiChatNotifier - Error Handling & Retry', () {
    test(
      'network failure marks user message as hasSendError and keeps requestId',
      () async {
        fakeRepository.errorToThrow = const LearnLensException(
          message: 'No Internet connection',
          code: 'network_error',
        );

        final notifier = container.read(genericAiChatProvider.notifier);
        await notifier.sendMessage('Hello AI');

        final state = container.read(genericAiChatProvider);
        expect(state.messages.length, 1);
        expect(state.messages.first.hasSendError, isTrue);
        expect(state.messages.first.errorMessage, 'No Internet connection');
        expect(state.messages.first.errorCode, 'network_error');
        expect(state.messages.first.requestId, isNotNull);

        // Clear error and retry
        fakeRepository.errorToThrow = null;
        await notifier.retryLastSend();

        final updatedState = container.read(genericAiChatProvider);
        expect(updatedState.messages.length, 2);
        expect(updatedState.messages[0].hasSendError, isFalse);
        expect(fakeRepository.startConversationCalls, 2);
        // Ensures the original request ID was preserved for idempotency
        expect(fakeRepository.lastRequestId, state.messages.first.requestId);
      },
    );

    test(
      'generation failure from server renders assistant failure card and allows retry',
      () async {
        fakeRepository.nextTurnResponse = AiChatTurnResponseDto(
          chatId: 'chat-fail',
          title: 'Failed query',
          answer: null,
          generation: AiGenerationDto(
            generationId: 'gen-failed',
            requestId: 'req-fail',
            userMessageId: 'usr-1',
            status: 'failed',
            errorMessage: 'Server overloaded. Please try again.',
            createdAt: DateTime.now().toUtc(),
          ),
        );

        final notifier = container.read(genericAiChatProvider.notifier);
        await notifier.sendMessage('Trigger fail');

        final state = container.read(genericAiChatProvider);
        expect(state.messages.length, 2);
        expect(state.messages[1].hasGenerationError, isTrue);
        expect(
          state.messages[1].errorMessage,
          'Server overloaded. Please try again.',
        );
        expect(state.messages[1].errorCode, 'generation_failed');

        // Retrying generation resubmits the preceding user prompt
        fakeRepository.nextTurnResponse = null;
        await notifier.retryGeneration();

        expect(fakeRepository.lastQuery, 'Trigger fail');
      },
    );

    test(
      'in-flight status polling times out after maxPollingAttempts and unlocks composer',
      () async {
        fakeRepository.nextTurnResponse = AiChatTurnResponseDto(
          chatId: 'chat-processing',
          title: 'Processing query',
          answer: null,
          generation: AiGenerationDto(
            generationId: 'gen-proc',
            requestId: 'req-proc',
            userMessageId: 'usr-proc',
            status: 'processing',
            createdAt: DateTime.now().toUtc(),
          ),
        );

        // Keep returning processing
        fakeRepository.nextStatusResponse = AiConversationDto(
          chatId: 'chat-processing',
          generation: AiGenerationDto(
            generationId: 'gen-proc',
            requestId: 'req-proc',
            userMessageId: 'usr-proc',
            status: 'processing',
            createdAt: DateTime.now().toUtc(),
          ),
        );

        final notifier = container.read(genericAiChatProvider.notifier);
        notifier.maxPollingAttempts = 2;
        notifier.pollingInterval = const Duration(milliseconds: 10);

        await notifier.sendMessage('Please process this');

        final inFlightState = container.read(genericAiChatProvider);
        expect(inFlightState.isGenerating, isTrue);

        // Wait for polling attempts to exceed maxPollingAttempts
        await Future<void>.delayed(const Duration(milliseconds: 50));

        final timedOutState = container.read(genericAiChatProvider);
        expect(timedOutState.isGenerating, isFalse);
        expect(timedOutState.messages.length, 2);
        expect(timedOutState.messages[1].hasGenerationError, isTrue);
        expect(timedOutState.messages[1].errorCode, 'timeout');
      },
    );

    test(
      'HTTP 429 quota exhaustion surfaces retry_at and blocks subsequent sends',
      () async {
        final retryTime = DateTime.now().toUtc().add(
          const Duration(minutes: 30),
        );
        fakeRepository.errorToThrow = LearnLensException(
          message: 'Hourly quota reached',
          code: 'hourly_message_limit',
          retryAt: retryTime,
        );

        final notifier = container.read(genericAiChatProvider.notifier);
        await notifier.sendMessage('Hit quota');

        final state = container.read(genericAiChatProvider);
        expect(state.hasActiveRateLimit, isTrue);
        expect(state.quotaError, 'Hourly quota reached');

        // Subsequent send is blocked by rate limit
        await notifier.sendMessage('Another query while blocked');
        expect(fakeRepository.startConversationCalls, 1);
      },
    );

    test(
      'non-quota API error sets hasSendError on message but does not set quotaError',
      () async {
        fakeRepository.errorToThrow = const LearnLensException(
          message: 'Invalid session token',
          code: 'session_missing_or_expired',
          statusCode: 401,
        );

        final notifier = container.read(genericAiChatProvider.notifier);
        await notifier.sendMessage('Hello');

        final state = container.read(genericAiChatProvider);
        expect(state.hasActiveRateLimit, isFalse);
        expect(state.quotaError, isNull);
        expect(state.messages.length, 1);
        expect(state.messages.first.hasSendError, isTrue);
        expect(state.messages.first.errorMessage, 'Invalid session token');
        expect(state.messages.first.errorCode, 'session_missing_or_expired');
      },
    );

    test(
      'retryLastSend and retryGeneration do not remove items if rate limited or sending',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);

        // Seed a failed user message and a failed generation
        final retryTime = DateTime.now().toUtc().add(
          const Duration(minutes: 10),
        );
        notifier.setInitialMessages([
          GenericAiChatMessage(
            id: 'failed_usr_1',
            text: 'Prompt to retry',
            isUser: true,
            timestamp: DateTime.now(),
            hasSendError: true,
          ),
          GenericAiChatMessage(
            id: 'failed_gen_1',
            text: '',
            isUser: false,
            timestamp: DateTime.now(),
            hasGenerationError: true,
          ),
        ]);

        // Put provider in rate-limited state
        fakeRepository.errorToThrow = LearnLensException(
          message: 'Rate limited',
          code: 'rate_limited',
          statusCode: 429,
          retryAt: retryTime,
        );
        await notifier.sendMessage('Trigger rate limit');

        expect(
          container.read(genericAiChatProvider).hasActiveRateLimit,
          isTrue,
        );

        // Attempt retryLastSend while rate limited
        await notifier.retryLastSend(messageId: 'failed_usr_1');
        final stateAfterRetrySend = container.read(genericAiChatProvider);
        expect(
          stateAfterRetrySend.messages.any((m) => m.id == 'failed_usr_1'),
          isTrue,
          reason:
              'Failed user message should not be removed when retry is blocked',
        );

        // Attempt retryGeneration while rate limited
        await notifier.retryGeneration();
        final stateAfterRetryGen = container.read(genericAiChatProvider);
        expect(
          stateAfterRetryGen.messages.any((m) => m.id == 'failed_gen_1'),
          isTrue,
          reason:
              'Failed generation message should not be removed when retry is blocked',
        );
      },
    );
  });

  group('GenericAiChatNotifier - Conversation History & Reset', () {
    test(
      'loadConversations populates history and supports pagination',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);

        await notifier.loadConversations(refresh: true);

        final state = container.read(genericAiChatProvider);
        expect(fakeRepository.listConversationsCalls, 1);
        expect(state.conversationHistory.length, 2);
        expect(state.conversationHistory[0].title, 'Calculus Help');
      },
    );

    test(
      'loadConversations deduplicates conversation items by chatId on subsequent calls',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);

        // First load
        await notifier.loadConversations(refresh: true);
        expect(
          container.read(genericAiChatProvider).conversationHistory.length,
          2,
        );

        // Second load with overlapping items without refresh
        await notifier.loadConversations(refresh: false);
        expect(
          container.read(genericAiChatProvider).conversationHistory.length,
          2,
        );
      },
    );

    test(
      'loadConversations sets hasHistoryError to true when repository throws and recovers on retry',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);
        fakeRepository.listConversationsError = Exception('Network error');

        await notifier.loadConversations(refresh: true);

        final state = container.read(genericAiChatProvider);
        expect(state.isLoadingHistory, isFalse);
        expect(state.hasHistoryError, isTrue);
        expect(state.conversationHistory, isEmpty);

        // Next successful load clears hasHistoryError
        fakeRepository.listConversationsError = null;
        await notifier.loadConversations(refresh: true);

        final updatedState = container.read(genericAiChatProvider);
        expect(updatedState.hasHistoryError, isFalse);
        expect(updatedState.conversationHistory, isNotEmpty);
      },
    );

    test(
      'selectConversation switches thread and loads message history',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);

        await notifier.selectConversation('hist-1');

        final state = container.read(genericAiChatProvider);
        expect(fakeRepository.getMessagesCalls, 1);
        expect(state.currentChatId, 'hist-1');
        expect(state.messages.length, 2);
        expect(state.messages[0].text, 'What is Newton second law?');
        expect(state.messages[1].text, 'F = ma');
      },
    );

    test(
      'selectConversation sets hasMessagesError to true when getMessages fails and recovers on retry',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);

        fakeRepository.getMessagesError = Exception(
          '401 Invalid session token',
        );

        await notifier.selectConversation('hist-1');

        final state = container.read(genericAiChatProvider);
        expect(state.isLoadingMessages, isFalse);
        expect(state.hasMessagesError, isTrue);
        expect(state.messages, isEmpty);

        // Next successful load clears hasMessagesError
        fakeRepository.getMessagesError = null;
        await notifier.selectConversation('hist-1');

        final updatedState = container.read(genericAiChatProvider);
        expect(updatedState.hasMessagesError, isFalse);
        expect(updatedState.messages, isNotEmpty);
      },
    );

    test('startNewChat resets state to a clean canvas', () async {
      final notifier = container.read(genericAiChatProvider.notifier);
      await notifier.sendMessage('Query to reset');
      expect(container.read(genericAiChatProvider).messages, isNotEmpty);

      notifier.startNewChat();

      final state = container.read(genericAiChatProvider);
      expect(state.currentChatId, isNull);
      expect(state.messages, isEmpty);
      expect(state.isSending, isFalse);
    });

    test(
      'in-flight sendMessage does not corrupt active conversation when user starts a new chat',
      () async {
        final completer = Completer<AiChatTurnResponseDto>();
        fakeRepository.turnCompleter = completer;

        final notifier = container.read(genericAiChatProvider.notifier);
        // Start sending in conversation A (in-flight)
        final sendFuture = notifier.sendMessage('Question in A');

        expect(container.read(genericAiChatProvider).messages.length, 1);
        expect(container.read(genericAiChatProvider).isSending, isTrue);

        // User starts a new chat before response arrives
        notifier.startNewChat();

        expect(container.read(genericAiChatProvider).messages, isEmpty);
        expect(container.read(genericAiChatProvider).currentChatId, isNull);

        // Response for conversation A finally arrives
        completer.complete(
          AiChatTurnResponseDto(
            chatId: 'chat-A',
            title: 'Chat A',
            answer: 'Late answer for A',
            generation: AiGenerationDto(
              generationId: 'gen-A',
              requestId: 'req-A',
              userMessageId: 'usr-A',
              status: 'completed',
              createdAt: DateTime.now().toUtc(),
            ),
          ),
        );
        await sendFuture;

        // State remains clean and empty canvas, not corrupted by chat A
        final state = container.read(genericAiChatProvider);
        expect(state.currentChatId, isNull);
        expect(state.messages, isEmpty);
        expect(state.isSending, isFalse);
        expect(state.isGenerating, isFalse);
      },
    );

    test(
      'in-flight sendMessage does not corrupt state when user switches conversation',
      () async {
        final completer = Completer<AiChatTurnResponseDto>();
        fakeRepository.turnCompleter = completer;

        final notifier = container.read(genericAiChatProvider.notifier);
        final sendFuture = notifier.sendMessage('Question in A');

        // User switches to conversation B while A is in-flight
        fakeRepository.turnCompleter = null;
        await notifier.selectConversation('chat-B');

        expect(container.read(genericAiChatProvider).currentChatId, 'chat-B');

        // Response for A completes
        completer.complete(
          AiChatTurnResponseDto(
            chatId: 'chat-A',
            title: 'Chat A',
            answer: 'Late answer for A',
            generation: AiGenerationDto(
              generationId: 'gen-A',
              requestId: 'req-A',
              userMessageId: 'usr-A',
              status: 'completed',
              createdAt: DateTime.now().toUtc(),
            ),
          ),
        );
        await sendFuture;

        // Still on chat-B, not overwritten by chat-A
        final state = container.read(genericAiChatProvider);
        expect(state.currentChatId, 'chat-B');
        expect(
          state.messages.any((m) => m.text == 'Late answer for A'),
          isFalse,
        );
      },
    );

    test(
      'superseded polling callback does not cancel newer conversation polling timer',
      () async {
        final notifier = container.read(genericAiChatProvider.notifier);
        notifier.pollingInterval = const Duration(milliseconds: 10);

        // Chat A in processing
        fakeRepository.nextTurnResponse = AiChatTurnResponseDto(
          chatId: 'chat-A',
          title: 'Chat A',
          answer: null,
          generation: AiGenerationDto(
            generationId: 'gen-A',
            requestId: 'req-A',
            userMessageId: 'usr-A',
            status: 'processing',
            createdAt: DateTime.now().toUtc(),
          ),
        );

        final statusCompleterA = Completer<AiConversationDto>();
        fakeRepository.statusCompleter = statusCompleterA;

        await notifier.sendMessage('Query A');
        expect(container.read(genericAiChatProvider).isGenerating, isTrue);

        // Wait for first poll tick of Chat A to be in-flight
        await Future<void>.delayed(const Duration(milliseconds: 15));
        expect(fakeRepository.getStatusCalls, 1);

        // User now starts Chat B while Chat A's poll is still awaiting statusCompleterA
        fakeRepository.statusCompleter = null;
        fakeRepository.nextTurnResponse = AiChatTurnResponseDto(
          chatId: 'chat-B',
          title: 'Chat B',
          answer: null,
          generation: AiGenerationDto(
            generationId: 'gen-B',
            requestId: 'req-B',
            userMessageId: 'usr-B',
            status: 'processing',
            createdAt: DateTime.now().toUtc(),
          ),
        );
        fakeRepository.nextStatusResponse = AiConversationDto(
          chatId: 'chat-B',
          generation: AiGenerationDto(
            generationId: 'gen-B',
            requestId: 'req-B',
            userMessageId: 'usr-B',
            status: 'completed',
            createdAt: DateTime.now().toUtc(),
          ),
        );

        notifier.startNewChat();
        await notifier.sendMessage('Query B');
        expect(container.read(genericAiChatProvider).currentChatId, 'chat-B');

        // Now Chat A's late status poll finally resolves
        statusCompleterA.complete(
          AiConversationDto(
            chatId: 'chat-A',
            generation: AiGenerationDto(
              generationId: 'gen-A',
              requestId: 'req-A',
              userMessageId: 'usr-A',
              status: 'processing',
              createdAt: DateTime.now().toUtc(),
            ),
          ),
        );

        // Allow Chat B's polling to tick and complete
        await Future<void>.delayed(const Duration(milliseconds: 30));

        final state = container.read(genericAiChatProvider);
        expect(state.currentChatId, 'chat-B');
        expect(state.isGenerating, isFalse);
      },
    );
  });
}
