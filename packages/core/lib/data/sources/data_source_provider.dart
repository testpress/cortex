import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/auth_provider.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';
import 'data_source.dart';
import 'mock_data_source.dart';
import 'http_data_source.dart';

part 'data_source_provider.g.dart';

/// Provides a centralized API client.
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(
    authLocalDataSource: ref.watch(authLocalDataSourceProvider),
  );
}

/// Provides the active [DataSource] based on [AppConfig.useMockData].
/// Swap to real HTTP source by building with: --dart-define=USE_MOCK=false
@Riverpod(keepAlive: true)
DataSource dataSource(Ref ref) {
  if (AppConfig.useMockData) {
    return const MockDataSource();
  }
  return HttpDataSource(
    apiClient: ref.watch(apiClientProvider),
  );
}
