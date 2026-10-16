import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth/auth_provider.dart';
import '../data/exceptions/learnlens_exception.dart';
import '../data/models/learnlens_dto.dart';
import 'api_endpoints.dart';
import 'dio_provider.dart';

export '../data/models/learnlens_dto.dart';
export '../data/exceptions/learnlens_exception.dart';

/// Manages the lifecycle of LearnLens sessions across Cortex, including
/// organization-scoped generic chat sessions and content-scoped video lesson sessions.
///
/// Handles in-memory caching, proactive and reactive token refresh, and
/// automatic purging on student logout or account switch.
class LearnLensSessionManager {
  final Dio _dio;

  AiChatSessionDto? _cachedSession;
  Completer<AiChatSessionDto>? _refreshCompleter;
  int _sessionGeneration = 0;

  final Map<int, AiChatSessionDto> _contentSessions = {};
  final Map<int, Completer<AiChatSessionDto>> _contentCompleters = {};

  LearnLensSessionManager({required Dio dio, AiChatSessionDto? initialSession})
    : _dio = dio,
      _cachedSession = initialSession;

  /// The currently cached generic chat session, or null if none acquired.
  AiChatSessionDto? get currentSession => _cachedSession;

  /// The active policy constraints for generic chat.
  AiChatPolicyDto? get policy => _cachedSession?.policy;

  /// Whether a valid, non-expired generic session is currently cached.
  bool get hasValidSession {
    final valid = _cachedSession != null && !_cachedSession!.isExpired;
    return valid;
  }

  /// Retrieves a valid organization-scoped Generic AI Chat session.
  ///
  /// If [forceRefresh] is false and an active session exists and is not expired,
  /// the cached session is returned immediately.
  /// Otherwise, a new session is requested from Testpress via `POST /api/v3/ai-chat/sessions/create/`.
  Future<AiChatSessionDto> getSession({bool forceRefresh = false}) async {
    // 1. If an acquisition/refresh is already in flight, coordinate all callers
    // through the shared future so no caller proceeds with an invalid/transitional state.
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    // 2. If forceRefresh is requested, invalidate the cached session immediately
    // so subsequent or concurrent callers cannot use the rejected token.
    if (forceRefresh) {
      _cachedSession = null;
    } else if (_cachedSession != null && !_cachedSession!.isExpired) {
      // 3. Return cached session only when not force-refreshing and token is valid.
      return _cachedSession!;
    }

    final currentGeneration = _sessionGeneration;
    final completer = Completer<AiChatSessionDto>();
    completer.future.ignore();
    _refreshCompleter = completer;

    try {
      final response = await _dio.post(ApiEndpoints.genericAiChatSessionCreate);

      final newSession = AiChatSessionDto.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (_sessionGeneration != currentGeneration) {
        throw const LearnLensException(
          message: 'Session acquisition cancelled due to session clear.',
          code: 'session_cleared',
        );
      }

      _cachedSession = newSession;
      completer.complete(newSession);
      return newSession;
    } catch (e, stack) {
      if (!completer.isCompleted) {
        completer.completeError(e, stack);
      }
      rethrow;
    } finally {
      if (_refreshCompleter == completer) {
        _refreshCompleter = null;
      }
    }
  }

  /// Retrieves a valid content-scoped session for video lessons.
  ///
  /// Calls `POST /api/v3/contents/$contentId/ai-sessions/create/`.
  Future<AiChatSessionDto> getContentSession(
    int contentId, {
    bool forceRefresh = false,
  }) async {
    final cached = _contentSessions[contentId];

    // 1. If an acquisition/refresh for this contentId is already in flight, coordinate callers.
    if (_contentCompleters.containsKey(contentId)) {
      return _contentCompleters[contentId]!.future;
    }

    // 2. If forceRefresh, invalidate cached content session immediately.
    if (forceRefresh) {
      _contentSessions.remove(contentId);
    } else if (cached != null && !cached.isExpired) {
      // 3. Return cached session only when not force-refreshing and token is valid.
      return cached;
    }

    final currentGeneration = _sessionGeneration;
    final completer = Completer<AiChatSessionDto>();
    completer.future.ignore();
    _contentCompleters[contentId] = completer;

    try {
      final response = await _dio.post(ApiEndpoints.createAiSession(contentId));

      final rawData = response.data as Map<String, dynamic>;
      final session = AiChatSessionDto.fromContentSession(rawData);

      if (_sessionGeneration != currentGeneration) {
        throw const LearnLensException(
          message: 'Session acquisition cancelled due to session clear.',
          code: 'session_cleared',
        );
      }

      _contentSessions[contentId] = session;
      completer.complete(session);
      return session;
    } catch (e, stack) {
      if (!completer.isCompleted) {
        completer.completeError(e, stack);
      }
      rethrow;
    } finally {
      if (_contentCompleters[contentId] == completer) {
        _contentCompleters.remove(contentId);
      }
    }
  }

  /// Clears the cached generic AI chat session.
  void clearSession() {
    _sessionGeneration++;
    _cachedSession = null;
    _refreshCompleter = null;
  }

  /// Clears a specific content-scoped session.
  void clearContentSession(int contentId) {
    _sessionGeneration++;
    _contentSessions.remove(contentId);
    _contentCompleters.remove(contentId);
  }

  /// Returns the cached content session for [contentId], if any.
  AiChatSessionDto? getCachedContentSession(int contentId) =>
      _contentSessions[contentId];

  /// Clears all cached sessions (e.g. on student logout or account switch).
  void clearAllSessions() {
    clearSession();
    _contentSessions.clear();
    _contentCompleters.clear();
  }
}

/// Dio interceptor that injects the LearnLens `X-Session-Token` header
/// into outgoing requests, dynamically applies the negotiated `baseUrl`, and
/// transparently refreshes sessions upon encountering HTTP 401 Unauthorized responses.
class LearnLensSessionInterceptor extends Interceptor {
  final LearnLensSessionManager sessionManager;
  final Dio dio;

  static const String sessionTokenHeader = 'X-Session-Token';

  LearnLensSessionInterceptor({
    required this.sessionManager,
    required this.dio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // If a session token was already explicitly provided on headers, honor it
      // and mark it so 401 onError does not retry with a generic organization session.
      if (options.headers.containsKey(sessionTokenHeader) &&
          (options.headers[sessionTokenHeader] as String?)?.isNotEmpty ==
              true) {
        options.extra['caller_supplied_token'] = true;
        return handler.next(options);
      }

      final contentId = options.extra['content_id'] as int?;

      final session = contentId != null
          ? await sessionManager.getContentSession(contentId)
          : await sessionManager.getSession();

      options.headers[sessionTokenHeader] = session.sessionToken;

      // Intentionally retained for Part 2 (Frontend Integration):
      // LearnLensNetworkClient currently builds absolute URLs via _resolveBaseUrl(),
      // but future direct callers, streaming clients, or SSE consumers can dispatch
      // relative paths (e.g., dio.get('/chats/')) using an unconfigured Dio instance,
      // relying on this interceptor to dynamically inject session.baseUrl at request time.
      if (options.baseUrl.isEmpty && session.baseUrl.isNotEmpty) {
        options.baseUrl = session.baseUrl;
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final is401 = statusCode == 401;
    final isRetry = err.requestOptions.extra['is_session_retry'] == true;
    final isCallerSupplied =
        err.requestOptions.extra['caller_supplied_token'] == true;

    if (is401 && !isRetry && !isCallerSupplied) {
      AiChatSessionDto newSession;
      try {
        final contentId = err.requestOptions.extra['content_id'] as int?;
        newSession = contentId != null
            ? await sessionManager.getContentSession(
                contentId,
                forceRefresh: true,
              )
            : await sessionManager.getSession(forceRefresh: true);
      } catch (e) {
        // Preserve refresh error so downstream handlers can differentiate session failure
        err.requestOptions.extra['session_refresh_error'] = e;
        return handler.next(err);
      }

      try {
        final retryOptions = err.requestOptions;
        retryOptions.extra['is_session_retry'] = true;
        retryOptions.headers[sessionTokenHeader] = newSession.sessionToken;
        if (newSession.baseUrl.isNotEmpty) {
          retryOptions.baseUrl = newSession.baseUrl;
        }

        final response = await dio.fetch(retryOptions);
        return handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          return handler.next(e);
        }
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: e,
            type: DioExceptionType.unknown,
          ),
        );
      }
    }

    return handler.next(err);
  }
}

/// Provider exposing the unified session manager for LearnLens.
final learnLensSessionManagerProvider = Provider<LearnLensSessionManager>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  final manager = LearnLensSessionManager(dio: dio);

  // Keep the cache through userIdProvider's initial loading -> data transition.
  // Rebuilding this provider on that transition would discard a session acquired
  // during app startup and make the next LearnLens request create it again.
  var hasResolvedUserId = false;
  String? activeUserId;
  ref.listen<AsyncValue<String?>>(userIdProvider, (previous, next) {
    if (!next.hasValue) return;

    final nextUserId = next.valueOrNull;
    if (!hasResolvedUserId) {
      hasResolvedUserId = true;
      activeUserId = nextUserId;
      return;
    }

    if (activeUserId != nextUserId) {
      manager.clearAllSessions();
      activeUserId = nextUserId;
    }
  }, fireImmediately: true);

  ref.onDispose(manager.clearAllSessions);
  return manager;
});
