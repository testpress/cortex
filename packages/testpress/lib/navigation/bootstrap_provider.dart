import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';

part 'bootstrap_provider.g.dart';

enum BootstrapState { loading, authenticated, unauthenticated }

@riverpod
BootstrapState bootstrap(BootstrapRef ref) {
  final settings = ref.watch(instituteSettingsProvider);
  final authState = ref.watch(authProvider);

  if (settings == null || authState.isLoading) {
    return BootstrapState.loading;
  }

  if (authState.valueOrNull == true) {
    return BootstrapState.authenticated;
  }

  return BootstrapState.unauthenticated;
}
