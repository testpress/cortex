import 'package:core/data/data.dart';
import '../network/learnlens_network_client.dart';

/// Repository handling business logic for LearnLens AI interactions.
/// It aggregates calls from the main [DataSource] (for session creation)
/// and the dedicated [LearnLensNetworkClient] (for chat and quiz).
class LearnLensRepository {
  final LearnLensNetworkClient _networkClient;
  final DataSource _dataSource;

  LearnLensRepository(this._networkClient, this._dataSource);

  /// Creates a new AI Session using the main Testpress API.
  Future<Map<String, dynamic>> createSession(int contentId) async {
    return _dataSource.createAiSession(contentId);
  }

  /// Submits a chat query to the LearnLens API.
  Future<LearnLensChatResponseDto> submitChat({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    required String query,
    String? conversationId,
    String? chatId,
    int? contentId,
  }) async {
    return _networkClient.submitChat(
      orgUuid: orgUuid,
      assetId: assetId,
      sessionToken: sessionToken,
      query: query,
      conversationId: conversationId,
      chatId: chatId,
      contentId: contentId,
    );
  }

  /// Lists past chat sessions for the given asset.
  Future<List<LearnLensChatSessionDto>> fetchChats({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    int? contentId,
    int? limit,
    String? cursor,
    String? before,
  }) async {
    return _networkClient.listChats(
      orgUuid: orgUuid,
      assetId: assetId,
      sessionToken: sessionToken,
      contentId: contentId,
      limit: limit,
      cursor: cursor,
      before: before,
    );
  }

  /// Fetches historical messages for a specific chat.
  Future<List<LearnLensMessageDto>> fetchChatMessages({
    required String orgUuid,
    required String chatId,
    required String sessionToken,
    int? contentId,
    int? limit,
    String? cursor,
    String? before,
  }) async {
    return _networkClient.getChatMessages(
      orgUuid: orgUuid,
      chatId: chatId,
      sessionToken: sessionToken,
      contentId: contentId,
      limit: limit,
      cursor: cursor,
      before: before,
    );
  }

  /// Fetches the latest chat session and its historical messages for the asset.
  /// If no past session exists, returns an empty list and empty chatId.
  Future<({String chatId, List<LearnLensMessageDto> messages})>
      fetchLatestChatHistory({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    int? contentId,
  }) async {
    final chats = await fetchChats(
      orgUuid: orgUuid,
      assetId: assetId,
      sessionToken: sessionToken,
      contentId: contentId,
    );

    if (chats.isEmpty) {
      return (chatId: '', messages: const <LearnLensMessageDto>[]);
    }

    final sortedChats = List<LearnLensChatSessionDto>.from(chats)
      ..sort((a, b) =>
          (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0)));
    final activeChatId = sortedChats.first.id;

    if (activeChatId.isEmpty) {
      return (chatId: '', messages: const <LearnLensMessageDto>[]);
    }

    final messages = await fetchChatMessages(
      orgUuid: orgUuid,
      chatId: activeChatId,
      sessionToken: sessionToken,
      contentId: contentId,
    );

    return (chatId: activeChatId, messages: messages);
  }

  /// Generates multiple-choice questions for the video asset.
  Future<LearnLensQuizResponseDto> fetchQuiz({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    String difficulty = 'medium',
    int questionCount = 5,
    int? contentId,
  }) async {
    return _networkClient.fetchQuiz(
      orgUuid: orgUuid,
      assetId: assetId,
      sessionToken: sessionToken,
      difficulty: difficulty,
      questionCount: questionCount,
      contentId: contentId,
    );
  }
}
