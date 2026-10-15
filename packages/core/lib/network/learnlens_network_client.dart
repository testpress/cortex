import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth/auth_provider.dart';
import '../data/exceptions/api_exception.dart';
import 'api_endpoints.dart';
import 'learnlens_session_manager.dart';

export 'package:dio/dio.dart' show CancelToken;
export '../data/models/learnlens_dto.dart';
export '../data/exceptions/learnlens_exception.dart';

/// Unified network client handling interactions with LearnLens AI backend
/// for both organization-scoped generic chat and asset-scoped video lesson chat/quizzes.
class LearnLensNetworkClient {
  final Dio _dio;
  final LearnLensSessionManager _sessionManager;
  final Future<String?> Function()? _getUserId;

  static const String _defaultLearnLensBaseUrl =
      'https://learnlens.testpress.in';

  LearnLensNetworkClient({
    Dio? dio,
    required LearnLensSessionManager sessionManager,
    Future<String?> Function()? userIdProvider,
  }) : _sessionManager = sessionManager,
       _getUserId = userIdProvider,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               connectTimeout: const Duration(seconds: 30),
               receiveTimeout: const Duration(seconds: 180),
               sendTimeout: const Duration(seconds: 30),
               headers: {
                 'Accept': 'application/json',
                 'Content-Type': 'application/json',
               },
             ),
           ) {
    final hasInterceptor = _dio.interceptors.any(
      (i) => i is LearnLensSessionInterceptor,
    );
    if (!hasInterceptor) {
      _dio.interceptors.add(
        LearnLensSessionInterceptor(sessionManager: _sessionManager, dio: _dio),
      );
    }
  }

  Dio get dio => _dio;

  Future<String> _resolveBaseUrl() async {
    final session = await _sessionManager.getSession();
    if (session.baseUrl.isNotEmpty) {
      return session.baseUrl;
    }
    return _defaultLearnLensBaseUrl;
  }

  static LearnLensException parseDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      return LearnLensException(
        message: 'Request cancelled',
        code: 'cancelled',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    }
    final data = e.response?.data;
    if (data is Map<String, dynamic> && data.containsKey('detail')) {
      final quota = AiChatQuotaErrorDto.fromDetail(data['detail']);
      return LearnLensException(
        message: quota.message,
        code: quota.code,
        statusCode: e.response?.statusCode,
        limit: quota.limit,
        retryAt: quota.retryAt,
        originalError: e,
        type: e.response?.statusCode == 429
            ? ApiErrorType.rateLimited
            : ApiErrorType.unknown,
      );
    }
    return LearnLensException(
      message: e.message ?? 'Network request failed',
      statusCode: e.response?.statusCode,
      originalError: e,
    );
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw parseDioException(e);
    }
  }

  /// Lists the student's conversations ordered by most recent activity.
  Future<AiConversationListDto> listConversations({
    int limit = 20,
    String? cursor,
  }) async {
    return _guard(() async {
      final baseUrl = await _resolveBaseUrl();
      final response = await _dio.get(
        '$baseUrl/chats/',
        queryParameters: {
          'limit': limit,
          if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        },
      );
      return AiConversationListDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  /// Starts a new conversation with the initial user query.
  Future<AiChatTurnResponseDto> startConversation({
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) async {
    return _guard(() async {
      final baseUrl = await _resolveBaseUrl();
      final response = await _dio.post(
        '$baseUrl/chats/',
        data: {'request_id': requestId, 'query': query},
        cancelToken: cancelToken,
      );
      return AiChatTurnResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  /// Sends a follow-up query in an existing conversation.
  Future<AiChatTurnResponseDto> sendFollowUpMessage({
    required String chatId,
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) async {
    return _guard(() async {
      final baseUrl = await _resolveBaseUrl();
      final response = await _dio.post(
        '$baseUrl/chats/$chatId/messages/',
        data: {'request_id': requestId, 'query': query},
        cancelToken: cancelToken,
      );
      return AiChatTurnResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  /// Polls the conversation status and retrieves the latest generation state.
  Future<AiConversationDto> getConversationStatus({
    required String chatId,
    CancelToken? cancelToken,
  }) async {
    return _guard(() async {
      final baseUrl = await _resolveBaseUrl();
      final response = await _dio.get(
        '$baseUrl/chats/$chatId/',
        cancelToken: cancelToken,
      );
      return AiConversationDto.fromJson(response.data as Map<String, dynamic>);
    });
  }

  /// Fetches a paginated slice of messages in a conversation.
  Future<AiMessageListDto> getMessages({
    required String chatId,
    int limit = 20,
    String? before,
    CancelToken? cancelToken,
  }) async {
    return _guard(() async {
      final baseUrl = await _resolveBaseUrl();
      final response = await _dio.get(
        '$baseUrl/chats/$chatId/messages/',
        queryParameters: {
          'limit': limit,
          if (before != null && before.isNotEmpty) 'before': before,
        },
        cancelToken: cancelToken,
      );
      return AiMessageListDto.fromJson(response.data as Map<String, dynamic>);
    });
  }

  /// Submits an asset-linked query in video lesson viewer.
  Future<LearnLensChatResponseDto> submitChat({
    required String orgUuid,
    required String assetId,
    required String query,
    required String conversationId,
    String? sessionToken,
    String? learnerId,
  }) async {
    return _guard(() async {
      final userId = learnerId ?? (await _getUserId?.call());
      final options = Options(
        headers: {
          if (sessionToken != null && sessionToken.isNotEmpty)
            LearnLensSessionInterceptor.sessionTokenHeader: sessionToken,
        },
      );

      final response = await _dio.post(
        '$_defaultLearnLensBaseUrl${ApiEndpoints.learnLensChat(orgUuid, assetId)}',
        options: options,
        data: {
          'query': query,
          'conversation_id': conversationId,
          'learner_id': ?userId,
        },
      );
      return LearnLensChatResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }

  /// Fetches multiple-choice questions for the video asset.
  Future<LearnLensQuizResponseDto> fetchQuiz({
    required String orgUuid,
    required String assetId,
    String? sessionToken,
    String difficulty = 'medium',
    int questionCount = 5,
    String? learnerId,
  }) async {
    return _guard(() async {
      final userId = learnerId ?? (await _getUserId?.call());
      final options = Options(
        headers: {
          if (sessionToken != null && sessionToken.isNotEmpty)
            LearnLensSessionInterceptor.sessionTokenHeader: sessionToken,
        },
      );

      final response = await _dio.post(
        '$_defaultLearnLensBaseUrl${ApiEndpoints.learnLensQuiz(orgUuid, assetId)}',
        options: options,
        data: {
          'difficulty': difficulty,
          'question_count': questionCount,
          'learner_id': ?userId,
        },
      );
      return LearnLensQuizResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
    });
  }
}

/// Provider exposing the unified LearnLens network client.
final learnLensNetworkClientProvider = Provider<LearnLensNetworkClient>((ref) {
  final sessionManager = ref.watch(learnLensSessionManagerProvider);
  return LearnLensNetworkClient(
    sessionManager: sessionManager,
    userIdProvider: () async {
      final userIdAsync = ref.read(userIdProvider);
      return userIdAsync.valueOrNull ?? await ref.read(userIdProvider.future);
    },
  );
});
