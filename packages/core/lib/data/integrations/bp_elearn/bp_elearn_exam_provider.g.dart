// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bp_elearn_exam_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bPElearnExamApiServiceHash() =>
    r'e27d39d9900157edf28003e9b6271b8a2846b1fd';

/// See also [bPElearnExamApiService].
@ProviderFor(bPElearnExamApiService)
final bPElearnExamApiServiceProvider =
    AutoDisposeProvider<BPElearnExamApiService>.internal(
      bPElearnExamApiService,
      name: r'bPElearnExamApiServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bPElearnExamApiServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BPElearnExamApiServiceRef =
    AutoDisposeProviderRef<BPElearnExamApiService>;
String _$bPElearnExamRepositoryHash() =>
    r'a3f0b880ee1954a9320ef8e1fa09f6e7872b53a4';

/// See also [bPElearnExamRepository].
@ProviderFor(bPElearnExamRepository)
final bPElearnExamRepositoryProvider =
    AutoDisposeProvider<BPElearnExamRepository>.internal(
      bPElearnExamRepository,
      name: r'bPElearnExamRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bPElearnExamRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BPElearnExamRepositoryRef =
    AutoDisposeProviderRef<BPElearnExamRepository>;
String _$bPElearnModelExamResultsHash() =>
    r'0a64cd5c02e3b3b72b34f94aed7b33a4ccf26624';

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

/// See also [bPElearnModelExamResults].
@ProviderFor(bPElearnModelExamResults)
const bPElearnModelExamResultsProvider = BPElearnModelExamResultsFamily();

/// See also [bPElearnModelExamResults].
class BPElearnModelExamResultsFamily
    extends Family<AsyncValue<BPElearnPaginatedResponseDto>> {
  /// See also [bPElearnModelExamResults].
  const BPElearnModelExamResultsFamily();

  /// See also [bPElearnModelExamResults].
  BPElearnModelExamResultsProvider call({
    required int page,
    required int limit,
  }) {
    return BPElearnModelExamResultsProvider(page: page, limit: limit);
  }

  @override
  BPElearnModelExamResultsProvider getProviderOverride(
    covariant BPElearnModelExamResultsProvider provider,
  ) {
    return call(page: provider.page, limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bPElearnModelExamResultsProvider';
}

/// See also [bPElearnModelExamResults].
class BPElearnModelExamResultsProvider
    extends AutoDisposeFutureProvider<BPElearnPaginatedResponseDto> {
  /// See also [bPElearnModelExamResults].
  BPElearnModelExamResultsProvider({required int page, required int limit})
    : this._internal(
        (ref) => bPElearnModelExamResults(
          ref as BPElearnModelExamResultsRef,
          page: page,
          limit: limit,
        ),
        from: bPElearnModelExamResultsProvider,
        name: r'bPElearnModelExamResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bPElearnModelExamResultsHash,
        dependencies: BPElearnModelExamResultsFamily._dependencies,
        allTransitiveDependencies:
            BPElearnModelExamResultsFamily._allTransitiveDependencies,
        page: page,
        limit: limit,
      );

  BPElearnModelExamResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<BPElearnPaginatedResponseDto> Function(
      BPElearnModelExamResultsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BPElearnModelExamResultsProvider._internal(
        (ref) => create(ref as BPElearnModelExamResultsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BPElearnPaginatedResponseDto>
  createElement() {
    return _BPElearnModelExamResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BPElearnModelExamResultsProvider &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BPElearnModelExamResultsRef
    on AutoDisposeFutureProviderRef<BPElearnPaginatedResponseDto> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _BPElearnModelExamResultsProviderElement
    extends AutoDisposeFutureProviderElement<BPElearnPaginatedResponseDto>
    with BPElearnModelExamResultsRef {
  _BPElearnModelExamResultsProviderElement(super.provider);

  @override
  int get page => (origin as BPElearnModelExamResultsProvider).page;
  @override
  int get limit => (origin as BPElearnModelExamResultsProvider).limit;
}

String _$bPElearnWeeklyExamResultsHash() =>
    r'ef86185316d886cee8214dae95bc94aa0a861e4d';

/// See also [bPElearnWeeklyExamResults].
@ProviderFor(bPElearnWeeklyExamResults)
const bPElearnWeeklyExamResultsProvider = BPElearnWeeklyExamResultsFamily();

/// See also [bPElearnWeeklyExamResults].
class BPElearnWeeklyExamResultsFamily
    extends Family<AsyncValue<BPElearnPaginatedResponseDto>> {
  /// See also [bPElearnWeeklyExamResults].
  const BPElearnWeeklyExamResultsFamily();

  /// See also [bPElearnWeeklyExamResults].
  BPElearnWeeklyExamResultsProvider call({
    required int page,
    required int limit,
  }) {
    return BPElearnWeeklyExamResultsProvider(page: page, limit: limit);
  }

  @override
  BPElearnWeeklyExamResultsProvider getProviderOverride(
    covariant BPElearnWeeklyExamResultsProvider provider,
  ) {
    return call(page: provider.page, limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bPElearnWeeklyExamResultsProvider';
}

/// See also [bPElearnWeeklyExamResults].
class BPElearnWeeklyExamResultsProvider
    extends AutoDisposeFutureProvider<BPElearnPaginatedResponseDto> {
  /// See also [bPElearnWeeklyExamResults].
  BPElearnWeeklyExamResultsProvider({required int page, required int limit})
    : this._internal(
        (ref) => bPElearnWeeklyExamResults(
          ref as BPElearnWeeklyExamResultsRef,
          page: page,
          limit: limit,
        ),
        from: bPElearnWeeklyExamResultsProvider,
        name: r'bPElearnWeeklyExamResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bPElearnWeeklyExamResultsHash,
        dependencies: BPElearnWeeklyExamResultsFamily._dependencies,
        allTransitiveDependencies:
            BPElearnWeeklyExamResultsFamily._allTransitiveDependencies,
        page: page,
        limit: limit,
      );

  BPElearnWeeklyExamResultsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
  }) : super.internal();

  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<BPElearnPaginatedResponseDto> Function(
      BPElearnWeeklyExamResultsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BPElearnWeeklyExamResultsProvider._internal(
        (ref) => create(ref as BPElearnWeeklyExamResultsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BPElearnPaginatedResponseDto>
  createElement() {
    return _BPElearnWeeklyExamResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BPElearnWeeklyExamResultsProvider &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BPElearnWeeklyExamResultsRef
    on AutoDisposeFutureProviderRef<BPElearnPaginatedResponseDto> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _BPElearnWeeklyExamResultsProviderElement
    extends AutoDisposeFutureProviderElement<BPElearnPaginatedResponseDto>
    with BPElearnWeeklyExamResultsRef {
  _BPElearnWeeklyExamResultsProviderElement(super.provider);

  @override
  int get page => (origin as BPElearnWeeklyExamResultsProvider).page;
  @override
  int get limit => (origin as BPElearnWeeklyExamResultsProvider).limit;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
