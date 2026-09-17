import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../providers/initialization_provider.dart';

part 'bootstrap_provider.g.dart';

enum BootstrapState { loading, authenticated, unauthenticated, error }

@riverpod
BootstrapState bootstrap(BootstrapRef ref) {
  final settings = ref.watch(instituteSettingsProvider);
  final authState = ref.watch(authProvider);
  if (settings != null) {
    if (authState.isLoading) {
      return BootstrapState.loading;
    }
    if (authState.valueOrNull == true) {
      return BootstrapState.authenticated;
    }
    return BootstrapState.unauthenticated;
  }

  final settingsInit = ref.watch(settingsInitializationProvider);
  if (settingsInit.isLoading) {
    return BootstrapState.loading;
  }
  if (settingsInit.hasError) {
    return BootstrapState.error;
  }

  return BootstrapState.loading;
}
