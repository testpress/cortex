import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:core/data/data.dart';

/// Network client handling interactions with LearnLens AI backend and session creation.
class LearnLensNetworkClient {
  final Dio _dio;
  final Future<String?> Function() _getUserId;

  static const String _sessionTokenHeader = 'X-Session-Token';
  static const String _learnLensBaseUrl = 'https://learnlens.testpress.in';

  LearnLensNetworkClient(Dio dio, this._getUserId)
      : _dio = Dio(dio.options.copyWith(baseUrl: _learnLensBaseUrl)) {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: true,
        ),
      );
    }
  }

  Future<LearnLensChatResponseDto> submitChat({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    required String query,
    required String conversationId,
  }) async {
    final userId = await _getUserId();
    final response = await _dio.post(
      ApiEndpoints.learnLensChat(orgUuid, assetId),
      options: Options(
        headers: {
          _sessionTokenHeader: sessionToken,
        },
      ),
      data: {
        'query': query,
        'conversation_id': conversationId,
        'learner_id': userId,
      },
    );
    return LearnLensChatResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<LearnLensQuizResponseDto> fetchQuiz({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    String difficulty = 'medium',
    int questionCount = 5,
  }) async {
    final userId = await _getUserId();
    final response = await _dio.post(
      ApiEndpoints.learnLensQuiz(orgUuid, assetId),
      options: Options(
        headers: {
          _sessionTokenHeader: sessionToken,
        },
      ),
      data: {
        'difficulty': difficulty,
        'question_count': questionCount,
        'learner_id': userId,
      },
    );
    return LearnLensQuizResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }
}
