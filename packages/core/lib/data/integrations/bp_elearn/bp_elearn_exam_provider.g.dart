// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bp_elearn_exam_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bpElearnExamApiServiceHash() =>
    r'9fab8d50d3f6a088cb129c2c9da09afce8509449';

/// See also [bpElearnExamApiService].
@ProviderFor(bpElearnExamApiService)
final bpElearnExamApiServiceProvider =
    AutoDisposeProvider<BpElearnExamApiService>.internal(
      bpElearnExamApiService,
      name: r'bpElearnExamApiServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bpElearnExamApiServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BpElearnExamApiServiceRef =
    AutoDisposeProviderRef<BpElearnExamApiService>;
String _$bpElearnExamRepositoryHash() =>
    r'd5e0a9e0ec77d0a048d7e655c9f59a83fea900b6';

/// See also [bpElearnExamRepository].
@ProviderFor(bpElearnExamRepository)
final bpElearnExamRepositoryProvider =
    AutoDisposeProvider<BpElearnExamRepository>.internal(
      bpElearnExamRepository,
      name: r'bpElearnExamRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bpElearnExamRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BpElearnExamRepositoryRef =
    AutoDisposeProviderRef<BpElearnExamRepository>;
String _$bpElearnModelExamResultsHash() =>
    r'c51a73a327465d980e9261539c8016a84c254f49';

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

/// See also [bpElearnModelExamResults].
@ProviderFor(bpElearnModelExamResults)
const bpElearnModelExamResultsProvider = BpElearnModelExamResultsFamily();

/// See also [bpElearnModelExamResults].
class BpElearnModelExamResultsFamily
    extends Family<AsyncValue<BpElearnPaginatedResponseDto>> {
  /// See also [bpElearnModelExamResults].
  const BpElearnModelExamResultsFamily();

  /// See also [bpElearnModelExamResults].
  BpElearnModelExamResultsProvider call({
    required int page,
    required int limit,
  }) {
    return BpElearnModelExamResultsProvider(page: page, limit: limit);
  }

  @override
  BpElearnModelExamResultsProvider getProviderOverride(
    covariant BpElearnModelExamResultsProvider provider,
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
  String? get name => r'bpElearnModelExamResultsProvider';
}

/// See also [bpElearnModelExamResults].
class BpElearnModelExamResultsProvider
    extends AutoDisposeFutureProvider<BpElearnPaginatedResponseDto> {
  /// See also [bpElearnModelExamResults].
  BpElearnModelExamResultsProvider({required int page, required int limit})
    : this._internal(
        (ref) => bpElearnModelExamResults(
          ref as BpElearnModelExamResultsRef,
          page: page,
          limit: limit,
        ),
        from: bpElearnModelExamResultsProvider,
        name: r'bpElearnModelExamResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bpElearnModelExamResultsHash,
        dependencies: BpElearnModelExamResultsFamily._dependencies,
        allTransitiveDependencies:
            BpElearnModelExamResultsFamily._allTransitiveDependencies,
        page: page,
        limit: limit,
      );

  BpElearnModelExamResultsProvider._internal(
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
    FutureOr<BpElearnPaginatedResponseDto> Function(
      BpElearnModelExamResultsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BpElearnModelExamResultsProvider._internal(
        (ref) => create(ref as BpElearnModelExamResultsRef),
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
  AutoDisposeFutureProviderElement<BpElearnPaginatedResponseDto>
  createElement() {
    return _BpElearnModelExamResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BpElearnModelExamResultsProvider &&
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
mixin BpElearnModelExamResultsRef
    on AutoDisposeFutureProviderRef<BpElearnPaginatedResponseDto> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _BpElearnModelExamResultsProviderElement
    extends AutoDisposeFutureProviderElement<BpElearnPaginatedResponseDto>
    with BpElearnModelExamResultsRef {
  _BpElearnModelExamResultsProviderElement(super.provider);

  @override
  int get page => (origin as BpElearnModelExamResultsProvider).page;
  @override
  int get limit => (origin as BpElearnModelExamResultsProvider).limit;
}

String _$bpElearnWeeklyExamResultsHash() =>
    r'5871b4e11a9a2b0272724916f621801c1147392b';

/// See also [bpElearnWeeklyExamResults].
@ProviderFor(bpElearnWeeklyExamResults)
const bpElearnWeeklyExamResultsProvider = BpElearnWeeklyExamResultsFamily();

/// See also [bpElearnWeeklyExamResults].
class BpElearnWeeklyExamResultsFamily
    extends Family<AsyncValue<BpElearnPaginatedResponseDto>> {
  /// See also [bpElearnWeeklyExamResults].
  const BpElearnWeeklyExamResultsFamily();

  /// See also [bpElearnWeeklyExamResults].
  BpElearnWeeklyExamResultsProvider call({
    required int page,
    required int limit,
  }) {
    return BpElearnWeeklyExamResultsProvider(page: page, limit: limit);
  }

  @override
  BpElearnWeeklyExamResultsProvider getProviderOverride(
    covariant BpElearnWeeklyExamResultsProvider provider,
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
  String? get name => r'bpElearnWeeklyExamResultsProvider';
}

/// See also [bpElearnWeeklyExamResults].
class BpElearnWeeklyExamResultsProvider
    extends AutoDisposeFutureProvider<BpElearnPaginatedResponseDto> {
  /// See also [bpElearnWeeklyExamResults].
  BpElearnWeeklyExamResultsProvider({required int page, required int limit})
    : this._internal(
        (ref) => bpElearnWeeklyExamResults(
          ref as BpElearnWeeklyExamResultsRef,
          page: page,
          limit: limit,
        ),
        from: bpElearnWeeklyExamResultsProvider,
        name: r'bpElearnWeeklyExamResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bpElearnWeeklyExamResultsHash,
        dependencies: BpElearnWeeklyExamResultsFamily._dependencies,
        allTransitiveDependencies:
            BpElearnWeeklyExamResultsFamily._allTransitiveDependencies,
        page: page,
        limit: limit,
      );

  BpElearnWeeklyExamResultsProvider._internal(
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
    FutureOr<BpElearnPaginatedResponseDto> Function(
      BpElearnWeeklyExamResultsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BpElearnWeeklyExamResultsProvider._internal(
        (ref) => create(ref as BpElearnWeeklyExamResultsRef),
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
  AutoDisposeFutureProviderElement<BpElearnPaginatedResponseDto>
  createElement() {
    return _BpElearnWeeklyExamResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BpElearnWeeklyExamResultsProvider &&
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
mixin BpElearnWeeklyExamResultsRef
    on AutoDisposeFutureProviderRef<BpElearnPaginatedResponseDto> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _BpElearnWeeklyExamResultsProviderElement
    extends AutoDisposeFutureProviderElement<BpElearnPaginatedResponseDto>
    with BpElearnWeeklyExamResultsRef {
  _BpElearnWeeklyExamResultsProviderElement(super.provider);

  @override
  int get page => (origin as BpElearnWeeklyExamResultsProvider).page;
  @override
  int get limit => (origin as BpElearnWeeklyExamResultsProvider).limit;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
