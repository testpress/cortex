// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storeRepositoryHash() => r'4c95e5c2401066d1eec1c72699d21ac44959b948';

/// See also [storeRepository].
@ProviderFor(storeRepository)
final storeRepositoryProvider = Provider<StoreRepository>.internal(
  storeRepository,
  name: r'storeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoreRepositoryRef = ProviderRef<StoreRepository>;
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
String _$productDetailHash() => r'88a0f21ad28703e4a21b53baede36b8f16d35a2c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [productDetail].
@ProviderFor(productDetail)
const productDetailProvider = ProductDetailFamily();

/// See also [productDetail].
class ProductDetailFamily extends Family<AsyncValue<ProductDto>> {
  /// See also [productDetail].
  const ProductDetailFamily();

  /// See also [productDetail].
  ProductDetailProvider call(
    String slug,
  ) {
    return ProductDetailProvider(
      slug,
    );
  }

  @override
  ProductDetailProvider getProviderOverride(
    covariant ProductDetailProvider provider,
  ) {
    return call(
      provider.slug,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailProvider';
}

/// See also [productDetail].
class ProductDetailProvider extends AutoDisposeFutureProvider<ProductDto> {
  /// See also [productDetail].
  ProductDetailProvider(
    String slug,
  ) : this._internal(
          (ref) => productDetail(
            ref as ProductDetailRef,
            slug,
          ),
          from: productDetailProvider,
          name: r'productDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productDetailHash,
          dependencies: ProductDetailFamily._dependencies,
          allTransitiveDependencies:
              ProductDetailFamily._allTransitiveDependencies,
          slug: slug,
        );

  ProductDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  Override overrideWith(
    FutureOr<ProductDto> Function(ProductDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailProvider._internal(
        (ref) => create(ref as ProductDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProductDto> createElement() {
    return _ProductDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailRef on AutoDisposeFutureProviderRef<ProductDto> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _ProductDetailProviderElement
    extends AutoDisposeFutureProviderElement<ProductDto> with ProductDetailRef {
  _ProductDetailProviderElement(super.provider);

  @override
  String get slug => (origin as ProductDetailProvider).slug;
}

String _$productInstallmentPlansHash() =>
    r'5e1d24b2067875ac1c64a8fd2e8a818383fb3c29';

/// See also [productInstallmentPlans].
@ProviderFor(productInstallmentPlans)
const productInstallmentPlansProvider = ProductInstallmentPlansFamily();

/// See also [productInstallmentPlans].
class ProductInstallmentPlansFamily
    extends Family<AsyncValue<InstallmentPlansResponseDto>> {
  /// See also [productInstallmentPlans].
  const ProductInstallmentPlansFamily();

  /// See also [productInstallmentPlans].
  ProductInstallmentPlansProvider call(
    String slug,
  ) {
    return ProductInstallmentPlansProvider(
      slug,
    );
  }

  @override
  ProductInstallmentPlansProvider getProviderOverride(
    covariant ProductInstallmentPlansProvider provider,
  ) {
    return call(
      provider.slug,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productInstallmentPlansProvider';
}

/// See also [productInstallmentPlans].
class ProductInstallmentPlansProvider
    extends AutoDisposeFutureProvider<InstallmentPlansResponseDto> {
  /// See also [productInstallmentPlans].
  ProductInstallmentPlansProvider(
    String slug,
  ) : this._internal(
          (ref) => productInstallmentPlans(
            ref as ProductInstallmentPlansRef,
            slug,
          ),
          from: productInstallmentPlansProvider,
          name: r'productInstallmentPlansProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productInstallmentPlansHash,
          dependencies: ProductInstallmentPlansFamily._dependencies,
          allTransitiveDependencies:
              ProductInstallmentPlansFamily._allTransitiveDependencies,
          slug: slug,
        );

  ProductInstallmentPlansProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  Override overrideWith(
    FutureOr<InstallmentPlansResponseDto> Function(
            ProductInstallmentPlansRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductInstallmentPlansProvider._internal(
        (ref) => create(ref as ProductInstallmentPlansRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<InstallmentPlansResponseDto>
      createElement() {
    return _ProductInstallmentPlansProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductInstallmentPlansProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductInstallmentPlansRef
    on AutoDisposeFutureProviderRef<InstallmentPlansResponseDto> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _ProductInstallmentPlansProviderElement
    extends AutoDisposeFutureProviderElement<InstallmentPlansResponseDto>
    with ProductInstallmentPlansRef {
  _ProductInstallmentPlansProviderElement(super.provider);

  @override
  String get slug => (origin as ProductInstallmentPlansProvider).slug;
}

String _$storeSearchQueryHash() => r'710279d17c0bcb58ded500a0618f44afe0e1cf7b';

/// See also [StoreSearchQuery].
@ProviderFor(StoreSearchQuery)
final storeSearchQueryProvider =
    AutoDisposeNotifierProvider<StoreSearchQuery, String>.internal(
  StoreSearchQuery.new,
  name: r'storeSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StoreSearchQuery = AutoDisposeNotifier<String>;
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
String _$storeProductsHash() => r'69512f244fedd235ee8375009eccd799bb10cdb8';

/// See also [StoreProducts].
@ProviderFor(StoreProducts)
final storeProductsProvider = AutoDisposeAsyncNotifierProvider<StoreProducts,
    PaginatedResponseDto<ProductDto>>.internal(
  StoreProducts.new,
  name: r'storeProductsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storeProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StoreProducts
    = AutoDisposeAsyncNotifier<PaginatedResponseDto<ProductDto>>;
String _$productDiscountNotifierHash() =>
    r'649e988c2a74f80440c8b3c1528fec0175c8b3c7';

abstract class _$ProductDiscountNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<OrderDto?>> {
  late final String slug;

  AsyncValue<OrderDto?> build(
    String slug,
  );
}

/// See also [ProductDiscountNotifier].
@ProviderFor(ProductDiscountNotifier)
const productDiscountNotifierProvider = ProductDiscountNotifierFamily();

/// See also [ProductDiscountNotifier].
class ProductDiscountNotifierFamily extends Family<AsyncValue<OrderDto?>> {
  /// See also [ProductDiscountNotifier].
  const ProductDiscountNotifierFamily();

  /// See also [ProductDiscountNotifier].
  ProductDiscountNotifierProvider call(
    String slug,
  ) {
    return ProductDiscountNotifierProvider(
      slug,
    );
  }

  @override
  ProductDiscountNotifierProvider getProviderOverride(
    covariant ProductDiscountNotifierProvider provider,
  ) {
    return call(
      provider.slug,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDiscountNotifierProvider';
}

/// See also [ProductDiscountNotifier].
class ProductDiscountNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ProductDiscountNotifier, AsyncValue<OrderDto?>> {
  /// See also [ProductDiscountNotifier].
  ProductDiscountNotifierProvider(
    String slug,
  ) : this._internal(
          () => ProductDiscountNotifier()..slug = slug,
          from: productDiscountNotifierProvider,
          name: r'productDiscountNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productDiscountNotifierHash,
          dependencies: ProductDiscountNotifierFamily._dependencies,
          allTransitiveDependencies:
              ProductDiscountNotifierFamily._allTransitiveDependencies,
          slug: slug,
        );

  ProductDiscountNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  AsyncValue<OrderDto?> runNotifierBuild(
    covariant ProductDiscountNotifier notifier,
  ) {
    return notifier.build(
      slug,
    );
  }

  @override
  Override overrideWith(ProductDiscountNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductDiscountNotifierProvider._internal(
        () => create()..slug = slug,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ProductDiscountNotifier,
      AsyncValue<OrderDto?>> createElement() {
    return _ProductDiscountNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDiscountNotifierProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDiscountNotifierRef
    on AutoDisposeNotifierProviderRef<AsyncValue<OrderDto?>> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _ProductDiscountNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ProductDiscountNotifier,
        AsyncValue<OrderDto?>> with ProductDiscountNotifierRef {
  _ProductDiscountNotifierProviderElement(super.provider);

  @override
  String get slug => (origin as ProductDiscountNotifierProvider).slug;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
