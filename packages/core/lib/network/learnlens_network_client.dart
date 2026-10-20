import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth/auth_provider.dart';
import '../data/exceptions/api_exception.dart';
import 'api_endpoints.dart';
import 'learnlens_session_manager.dart';
import 'sse_parser.dart';

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
    final url = session.baseUrl.isNotEmpty
        ? session.baseUrl
        : _defaultLearnLensBaseUrl;
    return url;
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
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return LearnLensException(
        message: 'Connection timed out',
        type: ApiErrorType.timeout,
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    }
    if (e.type == DioExceptionType.connectionError) {
      return LearnLensException(
        message: 'No internet connection',
        type: ApiErrorType.noInternet,
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    }

    final statusCode = e.response?.statusCode;
    final ApiErrorType type;
    if (statusCode == 429) {
      type = ApiErrorType.rateLimited;
    } else if (statusCode == 403) {
      type = ApiErrorType.forbidden;
    } else if (statusCode == 404) {
      type = ApiErrorType.notFound;
    } else if (statusCode != null && statusCode >= 500) {
      type = ApiErrorType.serverError;
    } else {
      type = ApiErrorType.unknown;
    }

    String resolveMessage(String? raw) {
      if (raw == null) return 'Something went wrong. Please try again.';
      final lower = raw.toLowerCase();
      if (lower.contains('session expired') ||
          lower.contains('token expired') ||
          lower.contains('invalid session token') ||
          lower.contains('invalid token') ||
          lower.contains('unauthorized')) {
        return 'Unable to connect to AI assistant. Please try again.';
      }
      return raw;
    }

    final data = e.response?.data;
    if (data is Map<String, dynamic> && data.containsKey('detail')) {
      final quota = AiChatQuotaErrorDto.fromDetail(data['detail']);
      return LearnLensException(
        message: resolveMessage(quota.message),
        code: quota.code,
        statusCode: statusCode,
        limit: quota.limit,
        retryAt: quota.retryAt,
        originalError: e,
        type: type,
      );
    }
    return LearnLensException(
      message: resolveMessage(e.message),
      statusCode: statusCode,
      originalError: e,
      type: type,
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
      final list = AiConversationListDto.fromJson(
        response.data as Map<String, dynamic>,
      );
      return list;
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
      final turn = AiChatTurnResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
      return turn;
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
      final turn = AiChatTurnResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
      return turn;
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
      final conv = AiConversationDto.fromJson(
        response.data as Map<String, dynamic>,
      );
      return conv;
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
      final msgList = AiMessageListDto.fromJson(
        response.data as Map<String, dynamic>,
      );
      return msgList;
    });
  }

  /// Starts a new conversation over `POST /chats/stream/` and emits the
  /// server-sent `accepted`, `delta`, `done`, and `error` events as they arrive.
  ///
  /// Errors raised before streaming starts (401, 409, 422, 429, timeouts) are
  /// surfaced as [LearnLensException]s on the returned stream.
  Stream<AiChatStreamEvent> streamConversation({
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) {
    return _streamTurn(
      pathBuilder: (baseUrl) => '$baseUrl/chats/stream/',
      requestId: requestId,
      query: query,
      cancelToken: cancelToken,
    );
  }

  /// Sends a follow-up over `POST /chats/<chat_id>/messages/stream/` and emits
  /// the server-sent events as they arrive.
  Stream<AiChatStreamEvent> streamFollowUpMessage({
    required String chatId,
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) {
    return _streamTurn(
      pathBuilder: (baseUrl) => '$baseUrl/chats/$chatId/messages/stream/',
      requestId: requestId,
      query: query,
      cancelToken: cancelToken,
    );
  }

  Stream<AiChatStreamEvent> _streamTurn({
    required String Function(String baseUrl) pathBuilder,
    required String requestId,
    required String query,
    CancelToken? cancelToken,
  }) async* {
    final Response<ResponseBody> response;
    try {
      final baseUrl = await _resolveBaseUrl();
      response = await _dio.post<ResponseBody>(
        pathBuilder(baseUrl),
        data: {'request_id': requestId, 'query': query},
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
        ),
      );
    } on DioException catch (e) {
      throw await _parseStreamingDioException(e);
    }

    final body = response.data;
    if (body == null) {
      throw const LearnLensException(
        message: 'Empty response from AI assistant.',
        code: 'malformed_stream',
      );
    }

    final contentType =
        response.headers.value(Headers.contentTypeHeader)?.toLowerCase() ?? '';

    if (!contentType.contains('text/event-stream')) {
      // The server fell back to an ordinary JSON turn response. Surface it as
      // a single terminal event so callers handle it like a finished stream.
      final text = await _readBodyAsString(body.stream);
      if (Transformer.isJsonMimeType(contentType) || text.startsWith('{')) {
        final decoded = _tryDecodeJson(text);
        if (decoded is Map<String, dynamic>) {
          yield AiChatStreamEvent.done(AiChatTurnResponseDto.fromJson(decoded));
          return;
        }
      }
      throw const LearnLensException(
        message: 'Unexpected response from AI assistant.',
        code: 'malformed_stream',
      );
    }

    try {
      await for (final sse in const SseParser().bind(body.stream)) {
        final event = _parseStreamEvent(sse);
        if (event == null) continue;
        yield event;
        if (event.isTerminal) return;
      }
    } on LearnLensException {
      rethrow;
    } on DioException catch (e) {
      throw parseDioException(e);
    } catch (e) {
      throw LearnLensException(
        message: 'The connection to the AI assistant was interrupted.',
        code: 'stream_interrupted',
        originalError: e,
        type: ApiErrorType.noInternet,
      );
    }
  }

  AiChatStreamEvent? _parseStreamEvent(SseEvent sse) {
    try {
      final decoded = jsonDecode(sse.data);
      return AiChatStreamEvent.fromJson(sse.event, decoded);
    } on FormatException catch (e) {
      throw LearnLensException(
        message: 'Received an invalid response from AI assistant.',
        code: 'malformed_stream_event',
        originalError: e,
      );
    }
  }

  /// Streaming requests receive error bodies as a [ResponseBody]; read and
  /// decode it so the regular error normalization can inspect `detail`.
  Future<LearnLensException> _parseStreamingDioException(DioException e) async {
    final data = e.response?.data;
    if (data is ResponseBody) {
      try {
        final text = await _readBodyAsString(data.stream);
        e.response!.data = _tryDecodeJson(text) ?? text;
      } catch (_) {
        e.response!.data = null;
      }
    }
    return parseDioException(e);
  }

  static Future<String> _readBodyAsString(Stream<List<int>> stream) {
    return const Utf8Decoder(allowMalformed: true).bind(stream).join();
  }

  static Object? _tryDecodeJson(String text) {
    if (text.trim().isEmpty) return null;
    try {
      return jsonDecode(text);
    } on FormatException {
      return null;
    }
  }

  /// Submits an asset-linked query in video lesson viewer.
  Future<LearnLensChatResponseDto> submitChat({
    required String orgUuid,
    required String assetId,
    required String query,
    required String conversationId,
    String? sessionToken,
    int? contentId,
    String? learnerId,
  }) async {
    return _guard(() async {
      final userId = learnerId ?? (await _getUserId?.call());
      final options = Options(
        extra: {'content_id': ?contentId},
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
    int? contentId,
    String difficulty = 'medium',
    int questionCount = 5,
    String? learnerId,
  }) async {
    return _guard(() async {
      final userId = learnerId ?? (await _getUserId?.call());
      final options = Options(
        extra: {'content_id': ?contentId},
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
