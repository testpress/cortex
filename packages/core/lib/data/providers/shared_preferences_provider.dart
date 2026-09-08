import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Riverpod provider for [SharedPreferences].
/// Overridden at app startup in [ProviderScope] with the pre-initialized instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

/// Cached auth flag read from [FlutterSecureStorage] in main() before runApp().
///
/// This is the single synchronous signal used by [goRouterProvider] to set
/// [initialLocation] correctly on cold start — without waiting for the async
/// auth verification that happens inside [authProvider].
///
/// Must be overridden in [ProviderScope] with the pre-boot token check result.
/// [authProvider] still performs full async verification after the app launches.
final cachedAuthFlagProvider = Provider<bool>((ref) => false);
