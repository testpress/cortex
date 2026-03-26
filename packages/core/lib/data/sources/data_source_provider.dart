import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import 'data_source.dart';
import 'mock_data_source.dart';
import 'http_data_source.dart';
import '../../network/network_provider.dart';

part 'data_source_provider.g.dart';

/// Provides the active [DataSource] based on [AppConfig.useMockData].
/// Swap to real HTTP source by building with: --dart-define=USE_MOCK=false
@Riverpod(keepAlive: true)
DataSource dataSource(Ref ref) {
  if (AppConfig.useMockData) {
    return const MockDataSource();
  }

  return HttpDataSource(dio: ref.watch(dioProvider));
}
