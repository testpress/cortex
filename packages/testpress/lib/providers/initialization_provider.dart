import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'package:core/core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'dart:developer' as dev;

part 'initialization_provider.g.dart';

/// Provider that handles app-wide data initialization and refresh logic.
/// This prevents side effects within UI-driven data providers.
@Riverpod(keepAlive: true)
Future<void> appInitialization(AppInitializationRef ref) async {
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final userProgressRepo = await ref.watch(
    userProgressRepositoryProvider.future,
  );

  // Ensure 3rd party SDKs (TPStreams, etc) are initialized via core
  await ref.watch(sdkInitializationProvider.future);

  // Initialize Institute Settings before launching UI (runs exactly once)
  await ref.watch(settingsInitializationProvider.future);

  final isLoggedIn = ref.watch(authProvider).asData?.value ?? false;
  if (!isLoggedIn) return;

  // Initialize core data in background
  try {
    // Refresh user profile and progress to see what was recently completed
    // This allows the Resume Card to find the most recent lesson in the fully-populated DB.
    final user = await userRepo.refreshProfile();
    await userProgressRepo.refreshProgress(user.id);
  } catch (e, stack) {
    dev.log('App initialization failed', error: e, stackTrace: stack);
    ref
        .read(sentryServiceProvider)
        .captureException(e, stackTrace: stack, level: SentryLevel.fatal);

    // Support offline mode: only rethrow if this is a first launch (no cached data).
    final cachedProfile = await userRepo.getCurrentProfile();
    if (cachedProfile == null) {
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
Future<void> settingsInitialization(SettingsInitializationRef ref) async {
  try {
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
      final fresh = await settingsRepo.refreshSettings();
      ref.read(instituteSettingsProvider.notifier).state = fresh;
    }
  } catch (e, stack) {
    // Fail silently if unable to fetch settings, the app will use defaults
    // BUT rethrow if we don't even have cached settings (first launch offline)
    dev.log('Settings initialization failed', error: e, stackTrace: stack);
    ref
        .read(sentryServiceProvider)
        .captureException(e, stackTrace: stack, level: SentryLevel.warning);
    final settingsRepo = ref.read(instituteSettingsRepositoryProvider);
    final cached = await settingsRepo.loadSettings();
    if (cached == null) {
      rethrow;
    }
  }
}
