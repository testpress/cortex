// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_results_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$modelExamResultsHash() => r'55400318a200c386f9076b3214fb2f09caf985bb';

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

/// See also [modelExamResults].
@ProviderFor(modelExamResults)
const modelExamResultsProvider = ModelExamResultsFamily();

/// See also [modelExamResults].
class ModelExamResultsFamily extends Family<AsyncValue<ExamResultResponseDto>> {
  /// See also [modelExamResults].
  const ModelExamResultsFamily();

  /// See also [modelExamResults].
  ModelExamResultsProvider call({required int page, required int limit}) {
    return ModelExamResultsProvider(page: page, limit: limit);
  }

  @override
  ModelExamResultsProvider getProviderOverride(
    covariant ModelExamResultsProvider provider,
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
  String? get name => r'modelExamResultsProvider';
}

/// See also [modelExamResults].
class ModelExamResultsProvider
    extends AutoDisposeFutureProvider<ExamResultResponseDto> {
  /// See also [modelExamResults].
  ModelExamResultsProvider({required int page, required int limit})
    : this._internal(
        (ref) => modelExamResults(
          ref as ModelExamResultsRef,
          page: page,
          limit: limit,
        ),
        from: modelExamResultsProvider,
        name: r'modelExamResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$modelExamResultsHash,
        dependencies: ModelExamResultsFamily._dependencies,
        allTransitiveDependencies:
            ModelExamResultsFamily._allTransitiveDependencies,
        page: page,
        limit: limit,
      );

  ModelExamResultsProvider._internal(
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
    FutureOr<ExamResultResponseDto> Function(ModelExamResultsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ModelExamResultsProvider._internal(
        (ref) => create(ref as ModelExamResultsRef),
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
  AutoDisposeFutureProviderElement<ExamResultResponseDto> createElement() {
    return _ModelExamResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ModelExamResultsProvider &&
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
mixin ModelExamResultsRef
    on AutoDisposeFutureProviderRef<ExamResultResponseDto> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _ModelExamResultsProviderElement
    extends AutoDisposeFutureProviderElement<ExamResultResponseDto>
    with ModelExamResultsRef {
  _ModelExamResultsProviderElement(super.provider);

  @override
  int get page => (origin as ModelExamResultsProvider).page;
  @override
  int get limit => (origin as ModelExamResultsProvider).limit;
}

String _$weeklyExamResultsHash() => r'61d11d08958182a70b2af0e3f7d9c0169c28b913';

/// See also [weeklyExamResults].
@ProviderFor(weeklyExamResults)
const weeklyExamResultsProvider = WeeklyExamResultsFamily();

/// See also [weeklyExamResults].
class WeeklyExamResultsFamily
    extends Family<AsyncValue<ExamResultResponseDto>> {
  /// See also [weeklyExamResults].
  const WeeklyExamResultsFamily();

  /// See also [weeklyExamResults].
  WeeklyExamResultsProvider call({required int page, required int limit}) {
    return WeeklyExamResultsProvider(page: page, limit: limit);
  }

  @override
  WeeklyExamResultsProvider getProviderOverride(
    covariant WeeklyExamResultsProvider provider,
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
  String? get name => r'weeklyExamResultsProvider';
}

/// See also [weeklyExamResults].
class WeeklyExamResultsProvider
    extends AutoDisposeFutureProvider<ExamResultResponseDto> {
  /// See also [weeklyExamResults].
  WeeklyExamResultsProvider({required int page, required int limit})
    : this._internal(
        (ref) => weeklyExamResults(
          ref as WeeklyExamResultsRef,
          page: page,
          limit: limit,
        ),
        from: weeklyExamResultsProvider,
        name: r'weeklyExamResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$weeklyExamResultsHash,
        dependencies: WeeklyExamResultsFamily._dependencies,
        allTransitiveDependencies:
            WeeklyExamResultsFamily._allTransitiveDependencies,
        page: page,
        limit: limit,
      );

  WeeklyExamResultsProvider._internal(
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
    FutureOr<ExamResultResponseDto> Function(WeeklyExamResultsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeeklyExamResultsProvider._internal(
        (ref) => create(ref as WeeklyExamResultsRef),
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
  AutoDisposeFutureProviderElement<ExamResultResponseDto> createElement() {
    return _WeeklyExamResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyExamResultsProvider &&
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
mixin WeeklyExamResultsRef
    on AutoDisposeFutureProviderRef<ExamResultResponseDto> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _WeeklyExamResultsProviderElement
    extends AutoDisposeFutureProviderElement<ExamResultResponseDto>
    with WeeklyExamResultsRef {
  _WeeklyExamResultsProviderElement(super.provider);

  @override
  int get page => (origin as WeeklyExamResultsProvider).page;
  @override
  int get limit => (origin as WeeklyExamResultsProvider).limit;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
