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
    required String conversationId,
  }) async {
    return _networkClient.submitChat(
      orgUuid: orgUuid,
      assetId: assetId,
      sessionToken: sessionToken,
      query: query,
      conversationId: conversationId,
    );
  }

  /// Generates multiple-choice questions for the video asset.
  Future<LearnLensQuizResponseDto> fetchQuiz({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    String difficulty = 'medium',
    int questionCount = 5,
  }) async {
    return _networkClient.fetchQuiz(
      orgUuid: orgUuid,
      assetId: assetId,
      sessionToken: sessionToken,
      difficulty: difficulty,
      questionCount: questionCount,
    );
  }
}
