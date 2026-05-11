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
String _$doubtDetailHash() => r'5bd0f6afed1967e71977ece8b3c13e907f970d82';

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

/// See also [doubtDetail].
@ProviderFor(doubtDetail)
const doubtDetailProvider = DoubtDetailFamily();

/// See also [doubtDetail].
class DoubtDetailFamily extends Family<AsyncValue<DoubtDto>> {
  /// See also [doubtDetail].
  const DoubtDetailFamily();

  /// See also [doubtDetail].
  DoubtDetailProvider call(String id) {
    return DoubtDetailProvider(id);
  }

  @override
  DoubtDetailProvider getProviderOverride(
    covariant DoubtDetailProvider provider,
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
  String? get name => r'doubtDetailProvider';
}

/// See also [doubtDetail].
class DoubtDetailProvider extends AutoDisposeFutureProvider<DoubtDto> {
  /// See also [doubtDetail].
  DoubtDetailProvider(String id)
    : this._internal(
        (ref) => doubtDetail(ref as DoubtDetailRef, id),
        from: doubtDetailProvider,
        name: r'doubtDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$doubtDetailHash,
        dependencies: DoubtDetailFamily._dependencies,
        allTransitiveDependencies: DoubtDetailFamily._allTransitiveDependencies,
        id: id,
      );

  DoubtDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<DoubtDto> Function(DoubtDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DoubtDetailProvider._internal(
        (ref) => create(ref as DoubtDetailRef),
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
  AutoDisposeFutureProviderElement<DoubtDto> createElement() {
    return _DoubtDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DoubtDetailProvider && other.id == id;
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
mixin DoubtDetailRef on AutoDisposeFutureProviderRef<DoubtDto> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DoubtDetailProviderElement
    extends AutoDisposeFutureProviderElement<DoubtDto>
    with DoubtDetailRef {
  _DoubtDetailProviderElement(super.provider);

  @override
  String get id => (origin as DoubtDetailProvider).id;
}

String _$doubtRepliesHash() => r'857c4c511a96e35867eb6b0e5e77dc926a3d2139';

/// See also [doubtReplies].
@ProviderFor(doubtReplies)
const doubtRepliesProvider = DoubtRepliesFamily();

/// See also [doubtReplies].
class DoubtRepliesFamily extends Family<AsyncValue<List<DoubtReplyDto>>> {
  /// See also [doubtReplies].
  const DoubtRepliesFamily();

  /// See also [doubtReplies].
  DoubtRepliesProvider call(String id) {
    return DoubtRepliesProvider(id);
  }

  @override
  DoubtRepliesProvider getProviderOverride(
    covariant DoubtRepliesProvider provider,
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
  String? get name => r'doubtRepliesProvider';
}

/// See also [doubtReplies].
class DoubtRepliesProvider
    extends AutoDisposeFutureProvider<List<DoubtReplyDto>> {
  /// See also [doubtReplies].
  DoubtRepliesProvider(String id)
    : this._internal(
        (ref) => doubtReplies(ref as DoubtRepliesRef, id),
        from: doubtRepliesProvider,
        name: r'doubtRepliesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$doubtRepliesHash,
        dependencies: DoubtRepliesFamily._dependencies,
        allTransitiveDependencies:
            DoubtRepliesFamily._allTransitiveDependencies,
        id: id,
      );

  DoubtRepliesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<List<DoubtReplyDto>> Function(DoubtRepliesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DoubtRepliesProvider._internal(
        (ref) => create(ref as DoubtRepliesRef),
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
  AutoDisposeFutureProviderElement<List<DoubtReplyDto>> createElement() {
    return _DoubtRepliesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DoubtRepliesProvider && other.id == id;
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
mixin DoubtRepliesRef on AutoDisposeFutureProviderRef<List<DoubtReplyDto>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DoubtRepliesProviderElement
    extends AutoDisposeFutureProviderElement<List<DoubtReplyDto>>
    with DoubtRepliesRef {
  _DoubtRepliesProviderElement(super.provider);

  @override
  String get id => (origin as DoubtRepliesProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
