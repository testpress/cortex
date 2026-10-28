import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'package:core/core.dart';
import 'push_notification_service.dart';

import 'dart:developer' as dev;

part 'initialization_provider.g.dart';

Map<String, dynamic> _settingsFailureContext(Object error) {
  return {
    'api_host': AppConfig.apiBaseUrl,
    'endpoint': ApiEndpoints.instituteSettings,
    'exception_type': error.runtimeType.toString(),
    'exception': _sanitizeDiagnosticText(error),
    if (error is ApiException) ...{
      'api_error_type': error.type.name,
      if (error.statusCode != null) 'status_code': error.statusCode,
      if (error.error != null)
        'underlying_error': _sanitizeDiagnosticText(error.error!),
    },
  };
}

String _sanitizeDiagnosticText(Object value) {
  final sanitized = value.toString().replaceAll(
    RegExp(r'https?://[^\s]+'),
    '<redacted-url>',
  );
  return sanitized.length <= 500
      ? sanitized
      : '${sanitized.substring(0, 500)}…';
}

/// Provider that handles app-wide data initialization and refresh logic.
/// This prevents side effects within UI-driven data providers.
@Riverpod(keepAlive: true)
Future<void> appInitialization(AppInitializationRef ref) async {
  final userRepo = await ref.watch(userRepositoryProvider.future);

  // Settings can load concurrently with the remaining startup work, but Sentry
  // must be ready first or the first failure can be lost during initialization.
  try {
    await ref.read(sentryServiceProvider).initialize();
  } catch (e, stack) {
    dev.log(
      'Sentry initialization failed (diagnostics disabled)',
      error: e,
      stackTrace: stack,
    );
  }
  unawaited(ref.read(settingsInitializationProvider.future));

  // Initialize Firebase Core & Push Notifications (fails silently if google-services.json was missing)
  try {
    await ref.read(pushNotificationServiceProvider).initialize();
  } catch (e, stack) {
    dev.log(
      'Firebase initialization failed (notifications disabled)',
      error: e,
      stackTrace: stack,
    );
  }

  // Ensure 3rd party SDKs (TPStreams, etc) are initialized via core
  await ref.watch(sdkInitializationProvider.future);

  // Initialize Institute Settings before launching UI (runs exactly once)
  try {
    await ref.watch(settingsInitializationProvider.future);
  } catch (_) {
    // Settings error on cold start without cache is handled reactively by bootstrapProvider & ConnectionErrorScreen
  }

  final isLoggedIn = ref.watch(authProvider).asData?.value ?? false;
  if (!isLoggedIn) return;

  // Initialize core data in background
  try {
    // Refresh user profile to see what was recently updated
    await userRepo.refreshProfile();
  } catch (e, stack) {
    dev.log('App initialization failed', error: e, stackTrace: stack);
    ref
        .read(sentryServiceProvider)
        .captureException(e, stackTrace: stack, level: AppErrorLevel.fatal);

    // Support offline mode: only rethrow if this is a first launch (no cached data).
    final cachedProfile = await userRepo.getCurrentProfile();
    if (cachedProfile == null) {
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
Future<void> settingsInitialization(SettingsInitializationRef ref) async {
  final settingsRepo = ref.read(instituteSettingsRepositoryProvider);
  final cached = await settingsRepo.loadSettings();
  if (cached != null) {
    ref.read(instituteSettingsProvider.notifier).state = cached;
    settingsRepo
        .refreshSettings()
        .then((fresh) {
          ref.read(instituteSettingsProvider.notifier).state = fresh;
        })
        .catchError((_) {});
  } else {
    try {
      final fresh = await settingsRepo.refreshSettings();
      ref.read(instituteSettingsProvider.notifier).state = fresh;
    } catch (e, stack) {
      dev.log('Settings initialization failed', error: e, stackTrace: stack);
      final failureContext = _settingsFailureContext(e);

      // Connection failures are normally filtered from Sentry as expected
      // offline conditions. Cold-start settings failures must always produce
      // one diagnostic event because they block first launch and can also be
      // caused by redirects, TLS failures, or release-only request differences.
      final sentry = ref.read(sentryServiceProvider);
      await sentry.captureException(
        e,
        stackTrace: stack,
        level: AppErrorLevel.error,
        tags: {'failure_stage': 'cold_start_settings'},
        contexts: {'settings_request': failureContext},
        bypassFilter: true,
      );
      rethrow;
    }
  }
}
