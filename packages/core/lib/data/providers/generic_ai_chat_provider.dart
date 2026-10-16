import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../network/uuid_utils.dart';
import '../data.dart';
import '../repositories/learnlens_repository.dart';

part 'generic_ai_chat_provider.g.dart';

const Object _sentinel = Object();

/// View model representing an individual chat message in the UI.
class GenericAiChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isSending;
  final bool hasSendError;
  final bool hasGenerationError;
  final String? errorMessage;
  final String? errorCode;
  final String? requestId;

  const GenericAiChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isSending = false,
    this.hasSendError = false,
    this.hasGenerationError = false,
    this.errorMessage,
    this.errorCode,
    this.requestId,
  });

  GenericAiChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isSending,
    bool? hasSendError,
    bool? hasGenerationError,
    Object? errorMessage = _sentinel,
    Object? errorCode = _sentinel,
    Object? requestId = _sentinel,
  }) {
    return GenericAiChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isSending: isSending ?? this.isSending,
      hasSendError: hasSendError ?? this.hasSendError,
      hasGenerationError: hasGenerationError ?? this.hasGenerationError,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      errorCode: errorCode == _sentinel ? this.errorCode : errorCode as String?,
      requestId: requestId == _sentinel ? this.requestId : requestId as String?,
    );
  }

  factory GenericAiChatMessage.fromDto(AiMessageDto dto) {
    final gen = dto.generation;
    final isGenFailed = gen?.isFailed == true;
    final isProcessing = gen?.isProcessing == true;

    return GenericAiChatMessage(
      id: dto.messageId,
      text: dto.content,
      isUser: dto.isUser,
      timestamp: dto.createdAt,
      isSending: isProcessing,
      hasGenerationError: isGenFailed,
      errorMessage: gen?.errorMessage,
      errorCode: isGenFailed ? (gen?.status ?? 'generation_failed') : null,
      requestId: gen?.requestId,
    );
  }
}

/// State of the Generic AI Chat screen and conversation thread.
class GenericAiChatState {
  final String? currentChatId;
  final String currentTitle;
  final List<GenericAiChatMessage> messages;
  final bool isSending;
  final bool isGenerating;
  final bool isLoadingMessages;
  final bool hasMessagesError;
  final Object? messagesError;
  final String? quotaError;
  final DateTime? retryAt;
  final List<AiConversationDto> conversationHistory;
  final String? historyCursor;
  final bool isLoadingHistory;
  final bool hasMoreHistory;
  final bool hasHistoryError;
  final Object? historyError;
  final bool hasInitError;

  const GenericAiChatState({
    this.currentChatId,
    this.currentTitle = '',
    this.messages = const [],
    this.isSending = false,
    this.isGenerating = false,
    this.isLoadingMessages = false,
    this.hasMessagesError = false,
    this.messagesError,
    this.quotaError,
    this.retryAt,
    this.conversationHistory = const [],
    this.historyCursor,
    this.isLoadingHistory = false,
    this.hasMoreHistory = false,
    this.hasHistoryError = false,
    this.historyError,
    this.hasInitError = false,
  });

  bool get hasActiveRateLimit {
    if (retryAt == null) return false;
    return DateTime.now().toUtc().isBefore(retryAt!);
  }

  GenericAiChatState copyWith({
    Object? currentChatId = _sentinel,
    String? currentTitle,
    List<GenericAiChatMessage>? messages,
    bool? isSending,
    bool? isGenerating,
    bool? isLoadingMessages,
    bool? hasMessagesError,
    Object? messagesError = _sentinel,
    Object? quotaError = _sentinel,
    Object? retryAt = _sentinel,
    List<AiConversationDto>? conversationHistory,
    Object? historyCursor = _sentinel,
    bool? isLoadingHistory,
    bool? hasMoreHistory,
    bool? hasHistoryError,
    Object? historyError = _sentinel,
    bool? hasInitError,
  }) {
    return GenericAiChatState(
      currentChatId: currentChatId == _sentinel
          ? this.currentChatId
          : currentChatId as String?,
      currentTitle: currentTitle ?? this.currentTitle,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isGenerating: isGenerating ?? this.isGenerating,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      hasMessagesError: hasMessagesError ?? this.hasMessagesError,
      messagesError: messagesError == _sentinel
          ? this.messagesError
          : messagesError,
      quotaError: quotaError == _sentinel
          ? this.quotaError
          : quotaError as String?,
      retryAt: retryAt == _sentinel ? this.retryAt : retryAt as DateTime?,
      conversationHistory: conversationHistory ?? this.conversationHistory,
      historyCursor: historyCursor == _sentinel
          ? this.historyCursor
          : historyCursor as String?,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      hasMoreHistory: hasMoreHistory ?? this.hasMoreHistory,
      hasHistoryError: hasHistoryError ?? this.hasHistoryError,
      historyError: historyError == _sentinel
          ? this.historyError
          : historyError,
      hasInitError: hasInitError ?? this.hasInitError,
    );
  }
}

/// Riverpod Notifier coordinating live AI chat operations with [LearnLensRepository].
@Riverpod(keepAlive: true)
class GenericAiChat extends _$GenericAiChat {
  /// Maximum polling attempts before timing out (30 attempts * 2s = 60s).
  static const int defaultMaxPollingAttempts = 30;

  @visibleForTesting
  int maxPollingAttempts = defaultMaxPollingAttempts;

  @visibleForTesting
  Duration pollingInterval = const Duration(seconds: 2);

  Timer? _pollingTimer;
  int _operationToken = 0;

  LearnLensRepository get _repository => ref.read(learnLensRepositoryProvider);

  @override
  GenericAiChatState build() {
    ref.onDispose(() {
      _operationToken++;
      _cancelPolling();
    });
    return const GenericAiChatState();
  }

  /// Prepares the generic chat session when the AI tab opens.
  Future<void> initialize() async {
    try {
      state = state.copyWith(hasInitError: false);
      await _repository.ensureGenericChatSession();
    } catch (e) {
      state = state.copyWith(hasInitError: true);
    }
  }

  /// Sends a user message. If no conversation is active, starts a new conversation;
  /// otherwise sends a follow-up query in the existing conversation.
  Future<void> sendMessage(String query, {String? customRequestId}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    if (state.isSending || state.isGenerating) {
      return;
    }

    if (state.hasActiveRateLimit) {
      return;
    }

    final token = _operationToken;
    final requestId = customRequestId ?? UuidUtils.v4();
    final tempUserId = 'temp_usr_${UuidUtils.v4()}';

    final optimisticUserMessage = GenericAiChatMessage(
      id: tempUserId,
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
      isSending: true,
      requestId: requestId,
    );

    state = state.copyWith(
      messages: [...state.messages, optimisticUserMessage],
      isSending: true,
      isGenerating: true,
      quotaError: null,
      retryAt: null,
    );

    try {
      final AiChatTurnResponseDto turn;
      if (state.currentChatId == null || state.currentChatId!.isEmpty) {
        turn = await _repository.startConversation(
          requestId: requestId,
          query: trimmed,
        );
      } else {
        turn = await _repository.sendFollowUpMessage(
          chatId: state.currentChatId!,
          requestId: requestId,
          query: trimmed,
        );
      }

      if (token != _operationToken) {
        return;
      }
      _handleTurnResponse(turn, tempUserId, token);
    } catch (e) {
      if (token != _operationToken) return;
      _handleSendError(e, tempUserId);
    }
  }

  void _handleTurnResponse(
    AiChatTurnResponseDto turn,
    String tempUserId,
    int token,
  ) {
    if (token != _operationToken) return;
    final updatedMessages = state.messages.map((m) {
      if (m.id == tempUserId) {
        return m.copyWith(
          id: turn.generation.userMessageId.isNotEmpty
              ? turn.generation.userMessageId
              : m.id,
          isSending: false,
          hasSendError: false,
        );
      }
      return m;
    }).toList();

    state = state.copyWith(
      currentChatId: turn.chatId,
      currentTitle: turn.title.isNotEmpty ? turn.title : state.currentTitle,
      messages: updatedMessages,
      isSending: false,
    );

    if (turn.generation.isProcessing) {
      _startStatusPolling(turn.chatId, turn.generation.requestId, token);
      return;
    }

    if (turn.generation.isFailed) {
      final failureMessage = GenericAiChatMessage(
        id: 'gen_fail_${turn.generation.generationId}',
        text: '',
        isUser: false,
        timestamp: turn.generation.finishedAt ?? DateTime.now(),
        hasGenerationError: true,
        errorMessage: turn.generation.errorMessage,
        errorCode: 'generation_failed',
        requestId: turn.generation.requestId,
      );

      state = state.copyWith(
        messages: [...state.messages, failureMessage],
        isGenerating: false,
      );
      return;
    }

    // Turn is completed
    if (turn.answer != null && turn.answer!.isNotEmpty) {
      final assistantMessage = GenericAiChatMessage(
        id:
            turn.generation.assistantMessageId ??
            'ast_${turn.generation.generationId}',
        text: turn.answer!,
        isUser: false,
        timestamp: turn.generation.finishedAt ?? DateTime.now(),
        requestId: turn.generation.requestId,
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isGenerating: false,
      );
    } else {
      state = state.copyWith(isGenerating: false);
    }
  }

  void _handleSendError(Object error, String tempUserId) {
    String? errorMessage;
    String? errorCode;
    DateTime? retryAt;
    String? quotaError;

    if (error is LearnLensException) {
      errorMessage = error.message;
      errorCode = error.code ?? 'send_failed';
      if (error.isQuotaOrRateLimit) {
        quotaError = error.message;
        retryAt = error.retryAt;
      }
    } else {
      errorMessage = error.toString();
      errorCode = 'send_failed';
    }

    final updatedMessages = state.messages.map((m) {
      if (m.id == tempUserId) {
        return m.copyWith(
          isSending: false,
          hasSendError: true,
          errorMessage: errorMessage,
          errorCode: errorCode,
        );
      }
      return m;
    }).toList();

    state = state.copyWith(
      messages: updatedMessages,
      isSending: false,
      isGenerating: false,
      quotaError: quotaError,
      retryAt: retryAt,
    );
  }

  /// Retries a previously failed user message using the same [requestId] for idempotency.
  Future<void> retryLastSend({String? messageId}) async {
    if (state.isSending || state.isGenerating || state.hasActiveRateLimit) {
      return;
    }

    final msgIndex = messageId != null
        ? state.messages.indexWhere((m) => m.id == messageId)
        : state.messages.lastIndexWhere((m) => m.isUser && m.hasSendError);

    if (msgIndex == -1) return;
    final failedMsg = state.messages[msgIndex];
    if (failedMsg.text.trim().isEmpty) return;

    final updatedMessages = List<GenericAiChatMessage>.from(state.messages)
      ..removeAt(msgIndex);

    state = state.copyWith(messages: updatedMessages);

    await sendMessage(failedMsg.text, customRequestId: failedMsg.requestId);
  }

  /// Retries generation after an assistant response failure.
  Future<void> retryGeneration() async {
    if (state.isSending || state.isGenerating || state.hasActiveRateLimit) {
      return;
    }

    // Remove the failed generation card
    final lastFailedIndex = state.messages.lastIndexWhere(
      (m) => !m.isUser && m.hasGenerationError,
    );
    if (lastFailedIndex == -1) return;

    // Find the preceding user prompt
    final userMsgIndex = state.messages
        .sublist(0, lastFailedIndex)
        .lastIndexWhere((m) => m.isUser);
    if (userMsgIndex == -1) return;

    final query = state.messages[userMsgIndex].text;
    if (query.trim().isEmpty) return;

    final updatedMessages = List<GenericAiChatMessage>.from(state.messages)
      ..removeAt(lastFailedIndex);

    state = state.copyWith(messages: updatedMessages);

    await sendMessage(query);
  }

  /// Starts polling `getConversationStatus` sequentially until the backend completes or fails generation,
  /// or until [maxPollingAttempts] is reached.
  void _startStatusPolling(String chatId, String requestId, int token) {
    _cancelPolling();

    int attempts = 0;

    void scheduleNextPoll() {
      if (token != _operationToken) return;

      _pollingTimer = Timer(pollingInterval, () async {
        if (token != _operationToken) return;

        attempts++;
        if (attempts >= maxPollingAttempts) {
          _cancelPolling();
          if (token != _operationToken) return;

          final timeoutMessage = GenericAiChatMessage(
            id: 'gen_fail_timeout_${UuidUtils.v4()}',
            text: '',
            isUser: false,
            timestamp: DateTime.now(),
            hasGenerationError: true,
            errorCode: 'timeout',
            requestId: requestId,
          );

          state = state.copyWith(
            messages: [...state.messages, timeoutMessage],
            isGenerating: false,
          );
          return;
        }

        try {
          final status = await _repository.getConversationStatus(
            chatId: chatId,
          );
          if (token != _operationToken) return;

          final gen = status.generation;

          if (gen == null || gen.isProcessing) {
            scheduleNextPoll();
            return;
          }

          _cancelPolling();

          if (gen.isFailed) {
            final failureMessage = GenericAiChatMessage(
              id: 'gen_fail_${gen.generationId}',
              text: '',
              isUser: false,
              timestamp: gen.finishedAt ?? DateTime.now(),
              hasGenerationError: true,
              errorMessage: gen.errorMessage,
              errorCode: 'generation_failed',
              requestId: gen.requestId,
            );

            if (token != _operationToken) return;
            state = state.copyWith(
              messages: [...state.messages, failureMessage],
              isGenerating: false,
            );
          } else if (gen.isCompleted) {
            // Reconcile messages from server
            final messagePage = await _repository.getMessages(chatId: chatId);
            if (token != _operationToken) return;

            final reconciled = messagePage.items
                .map(GenericAiChatMessage.fromDto)
                .toList();

            state = state.copyWith(messages: reconciled, isGenerating: false);
          }
        } catch (_) {
          // Continue sequential polling on transient error until max timeout or user navigation
          if (token == _operationToken) {
            scheduleNextPoll();
          }
        }
      });
    }

    scheduleNextPoll();
  }

  void _cancelPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Fetches conversation history.
  Future<void> loadConversations({bool refresh = false}) async {
    if (state.isLoadingHistory) {
      return;
    }

    state = state.copyWith(
      isLoadingHistory: true,
      hasHistoryError: false,
      historyError: null,
    );

    try {
      final cursor = refresh ? null : state.historyCursor;
      final result = await _repository.listConversations(
        limit: 20,
        cursor: cursor,
      );

      final List<AiConversationDto> combined;
      if (refresh) {
        combined = result.items;
      } else {
        final existingIds = state.conversationHistory
            .map((c) => c.chatId)
            .toSet();
        final newUnique = result.items
            .where((c) => !existingIds.contains(c.chatId))
            .toList();
        combined = [...state.conversationHistory, ...newUnique];
      }

      state = state.copyWith(
        conversationHistory: combined,
        historyCursor: result.nextCursor,
        hasMoreHistory:
            result.nextCursor != null && result.nextCursor!.isNotEmpty,
        isLoadingHistory: false,
        hasHistoryError: false,
        historyError: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingHistory: false,
        hasHistoryError: true,
        historyError: e,
      );
    }
  }

  /// Switches active conversation thread and loads its message history.
  Future<void> selectConversation(String chatId) async {
    _cancelPolling();
    final token = ++_operationToken;

    state = state.copyWith(
      currentChatId: chatId,
      messages: const [],
      isLoadingMessages: true,
      hasMessagesError: false,
      messagesError: null,
      isSending: false,
      isGenerating: false,
      quotaError: null,
      retryAt: null,
    );

    try {
      final page = await _repository.getMessages(chatId: chatId);
      if (token != _operationToken) {
        return;
      }

      final loaded = page.items.map(GenericAiChatMessage.fromDto).toList();

      final matchingTitle = state.conversationHistory
          .firstWhere(
            (c) => c.chatId == chatId,
            orElse: () => const AiConversationDto(chatId: ''),
          )
          .title;

      state = state.copyWith(
        messages: loaded,
        currentTitle: matchingTitle,
        isLoadingMessages: false,
        hasMessagesError: false,
        messagesError: null,
      );
    } catch (e) {
      if (token == _operationToken) {
        state = state.copyWith(
          isLoadingMessages: false,
          hasMessagesError: true,
          messagesError: e,
        );
      }
    }
  }

  /// Sets initial messages (e.g. for testing or pre-seeded conversations).
  void setInitialMessages(List<GenericAiChatMessage> messages) {
    state = state.copyWith(messages: messages);
  }

  /// Clears active conversation state and presents a clean empty canvas.
  void startNewChat() {
    _operationToken++;
    _cancelPolling();
    state = state.copyWith(
      currentChatId: null,
      currentTitle: '',
      messages: const [],
      isLoadingMessages: false,
      hasMessagesError: false,
      messagesError: null,
      isSending: false,
      isGenerating: false,
      quotaError: null,
      retryAt: null,
    );
  }
}

typedef GenericAiChatNotifier = GenericAiChat;
