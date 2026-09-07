import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../network/learnlens_network_client.dart';
import '../repositories/learnlens_repository.dart';

part 'learnlens_provider.g.dart';

/// Resolved session context parameters for LearnLens API operations.
class LearnLensSessionContext {
  final String orgUuid;
  final String assetId;
  final int contentId;
  final String sessionToken;

  const LearnLensSessionContext({
    required this.orgUuid,
    required this.assetId,
    required this.contentId,
    required this.sessionToken,
  });
}

/// Provider for the singleton [LearnLensNetworkClient] instance.
@riverpod
LearnLensNetworkClient learnLensNetworkClient(Ref ref) {
  final dio = ref.watch(dioProvider);
  return LearnLensNetworkClient(
    dio,
    () async {
      final userIdAsync = ref.read(userIdProvider);
      return userIdAsync.valueOrNull ?? await ref.read(userIdProvider.future);
    },
    onRefreshToken: (options) async {
      final dynamic rawContentId = options.extra['content_id'];
      int? contentId;
      if (rawContentId is int) {
        contentId = rawContentId;
      } else if (rawContentId is String) {
        contentId = int.tryParse(rawContentId);
      }
      if (contentId != null && contentId > 0) {
        final sessionMap = await ref
            .read(learnlensSessionProvider(contentId).notifier)
            .refreshSession();
        return sessionMap?['session_token'] as String?;
      }
      return null;
    },
  );
}

DateTime? _parseExpiryTime(dynamic expiresVal) {
  if (expiresVal == null) return null;
  if (expiresVal is int) {
    return expiresVal > 1000000000000
        ? DateTime.fromMillisecondsSinceEpoch(expiresVal, isUtc: true)
        : DateTime.fromMillisecondsSinceEpoch(expiresVal * 1000, isUtc: true);
  }
  if (expiresVal is String) {
    final parsedInt = int.tryParse(expiresVal);
    if (parsedInt != null) {
      return parsedInt > 1000000000000
          ? DateTime.fromMillisecondsSinceEpoch(parsedInt, isUtc: true)
          : DateTime.fromMillisecondsSinceEpoch(parsedInt * 1000, isUtc: true);
    }
    return DateTime.tryParse(expiresVal)?.toUtc();
  }
  return null;
}

/// Helper function to check if a session token is missing or expired.
/// Considers a 60-second buffer before actual expiration.
bool isSessionExpired(
  Map<String, dynamic>? sessionMap, {
  Duration buffer = const Duration(seconds: 60),
}) {
  if (sessionMap == null) return true;
  final token = sessionMap['session_token'] as String?;
  if (token == null || token.isEmpty) return true;

  final dynamic expiresVal =
      sessionMap['expiresAt'] ?? sessionMap['expires_at'] ?? sessionMap['exp'];
  final expiryTime = _parseExpiryTime(expiresVal);

  if (expiryTime != null) {
    final threshold = DateTime.now().toUtc().add(buffer);
    return expiryTime.isBefore(threshold);
  }

  return false;
}

/// Resolves the authenticated LearnLens session context for a given [lesson].
/// Handles settings verification, session token generation/refresh, and fallback IDs.
Future<LearnLensSessionContext?> resolveLearnLensSession(
  WidgetRef ref,
  LessonDto lesson, {
  bool forceRefresh = false,
}) async {
  final settings = ref.read(instituteSettingsProvider);
  if (settings?.learnlensEnabled != true) {
    return null;
  }
  final orgUuid = settings?.learnlensOrgID ?? '';
  if (orgUuid.isEmpty) {
    return null;
  }

  final contentId = int.tryParse(lesson.id) ?? 0;
  final assetId = lesson.learnlensAssetId ?? lesson.uuid ?? lesson.id;

  Map<String, dynamic>? sessionMap;
  if (forceRefresh) {
    sessionMap = await ref
        .read(learnlensSessionProvider(contentId).notifier)
        .refreshSession();
  } else {
    sessionMap = await ref.read(learnlensSessionProvider(contentId).future);
    if (isSessionExpired(sessionMap)) {
      sessionMap = await ref
          .read(learnlensSessionProvider(contentId).notifier)
          .refreshSession();
    }
  }

  final sessionToken = sessionMap?['session_token'] as String? ?? '';
  if (sessionToken.isEmpty) {
    return null;
  }

  return LearnLensSessionContext(
    orgUuid: orgUuid,
    assetId: assetId,
    contentId: contentId,
    sessionToken: sessionToken,
  );
}

/// Provider for the singleton [LearnLensRepository] instance.
@riverpod
LearnLensRepository learnLensRepository(Ref ref) {
  final networkClient = ref.watch(learnLensNetworkClientProvider);
  final dataSource = ref.watch(dataSourceProvider);
  return LearnLensRepository(networkClient, dataSource);
}

@Riverpod(keepAlive: true)
class LearnlensSession extends _$LearnlensSession {
  @override
  FutureOr<Map<String, dynamic>?> build(int contentId) async {
    final repository = ref.watch(learnLensRepositoryProvider);
    try {
      final response = await repository.createSession(contentId);
      return response;
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      return null;
    }
  }

  /// Refreshes the session token manually, executing strictly a single request
  /// and updating the provider state directly.
  Future<Map<String, dynamic>?> refreshSession() async {
    try {
      final repository = ref.read(learnLensRepositoryProvider);
      final response = await repository.createSession(contentId);
      state = AsyncValue.data(response);
      return response;
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}
