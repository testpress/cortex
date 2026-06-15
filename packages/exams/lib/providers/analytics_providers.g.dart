// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subjectAnalyticsRepositoryHash() =>
    r'f5cae0d3f40def3d518ce428f495325584125df9';

/// See also [subjectAnalyticsRepository].
@ProviderFor(subjectAnalyticsRepository)
final subjectAnalyticsRepositoryProvider =
    FutureProvider<SubjectAnalyticsRepository>.internal(
      subjectAnalyticsRepository,
      name: r'subjectAnalyticsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subjectAnalyticsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubjectAnalyticsRepositoryRef =
    FutureProviderRef<SubjectAnalyticsRepository>;
String _$subjectAnalyticsHash() => r'3f364d611df75ae63e558185c339e9dc6d3bf049';

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

/// See also [subjectAnalytics].
@ProviderFor(subjectAnalytics)
const subjectAnalyticsProvider = SubjectAnalyticsFamily();

/// See also [subjectAnalytics].
class SubjectAnalyticsFamily
    extends Family<AsyncValue<List<SubjectAnalyticsDto>>> {
  /// See also [subjectAnalytics].
  const SubjectAnalyticsFamily();

  /// See also [subjectAnalytics].
  SubjectAnalyticsProvider call(int? parentId) {
    return SubjectAnalyticsProvider(parentId);
  }

  @override
  SubjectAnalyticsProvider getProviderOverride(
    covariant SubjectAnalyticsProvider provider,
  ) {
    return call(provider.parentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subjectAnalyticsProvider';
}

/// See also [subjectAnalytics].
class SubjectAnalyticsProvider
    extends AutoDisposeStreamProvider<List<SubjectAnalyticsDto>> {
  /// See also [subjectAnalytics].
  SubjectAnalyticsProvider(int? parentId)
    : this._internal(
        (ref) => subjectAnalytics(ref as SubjectAnalyticsRef, parentId),
        from: subjectAnalyticsProvider,
        name: r'subjectAnalyticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$subjectAnalyticsHash,
        dependencies: SubjectAnalyticsFamily._dependencies,
        allTransitiveDependencies:
            SubjectAnalyticsFamily._allTransitiveDependencies,
        parentId: parentId,
      );

  SubjectAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parentId,
  }) : super.internal();

  final int? parentId;

  @override
  Override overrideWith(
    Stream<List<SubjectAnalyticsDto>> Function(SubjectAnalyticsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubjectAnalyticsProvider._internal(
        (ref) => create(ref as SubjectAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parentId: parentId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<SubjectAnalyticsDto>> createElement() {
    return _SubjectAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubjectAnalyticsProvider && other.parentId == parentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubjectAnalyticsRef
    on AutoDisposeStreamProviderRef<List<SubjectAnalyticsDto>> {
  /// The parameter `parentId` of this provider.
  int? get parentId;
}

class _SubjectAnalyticsProviderElement
    extends AutoDisposeStreamProviderElement<List<SubjectAnalyticsDto>>
    with SubjectAnalyticsRef {
  _SubjectAnalyticsProviderElement(super.provider);

  @override
  int? get parentId => (origin as SubjectAnalyticsProvider).parentId;
}

String _$subjectAnalyticsByIdHash() =>
    r'e1062dfd77a5bd7a1516f9215f2ec4face06f45e';

/// See also [subjectAnalyticsById].
@ProviderFor(subjectAnalyticsById)
const subjectAnalyticsByIdProvider = SubjectAnalyticsByIdFamily();

/// See also [subjectAnalyticsById].
class SubjectAnalyticsByIdFamily
    extends Family<AsyncValue<SubjectAnalyticsDto?>> {
  /// See also [subjectAnalyticsById].
  const SubjectAnalyticsByIdFamily();

  /// See also [subjectAnalyticsById].
  SubjectAnalyticsByIdProvider call(int id) {
    return SubjectAnalyticsByIdProvider(id);
  }

  @override
  SubjectAnalyticsByIdProvider getProviderOverride(
    covariant SubjectAnalyticsByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subjectAnalyticsByIdProvider';
}

/// See also [subjectAnalyticsById].
class SubjectAnalyticsByIdProvider
    extends AutoDisposeStreamProvider<SubjectAnalyticsDto?> {
  /// See also [subjectAnalyticsById].
  SubjectAnalyticsByIdProvider(int id)
    : this._internal(
        (ref) => subjectAnalyticsById(ref as SubjectAnalyticsByIdRef, id),
        from: subjectAnalyticsByIdProvider,
        name: r'subjectAnalyticsByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$subjectAnalyticsByIdHash,
        dependencies: SubjectAnalyticsByIdFamily._dependencies,
        allTransitiveDependencies:
            SubjectAnalyticsByIdFamily._allTransitiveDependencies,
        id: id,
      );

  SubjectAnalyticsByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    Stream<SubjectAnalyticsDto?> Function(SubjectAnalyticsByIdRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubjectAnalyticsByIdProvider._internal(
        (ref) => create(ref as SubjectAnalyticsByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<SubjectAnalyticsDto?> createElement() {
    return _SubjectAnalyticsByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubjectAnalyticsByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubjectAnalyticsByIdRef
    on AutoDisposeStreamProviderRef<SubjectAnalyticsDto?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _SubjectAnalyticsByIdProviderElement
    extends AutoDisposeStreamProviderElement<SubjectAnalyticsDto?>
    with SubjectAnalyticsByIdRef {
  _SubjectAnalyticsByIdProviderElement(super.provider);

  @override
  int get id => (origin as SubjectAnalyticsByIdProvider).id;
}

String _$subjectAnalyticsPaginationHash() =>
    r'5bebbfc3c477072d34f12628584e4d189658f253';

abstract class _$SubjectAnalyticsPagination
    extends BuildlessNotifier<SubjectAnalyticsPaginationState> {
  late final int? parentId;

  SubjectAnalyticsPaginationState build(int? parentId);
}

/// See also [SubjectAnalyticsPagination].
@ProviderFor(SubjectAnalyticsPagination)
const subjectAnalyticsPaginationProvider = SubjectAnalyticsPaginationFamily();

/// See also [SubjectAnalyticsPagination].
class SubjectAnalyticsPaginationFamily
    extends Family<SubjectAnalyticsPaginationState> {
  /// See also [SubjectAnalyticsPagination].
  const SubjectAnalyticsPaginationFamily();

  /// See also [SubjectAnalyticsPagination].
  SubjectAnalyticsPaginationProvider call(int? parentId) {
    return SubjectAnalyticsPaginationProvider(parentId);
  }

  @override
  SubjectAnalyticsPaginationProvider getProviderOverride(
    covariant SubjectAnalyticsPaginationProvider provider,
  ) {
    return call(provider.parentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'subjectAnalyticsPaginationProvider';
}

/// See also [SubjectAnalyticsPagination].
class SubjectAnalyticsPaginationProvider
    extends
        NotifierProviderImpl<
          SubjectAnalyticsPagination,
          SubjectAnalyticsPaginationState
        > {
  /// See also [SubjectAnalyticsPagination].
  SubjectAnalyticsPaginationProvider(int? parentId)
    : this._internal(
        () => SubjectAnalyticsPagination()..parentId = parentId,
        from: subjectAnalyticsPaginationProvider,
        name: r'subjectAnalyticsPaginationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$subjectAnalyticsPaginationHash,
        dependencies: SubjectAnalyticsPaginationFamily._dependencies,
        allTransitiveDependencies:
            SubjectAnalyticsPaginationFamily._allTransitiveDependencies,
        parentId: parentId,
      );

  SubjectAnalyticsPaginationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parentId,
  }) : super.internal();

  final int? parentId;

  @override
  SubjectAnalyticsPaginationState runNotifierBuild(
    covariant SubjectAnalyticsPagination notifier,
  ) {
    return notifier.build(parentId);
  }

  @override
  Override overrideWith(SubjectAnalyticsPagination Function() create) {
    return ProviderOverride(
      origin: this,
      override: SubjectAnalyticsPaginationProvider._internal(
        () => create()..parentId = parentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parentId: parentId,
      ),
    );
  }

  @override
  NotifierProviderElement<
    SubjectAnalyticsPagination,
    SubjectAnalyticsPaginationState
  >
  createElement() {
    return _SubjectAnalyticsPaginationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubjectAnalyticsPaginationProvider &&
        other.parentId == parentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubjectAnalyticsPaginationRef
    on NotifierProviderRef<SubjectAnalyticsPaginationState> {
  /// The parameter `parentId` of this provider.
  int? get parentId;
}

class _SubjectAnalyticsPaginationProviderElement
    extends
        NotifierProviderElement<
          SubjectAnalyticsPagination,
          SubjectAnalyticsPaginationState
        >
    with SubjectAnalyticsPaginationRef {
  _SubjectAnalyticsPaginationProviderElement(super.provider);

  @override
  int? get parentId => (origin as SubjectAnalyticsPaginationProvider).parentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
