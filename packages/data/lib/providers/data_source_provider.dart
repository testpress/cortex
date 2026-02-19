import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../sources/data_source.dart';
import '../sources/mock_data_source.dart';
import '../sources/http_data_source.dart';

part 'data_source_provider.g.dart';

/// Provides the active [DataSource] based on [AppConfig.useMockData].
/// Swap to real HTTP source by building with: --dart-define=USE_MOCK=false
@Riverpod(keepAlive: true)
DataSource dataSource(Ref ref) {
  if (AppConfig.useMockData) {
    return const MockDataSource();
  }
  return const HttpDataSource();
}
