import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'settings_providers.dart';

/// Provider for the global design mode (light, dark, system).
/// This is now a proxy to the persistent [appearanceSettingsNotifierProvider].
final designModeProvider = Provider<DesignMode>((ref) {
  final settings = ref.watch(appearanceSettingsNotifierProvider);
  return settings.when(
    data: (s) => s.mode,
    loading: () => DesignMode.system,
    error: (_, __) => DesignMode.system,
  );
});
