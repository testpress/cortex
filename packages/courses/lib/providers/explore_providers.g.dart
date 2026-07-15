// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exploreRepositoryHash() => r'1d85f266ddad418061da61ba3ceed6687dc11d9e';

/// See also [exploreRepository].
@ProviderFor(exploreRepository)
final exploreRepositoryProvider =
    AutoDisposeProvider<ExploreRepository>.internal(
  exploreRepository,
  name: r'exploreRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exploreRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExploreRepositoryRef = AutoDisposeProviderRef<ExploreRepository>;
String _$storeCategoriesHash() => r'94c3d0e9392a117a1928e5cf329b3688936853f3';

/// See also [storeCategories].
@ProviderFor(storeCategories)
final storeCategoriesProvider =
    AutoDisposeFutureProvider<List<ProductCategoryDto>>.internal(
  storeCategories,
  name: r'storeCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoreCategoriesRef
    = AutoDisposeFutureProviderRef<List<ProductCategoryDto>>;
String _$storeProductsHash() => r'3c9d39b7bd49af70eb91c4aabfe82ecf8d3bee93';

/// See also [storeProducts].
@ProviderFor(storeProducts)
final storeProductsProvider =
    AutoDisposeFutureProvider<List<ProductDto>>.internal(
  storeProducts,
  name: r'storeProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoreProductsRef = AutoDisposeFutureProviderRef<List<ProductDto>>;
String _$exploreSearchQueryHash() =>
    r'710279d17c0bcb58ded500a0618f44afe0e1cf7b';

/// See also [ExploreSearchQuery].
@ProviderFor(ExploreSearchQuery)
final exploreSearchQueryProvider =
    AutoDisposeNotifierProvider<ExploreSearchQuery, String>.internal(
  ExploreSearchQuery.new,
  name: r'exploreSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exploreSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExploreSearchQuery = AutoDisposeNotifier<String>;
String _$selectedStoreCategoryHash() =>
    r'519b5b997948862a4adf7bdcc13676747fbda664';

/// See also [SelectedStoreCategory].
@ProviderFor(SelectedStoreCategory)
final selectedStoreCategoryProvider =
    AutoDisposeNotifierProvider<SelectedStoreCategory, String?>.internal(
  SelectedStoreCategory.new,
  name: r'selectedStoreCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedStoreCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedStoreCategory = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
