// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_source_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiClientHash() => r'58987af45fbb76e948c3bcfad311fd0cce5cdb76';

/// Provides a centralized API client.
///
/// Copied from [apiClient].
@ProviderFor(apiClient)
final apiClientProvider = Provider<ApiClient>.internal(
  apiClient,
  name: r'apiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiClientRef = ProviderRef<ApiClient>;
String _$dataSourceHash() => r'b5b8bfa2861372945cde8d79748b89a2a8523dee';

/// Provides the active [DataSource] based on [AppConfig.useMockData].
/// Swap to real HTTP source by building with: --dart-define=USE_MOCK=false
///
/// Copied from [dataSource].
@ProviderFor(dataSource)
final dataSourceProvider = Provider<DataSource>.internal(
  dataSource,
  name: r'dataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DataSourceRef = ProviderRef<DataSource>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
