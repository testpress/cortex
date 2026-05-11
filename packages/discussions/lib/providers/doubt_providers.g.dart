// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doubt_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$doubtRepositoryHash() => r'336c0148a4ed288d235ac7bba4462dd4600c24c9';

/// See also [doubtRepository].
@ProviderFor(doubtRepository)
final doubtRepositoryProvider = FutureProvider<DoubtRepository>.internal(
  doubtRepository,
  name: r'doubtRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$doubtRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DoubtRepositoryRef = FutureProviderRef<DoubtRepository>;
String _$doubtsListHash() => r'023df4324c162fe41807f79d6c142755fba0d405';

/// See also [doubtsList].
@ProviderFor(doubtsList)
final doubtsListProvider = AutoDisposeStreamProvider<List<DoubtDto>>.internal(
  doubtsList,
  name: r'doubtsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$doubtsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DoubtsListRef = AutoDisposeStreamProviderRef<List<DoubtDto>>;
String _$doubtsSyncHash() => r'598bd552860b83527d3244d508846e4aad3f2d91';

/// See also [doubtsSync].
@ProviderFor(doubtsSync)
final doubtsSyncProvider = AutoDisposeFutureProvider<void>.internal(
  doubtsSync,
  name: r'doubtsSyncProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$doubtsSyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DoubtsSyncRef = AutoDisposeFutureProviderRef<void>;
String _$doubtCategoriesHash() => r'57e7e0ac2bfed9f0fc06c447435de42543935686';

/// See also [doubtCategories].
@ProviderFor(doubtCategories)
final doubtCategoriesProvider = AutoDisposeProvider<List<String>>.internal(
  doubtCategories,
  name: r'doubtCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$doubtCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DoubtCategoriesRef = AutoDisposeProviderRef<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
