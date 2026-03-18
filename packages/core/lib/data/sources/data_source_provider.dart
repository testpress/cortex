import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data.dart';

part 'data_source_provider.g.dart';

/// Provides the active [DataSource] based on [AppConfig.useMockData].
/// Swap to real HTTP source by building with: --dart-define=USE_MOCK=false
@Riverpod(keepAlive: true)
DataSource dataSource(Ref ref) {
  if (AppConfig.useMockData) {
    return const MockDataSource();
  }
  final authClient = ref.read(authClientProvider);
  return HttpDataSource(authClient);
}
