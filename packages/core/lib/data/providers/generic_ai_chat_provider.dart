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

  /// True while an assistant answer is still being streamed. The text is
  /// provisional and will be replaced by the authoritative answer.
  final bool isStreaming;
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
    this.isStreaming = false,
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
    bool? isStreaming,
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
      isStreaming: isStreaming ?? this.isStreaming,
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

  /// Whether answers are streamed over the SSE routes. Web keeps the ordinary
  /// JSON turn routes so its behavior is unchanged.
  @visibleForTesting
  bool useStreaming = !kIsWeb;

  Timer? _pollingTimer;
  int _operationToken = 0;

  /// Streams that are still open. Stale streams keep draining in the
  /// background (their events are ignored via [_operationToken]) and are
  /// cancelled when the notifier is disposed.
  final Set<StreamSubscription<AiChatStreamEvent>> _activeStreams = {};

  /// Submission target per request ID. `null` means the first-message route.
  /// A retry must replay the exact same target even if a `chat_id` was
  /// learned in the meantime.
  final Map<String, String?> _submissionTargets = {};

  LearnLensRepository get _repository => ref.read(learnLensRepositoryProvider);

  @override
  GenericAiChatState build() {
    ref.onDispose(() {
      _operationToken++;
      _cancelPolling();
      _cancelActiveStreams();
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

    // Replays keep their original target; new submissions use the active chat.
    final String? targetChatId;
    if (customRequestId != null &&
        _submissionTargets.containsKey(customRequestId)) {
      targetChatId = _submissionTargets[customRequestId];
    } else {
      final current = state.currentChatId;
      targetChatId = (current == null || current.isEmpty) ? null : current;
    }
    _submissionTargets[requestId] = targetChatId;

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

    if (useStreaming) {
      await _sendStreaming(
        requestId: requestId,
        query: trimmed,
        targetChatId: targetChatId,
        tempUserId: tempUserId,
        token: token,
      );
      return;
    }

    try {
      final AiChatTurnResponseDto turn;
      if (targetChatId == null) {
        turn = await _repository.startConversation(
          requestId: requestId,
          query: trimmed,
        );
      } else {
        turn = await _repository.sendFollowUpMessage(
          chatId: targetChatId,
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
      _handleSendError(e, tempUserId, requestId: requestId);
    }
  }

  // ---------------------------------------------------------------------------
  // Streaming turn lifecycle
  // ---------------------------------------------------------------------------

  Future<void> _sendStreaming({
    required String requestId,
    required String query,
    required String? targetChatId,
    required String tempUserId,
    required int token,
  }) async {
    final Stream<AiChatStreamEvent> stream;
    try {
      stream = targetChatId == null
          ? _repository.streamConversation(requestId: requestId, query: query)
          : _repository.streamFollowUpMessage(
              chatId: targetChatId,
              requestId: requestId,
              query: query,
            );
    } catch (e) {
      if (token != _operationToken) return;
      _handleSendError(e, tempUserId, requestId: requestId);
      return;
    }

    final provisionalId = 'stream_$requestId';
    final completer = Completer<void>();
    var accepted = false;
    var finished = false;
    String? knownChatId = targetChatId;
    Future<void>? recovery;

    StreamSubscription<AiChatStreamEvent>? subscription;
    var streamClosed = false;

    // Resolves [sendMessage] once the stream is closed and any recovery
    // triggered by it has settled.
    void finish() {
      streamClosed = true;
      final active = subscription;
      if (active != null) _activeStreams.remove(active);
      if (completer.isCompleted) return;
      final pending = recovery;
      if (pending == null) {
        completer.complete();
      } else {
        pending.whenComplete(() {
          if (!completer.isCompleted) completer.complete();
        });
      }
    }

    void recover(Object? error) {
      finished = true;
      recovery = _recoverUncertainTurn(
        requestId: requestId,
        chatId: knownChatId,
        tempUserId: tempUserId,
        provisionalId: provisionalId,
        token: token,
        error: error,
      );
    }

    subscription = stream.listen(
      (event) {
        if (token != _operationToken || finished) return;

        switch (event.type) {
          case AiChatStreamEventType.accepted:
            accepted = true;
            final turn = event.turn!;
            if (turn.chatId.isNotEmpty) knownChatId = turn.chatId;
            _handleStreamAccepted(turn, tempUserId, provisionalId);
          case AiChatStreamEventType.delta:
            _appendDelta(provisionalId, event.text, requestId);
          case AiChatStreamEventType.done:
            finished = true;
            final turn = event.turn!;
            if (turn.chatId.isNotEmpty) knownChatId = turn.chatId;
            _handleTurnResponse(
              turn,
              tempUserId,
              token,
              provisionalId: provisionalId,
            );
          case AiChatStreamEventType.error:
            // The server could not finish the stream. The saved outcome is
            // unknown, so read status/history instead of guessing.
            recover(
              LearnLensException(
                message:
                    event.errorMessage ??
                    'The response could not be completed.',
                code: event.errorCode ?? 'stream_failed',
              ),
            );
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (token == _operationToken && !finished) {
          if (!accepted && _isDefinitiveRejection(error)) {
            // Ordinary JSON error before streaming started (401, 409, 422,
            // 429). The submission was rejected; nothing to recover.
            finished = true;
            _handleSendError(error, tempUserId, requestId: requestId);
          } else {
            // Timeouts, disconnects, malformed events: outcome unknown.
            recover(error);
          }
        }
        finish();
      },
      onDone: () {
        if (token == _operationToken && !finished) {
          // Connection closed without `done` or `error`.
          recover(null);
        }
        finish();
      },
      cancelOnError: true,
    );

    if (!streamClosed) _activeStreams.add(subscription);
    await completer.future;
  }

  void _handleStreamAccepted(
    AiChatTurnResponseDto turn,
    String tempUserId,
    String provisionalId,
  ) {
    final messages = _finalizeUserMessage(
      state.messages,
      tempUserId,
      turn.generation,
    );

    state = state.copyWith(
      currentChatId: turn.chatId.isNotEmpty ? turn.chatId : state.currentChatId,
      currentTitle: turn.title.isNotEmpty ? turn.title : state.currentTitle,
      messages: _ensureProvisional(
        messages,
        provisionalId,
        turn.generation.requestId.isNotEmpty ? turn.generation.requestId : null,
      ),
      isSending: false,
      isGenerating: true,
    );
  }

  void _appendDelta(String provisionalId, String text, String requestId) {
    if (text.isEmpty) return;
    final messages = _ensureProvisional(
      state.messages,
      provisionalId,
      requestId,
    );
    state = state.copyWith(
      messages: messages
          .map(
            (m) => m.id == provisionalId ? m.copyWith(text: m.text + text) : m,
          )
          .toList(),
    );
  }

  /// Returns [messages] with a provisional streaming assistant message present.
  List<GenericAiChatMessage> _ensureProvisional(
    List<GenericAiChatMessage> messages,
    String provisionalId,
    String? requestId,
  ) {
    if (messages.any((m) => m.id == provisionalId)) return messages;
    return [
      ...messages,
      GenericAiChatMessage(
        id: provisionalId,
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
        isStreaming: true,
        requestId: requestId,
      ),
    ];
  }

  /// Marks the optimistic user message as accepted and adopts its server ID.
  List<GenericAiChatMessage> _finalizeUserMessage(
    List<GenericAiChatMessage> messages,
    String tempUserId,
    AiGenerationDto generation,
  ) {
    return messages.map((m) {
      if (m.id == tempUserId ||
          (m.isUser &&
              generation.userMessageId.isNotEmpty &&
              m.id == generation.userMessageId)) {
        return m.copyWith(
          id: generation.userMessageId.isNotEmpty
              ? generation.userMessageId
              : m.id,
          isSending: false,
          hasSendError: false,
          errorMessage: null,
          errorCode: null,
        );
      }
      return m;
    }).toList();
  }

  List<GenericAiChatMessage> _withoutStreaming(
    List<GenericAiChatMessage> messages,
  ) {
    return messages.where((m) => !m.isStreaming).toList();
  }

  /// Pre-stream rejections carry an HTTP 4xx status and are final; anything
  /// else (timeouts, connection loss, 5xx) leaves the outcome uncertain.
  bool _isDefinitiveRejection(Object error) {
    if (error is! LearnLensException) return false;
    final status = error.statusCode;
    if (status != null && status >= 400 && status < 500) return true;
    return error.code == 'invalid_message' || error.code == 'message_too_long';
  }

  /// Recovers a submission whose outcome is unknown using the documented
  /// status/history APIs. Never issues a new request ID or resubmits.
  Future<void> _recoverUncertainTurn({
    required String requestId,
    required String? chatId,
    required String tempUserId,
    required String provisionalId,
    required int token,
    Object? error,
  }) async {
    final uncertainError =
        error ??
        const LearnLensException(
          message: 'The connection to the AI assistant was interrupted.',
          code: 'stream_interrupted',
        );

    if (chatId == null || chatId.isEmpty) {
      // No conversation yet. Keep the request ID on the user message so the
      // user's retry replays the same first-message submission.
      if (token != _operationToken) return;
      _handleSendError(uncertainError, tempUserId, requestId: requestId);
      return;
    }

    try {
      final status = await _repository.getConversationStatus(chatId: chatId);
      if (token != _operationToken) return;

      final gen = status.generation;
      if (gen == null || gen.requestId != requestId) {
        // The server never accepted this submission. A manual retry replays
        // it idempotently.
        _handleSendError(uncertainError, tempUserId, requestId: requestId);
        return;
      }

      if (gen.isCompleted) {
        final page = await _repository.getMessages(chatId: chatId);
        if (token != _operationToken) return;
        _submissionTargets.remove(requestId);
        state = state.copyWith(
          currentChatId: chatId,
          currentTitle: status.title.isNotEmpty
              ? status.title
              : state.currentTitle,
          messages: page.items.map(GenericAiChatMessage.fromDto).toList(),
          isSending: false,
          isGenerating: false,
        );
        return;
      }

      if (gen.isFailed) {
        _submissionTargets.remove(requestId);
        _applyGenerationFailure(gen, tempUserId);
        return;
      }

      // Still processing or unresolved: keep the generating state and poll.
      state = state.copyWith(
        currentChatId: chatId,
        messages: _finalizeUserMessage(state.messages, tempUserId, gen),
        isSending: false,
        isGenerating: true,
      );
      _startStatusPolling(chatId, requestId, token);
    } catch (e) {
      if (token != _operationToken) return;
      _handleSendError(e, tempUserId, requestId: requestId);
    }
  }

  void _applyGenerationFailure(AiGenerationDto gen, String tempUserId) {
    final failureId = 'gen_fail_${gen.generationId}';
    final messages = _withoutStreaming(
      _finalizeUserMessage(state.messages, tempUserId, gen),
    );
    final alreadyShown = messages.any((m) => m.id == failureId);

    state = state.copyWith(
      messages: [
        ...messages,
        if (!alreadyShown)
          GenericAiChatMessage(
            id: failureId,
            text: '',
            isUser: false,
            timestamp: gen.finishedAt ?? DateTime.now(),
            hasGenerationError: true,
            errorMessage: gen.errorMessage,
            errorCode: 'generation_failed',
            requestId: gen.requestId,
          ),
      ],
      isSending: false,
      isGenerating: false,
    );
  }

  void _cancelActiveStreams() {
    for (final subscription in _activeStreams.toList()) {
      subscription.cancel();
    }
    _activeStreams.clear();
  }

  // ---------------------------------------------------------------------------
  // Turn completion (shared by JSON responses and stream `done` events)
  // ---------------------------------------------------------------------------

  void _handleTurnResponse(
    AiChatTurnResponseDto turn,
    String tempUserId,
    int token, {
    String? provisionalId,
  }) {
    if (token != _operationToken) return;
    final updatedMessages = _finalizeUserMessage(
      state.messages,
      tempUserId,
      turn.generation,
    );

    state = state.copyWith(
      currentChatId: turn.chatId.isNotEmpty ? turn.chatId : state.currentChatId,
      currentTitle: turn.title.isNotEmpty ? turn.title : state.currentTitle,
      messages: updatedMessages,
      isSending: false,
    );

    if (turn.generation.isProcessing || turn.generation.isUnresolved) {
      if (provisionalId != null) {
        // A replay ended while the original request is still running. Drop
        // any provisional text and keep the generating indicator visible.
        state = state.copyWith(
          messages: state.messages
              .map((m) => m.id == provisionalId ? m.copyWith(text: '') : m)
              .toList(),
        );
      }
      _startStatusPolling(turn.chatId, turn.generation.requestId, token);
      return;
    }

    // Terminal outcome: no replay will be needed for this request ID.
    _submissionTargets.remove(turn.generation.requestId);

    if (turn.generation.isFailed) {
      _applyGenerationFailure(turn.generation, tempUserId);
      return;
    }

    // Turn is completed: the answer is authoritative and replaces any
    // provisional text instead of being appended to it.
    final answer = turn.answer;
    if (answer != null && answer.isNotEmpty) {
      final assistantId =
          turn.generation.assistantMessageId ??
          'ast_${turn.generation.generationId}';
      final assistantMessage = GenericAiChatMessage(
        id: assistantId,
        text: answer,
        isUser: false,
        timestamp: turn.generation.finishedAt ?? DateTime.now(),
        requestId: turn.generation.requestId,
      );

      final messages = state.messages;
      final provisionalIndex = provisionalId == null
          ? -1
          : messages.indexWhere((m) => m.id == provisionalId);
      final List<GenericAiChatMessage> next;
      if (provisionalIndex != -1) {
        next = [...messages]..[provisionalIndex] = assistantMessage;
      } else if (messages.any((m) => m.id == assistantId)) {
        next = messages;
      } else {
        next = [..._withoutStreaming(messages), assistantMessage];
      }

      state = state.copyWith(
        messages: _withoutStreaming(next),
        isGenerating: false,
      );
    } else {
      state = state.copyWith(
        messages: _withoutStreaming(state.messages),
        isGenerating: false,
      );
    }
  }

  void _handleSendError(Object error, String tempUserId, {String? requestId}) {
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

    final updatedMessages = _withoutStreaming(state.messages).map((m) {
      final matchesRequest =
          requestId != null && m.isUser && m.requestId == requestId;
      if (m.id == tempUserId || matchesRequest) {
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
            messages: [..._withoutStreaming(state.messages), timeoutMessage],
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

          if (gen == null || gen.isProcessing || gen.isUnresolved) {
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
            _submissionTargets.remove(requestId);
            state = state.copyWith(
              messages: [..._withoutStreaming(state.messages), failureMessage],
              isGenerating: false,
            );
          } else if (gen.isCompleted) {
            // Reconcile messages from server
            final messagePage = await _repository.getMessages(chatId: chatId);
            if (token != _operationToken) return;

            final reconciled = messagePage.items
                .map(GenericAiChatMessage.fromDto)
                .toList();

            _submissionTargets.remove(requestId);
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
    _submissionTargets.clear();
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
    _submissionTargets.clear();
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
