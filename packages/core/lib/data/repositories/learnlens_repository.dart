import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/learnlens_network_client.dart';
import '../../network/learnlens_session_manager.dart';

export '../../network/learnlens_network_client.dart' show CancelToken;
export '../models/learnlens_dto.dart';
export '../exceptions/learnlens_exception.dart';

/// Unified repository coordinating LearnLens AI operations across Cortex,
/// serving both organization-scoped generic chats and video lesson queries/quizzes.
class LearnLensRepository {
  final LearnLensNetworkClient _client;
  final LearnLensSessionManager _sessionManager;

  LearnLensRepository({
    required LearnLensNetworkClient client,
    required LearnLensSessionManager sessionManager,
  }) : _client = client,
       _sessionManager = sessionManager;

  /// The active usage policy from the session manager.
  AiChatPolicyDto? get policy => _sessionManager.policy;

  /// Creates or retrieves a session for a specific video lesson content.
  Future<Map<String, dynamic>> createSession(int contentId) async {
    final session = await _sessionManager.getContentSession(contentId);
    return {
      'token': session.sessionToken,
      'session_token': session.sessionToken,
    };
  }

  /// Submits an asset-linked query in video lesson viewer.
  Future<LearnLensChatResponseDto> submitChat({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    required String query,
    required String conversationId,
  }) async {
    _validateQuery(query);
    return _client.submitChat(
      orgUuid: orgUuid,
      assetId: assetId,
      sessionToken: sessionToken,
      query: query,
      conversationId: conversationId,
    );
  }

  /// Fetches multiple-choice practice questions for a video asset.
  Future<LearnLensQuizResponseDto> fetchQuiz({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    String difficulty = 'medium',
    int questionCount = 5,
  }) async {
    return _client.fetchQuiz(
      orgUuid: orgUuid,
      assetId: assetId,
      sessionToken: sessionToken,
      difficulty: difficulty,
      questionCount: questionCount,
    );
  }

  /// Lists the student's conversations ordered by most recent activity.
  Future<AiConversationListDto> listConversations({
    int limit = 20,
    String? cursor,
  }) {
    return _client.listConversations(limit: limit, cursor: cursor);
  }

  /// Starts a new conversation with the initial user query.
  Future<AiChatTurnResponseDto> startConversation({
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) async {
    _validateQuery(query);
    return _client.startConversation(
      requestId: requestId,
      query: query,
      cancelToken: cancelToken,
    );
  }

  /// Sends a follow-up query in an existing conversation.
  Future<AiChatTurnResponseDto> sendFollowUpMessage({
    required String chatId,
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) async {
    _validateQuery(query);
    return _client.sendFollowUpMessage(
      chatId: chatId,
      requestId: requestId,
      query: query,
      cancelToken: cancelToken,
    );
  }

  /// Polls the conversation status and retrieves the latest generation state.
  Future<AiConversationDto> getConversationStatus({
    required String chatId,
    CancelToken? cancelToken,
  }) {
    return _client.getConversationStatus(
      chatId: chatId,
      cancelToken: cancelToken,
    );
  }

  /// Loads a paginated list of messages for a conversation.
  Future<AiMessagePageResult> getMessages({
    required String chatId,
    int limit = 20,
    String? before,
    CancelToken? cancelToken,
  }) async {
    final response = await _client.getMessages(
      chatId: chatId,
      limit: limit,
      before: before,
      cancelToken: cancelToken,
    );

    // Messages within a page are ordered oldest to newest per contract
    return AiMessagePageResult(
      items: response.items,
      nextCursor: response.nextCursor,
    );
  }

  /// Enforces maximum query character limit locally before making network calls.
  void _validateQuery(String query) {
    final maxChars = policy?.maxMessageCharacters ?? 4000;
    if (query.trim().isEmpty) {
      throw const LearnLensException(
        message: 'Message cannot be empty.',
        code: 'invalid_message',
      );
    }
    if (query.length > maxChars) {
      throw LearnLensException(
        message:
            'Message exceeds maximum allowed length of $maxChars characters.',
        code: 'message_too_long',
        limit: maxChars,
      );
    }
  }

  void validateMessage(String query) => _validateQuery(query);

  /// Prepends older messages during pagination, deduplicating items by `messageId`.
  List<AiMessageDto> prependMessages({
    required List<AiMessageDto> olderMessages,
    required List<AiMessageDto> currentMessages,
  }) {
    final seenIds = <String>{};
    final combined = <AiMessageDto>[];

    for (final msg in olderMessages) {
      if (msg.messageId.isEmpty || seenIds.add(msg.messageId)) {
        combined.add(msg);
      }
    }
    for (final msg in currentMessages) {
      if (msg.messageId.isEmpty || seenIds.add(msg.messageId)) {
        combined.add(msg);
      }
    }

    return combined;
  }
}

/// Provider exposing the unified LearnLens repository instance.
final learnLensRepositoryProvider = Provider<LearnLensRepository>((ref) {
  final client = ref.watch(learnLensNetworkClientProvider);
  final sessionManager = ref.watch(learnLensSessionManagerProvider);
  return LearnLensRepository(client: client, sessionManager: sessionManager);
});
