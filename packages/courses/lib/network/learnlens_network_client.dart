import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:core/data/data.dart';

/// Network client handling interactions with LearnLens AI backend and session creation.
class LearnLensNetworkClient {
  final Dio _dio;
  final Future<String?> Function() _getUserId;
  final Future<String?> Function(RequestOptions options)? _onRefreshToken;
  final Duration retryDelay;

  static const String sessionTokenHeader = 'X-Session-Token';
  static const String _learnLensBaseUrl = 'https://learnlens.testpress.in';

  LearnLensNetworkClient(
    Dio dio,
    this._getUserId, {
    Future<String?> Function(RequestOptions options)? onRefreshToken,
    this.retryDelay = Duration.zero,
  })  : _onRefreshToken = onRefreshToken,
        _dio = Dio(dio.options.copyWith(baseUrl: _learnLensBaseUrl)) {
    _dio.httpClientAdapter = dio.httpClientAdapter;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (err, handler) async {
          final response = err.response;
          final requestOptions = err.requestOptions;
          final isAlreadyRetried =
              requestOptions.extra['_is_retry_401'] == true;
          final is401 = response?.statusCode == 401;

          if (is401 && !isAlreadyRetried && _onRefreshToken != null) {
            try {
              final newToken = await _onRefreshToken!(requestOptions);

              if (newToken != null && newToken.isNotEmpty) {
                if (retryDelay > Duration.zero) {
                  await Future.delayed(retryDelay);
                }
                final newOptions = requestOptions.copyWith(
                  headers: Map<String, dynamic>.from(requestOptions.headers)
                    ..[sessionTokenHeader] = newToken,
                  extra: Map<String, dynamic>.from(requestOptions.extra)
                    ..['_is_retry_401'] = true,
                );
                final retryResponse = await _dio.fetch(newOptions);
                return handler.resolve(retryResponse);
              }
            } on DioException catch (dioErr) {
              return handler.next(dioErr);
            } catch (retryError) {
              return handler.next(err);
            }
          }
          return handler.next(err);
        },
      ),
    );

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
    String? conversationId,
    String? chatId,
    int? contentId,
  }) async {
    final userId = await _getUserId();
    final activeId =
        (chatId != null && chatId.isNotEmpty) ? chatId : (conversationId ?? '');
    final data = <String, dynamic>{
      'query': query,
      'learner_id': userId,
    };
    if (activeId.isNotEmpty) {
      data['chat_id'] = activeId;
      data['conversation_id'] = activeId;
    }
    final response = await _dio.post(
      ApiEndpoints.learnLensChat(orgUuid, assetId),
      options: Options(
        headers: {
          sessionTokenHeader: sessionToken,
        },
        extra: {
          if (contentId != null) 'content_id': contentId,
          'asset_id': assetId,
        },
      ),
      data: data,
    );
    return LearnLensChatResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<List<LearnLensChatSessionDto>> listChats({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    int? contentId,
    int? limit,
    String? cursor,
    String? before,
  }) async {
    final queryParameters = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (cursor != null) 'cursor': cursor,
      if (before != null) 'before': before,
    };
    final response = await _dio.get(
      ApiEndpoints.learnLensChats(orgUuid, assetId),
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      options: Options(
        headers: {
          sessionTokenHeader: sessionToken,
        },
        extra: {
          if (contentId != null) 'content_id': contentId,
          'asset_id': assetId,
        },
      ),
    );
    return _extractList(response.data, LearnLensChatSessionDto.fromJson);
  }

  Future<List<LearnLensMessageDto>> getChatMessages({
    required String orgUuid,
    required String chatId,
    required String sessionToken,
    int? contentId,
    int? limit,
    String? cursor,
    String? before,
  }) async {
    final queryParameters = <String, dynamic>{
      if (limit != null) 'limit': limit,
      if (cursor != null) 'cursor': cursor,
      if (before != null) 'before': before,
    };
    final response = await _dio.get(
      ApiEndpoints.learnLensChatMessages(orgUuid, chatId),
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      options: Options(
        headers: {
          sessionTokenHeader: sessionToken,
        },
        extra: {
          if (contentId != null) 'content_id': contentId,
        },
      ),
    );
    return _extractList(response.data, LearnLensMessageDto.fromJson);
  }

  List<T> _extractList<T>(
    dynamic data,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final List<dynamic> items;
    if (data is List) {
      items = data;
    } else if (data is Map<String, dynamic> && data['items'] is List) {
      items = data['items'] as List<dynamic>;
    } else if (data is Map<String, dynamic> && data['results'] is List) {
      items = data['results'] as List<dynamic>;
    } else {
      items = const [];
    }
    return items.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  Future<LearnLensQuizResponseDto> fetchQuiz({
    required String orgUuid,
    required String assetId,
    required String sessionToken,
    String difficulty = 'medium',
    int questionCount = 5,
    int? contentId,
  }) async {
    final userId = await _getUserId();
    final response = await _dio.post(
      ApiEndpoints.learnLensQuiz(orgUuid, assetId),
      options: Options(
        headers: {
          sessionTokenHeader: sessionToken,
        },
        extra: {
          if (contentId != null) 'content_id': contentId,
          'asset_id': assetId,
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
