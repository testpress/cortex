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
String _$doubtsSearchHash() => r'3a374b2f9dfe39ac251dfa2d88464a40ec540a8c';

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

/// See also [doubtsSearch].
@ProviderFor(doubtsSearch)
const doubtsSearchProvider = DoubtsSearchFamily();

/// See also [doubtsSearch].
class DoubtsSearchFamily extends Family<AsyncValue<List<DoubtDto>>> {
  /// See also [doubtsSearch].
  const DoubtsSearchFamily();

  /// See also [doubtsSearch].
  DoubtsSearchProvider call(String query) {
    return DoubtsSearchProvider(query);
  }

  @override
  DoubtsSearchProvider getProviderOverride(
    covariant DoubtsSearchProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'doubtsSearchProvider';
}

/// See also [doubtsSearch].
class DoubtsSearchProvider extends AutoDisposeFutureProvider<List<DoubtDto>> {
  /// See also [doubtsSearch].
  DoubtsSearchProvider(String query)
    : this._internal(
        (ref) => doubtsSearch(ref as DoubtsSearchRef, query),
        from: doubtsSearchProvider,
        name: r'doubtsSearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$doubtsSearchHash,
        dependencies: DoubtsSearchFamily._dependencies,
        allTransitiveDependencies:
            DoubtsSearchFamily._allTransitiveDependencies,
        query: query,
      );

  DoubtsSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<DoubtDto>> Function(DoubtsSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DoubtsSearchProvider._internal(
        (ref) => create(ref as DoubtsSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DoubtDto>> createElement() {
    return _DoubtsSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DoubtsSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DoubtsSearchRef on AutoDisposeFutureProviderRef<List<DoubtDto>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _DoubtsSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<DoubtDto>>
    with DoubtsSearchRef {
  _DoubtsSearchProviderElement(super.provider);

  @override
  String get query => (origin as DoubtsSearchProvider).query;
}

String _$doubtTopicsSyncHash() => r'60062db8ad7381a14c31707ce688f1e2d6a743c2';

/// See also [doubtTopicsSync].
@ProviderFor(doubtTopicsSync)
final doubtTopicsSyncProvider = AutoDisposeFutureProvider<void>.internal(
  doubtTopicsSync,
  name: r'doubtTopicsSyncProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$doubtTopicsSyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DoubtTopicsSyncRef = AutoDisposeFutureProviderRef<void>;
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
String _$doubtDetailHash() => r'a300245f15c35b44b5d9d1bcc64b573261e6dd38';

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

String _$doubtRepliesHash() => r'86caff30649d69fde242ffc082476bb9c1e4bb03';

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
    extends AutoDisposeStreamProvider<List<DoubtReplyDto>> {
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
    Stream<List<DoubtReplyDto>> Function(DoubtRepliesRef provider) create,
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
  AutoDisposeStreamProviderElement<List<DoubtReplyDto>> createElement() {
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
mixin DoubtRepliesRef on AutoDisposeStreamProviderRef<List<DoubtReplyDto>> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DoubtRepliesProviderElement
    extends AutoDisposeStreamProviderElement<List<DoubtReplyDto>>
    with DoubtRepliesRef {
  _DoubtRepliesProviderElement(super.provider);

  @override
  String get id => (origin as DoubtRepliesProvider).id;
}

String _$doubtSubtopicsHash() => r'3769d2ba5041f8bbe0f96eb30d4dc6c2cdcba664';

/// See also [doubtSubtopics].
@ProviderFor(doubtSubtopics)
const doubtSubtopicsProvider = DoubtSubtopicsFamily();

/// See also [doubtSubtopics].
class DoubtSubtopicsFamily extends Family<AsyncValue<List<DoubtTopicDto>>> {
  /// See also [doubtSubtopics].
  const DoubtSubtopicsFamily();

  /// See also [doubtSubtopics].
  DoubtSubtopicsProvider call(int? parentId) {
    return DoubtSubtopicsProvider(parentId);
  }

  @override
  DoubtSubtopicsProvider getProviderOverride(
    covariant DoubtSubtopicsProvider provider,
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
  String? get name => r'doubtSubtopicsProvider';
}

/// See also [doubtSubtopics].
class DoubtSubtopicsProvider
    extends AutoDisposeStreamProvider<List<DoubtTopicDto>> {
  /// See also [doubtSubtopics].
  DoubtSubtopicsProvider(int? parentId)
    : this._internal(
        (ref) => doubtSubtopics(ref as DoubtSubtopicsRef, parentId),
        from: doubtSubtopicsProvider,
        name: r'doubtSubtopicsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$doubtSubtopicsHash,
        dependencies: DoubtSubtopicsFamily._dependencies,
        allTransitiveDependencies:
            DoubtSubtopicsFamily._allTransitiveDependencies,
        parentId: parentId,
      );

  DoubtSubtopicsProvider._internal(
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
    Stream<List<DoubtTopicDto>> Function(DoubtSubtopicsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DoubtSubtopicsProvider._internal(
        (ref) => create(ref as DoubtSubtopicsRef),
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
  AutoDisposeStreamProviderElement<List<DoubtTopicDto>> createElement() {
    return _DoubtSubtopicsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DoubtSubtopicsProvider && other.parentId == parentId;
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
mixin DoubtSubtopicsRef on AutoDisposeStreamProviderRef<List<DoubtTopicDto>> {
  /// The parameter `parentId` of this provider.
  int? get parentId;
}

class _DoubtSubtopicsProviderElement
    extends AutoDisposeStreamProviderElement<List<DoubtTopicDto>>
    with DoubtSubtopicsRef {
  _DoubtSubtopicsProviderElement(super.provider);

  @override
  int? get parentId => (origin as DoubtSubtopicsProvider).parentId;
}

String _$doubtsSyncHash() => r'ed766ce109e1659927f16f3fa2d76bd46ce06f55';

/// See also [DoubtsSync].
@ProviderFor(DoubtsSync)
final doubtsSyncProvider =
    AutoDisposeAsyncNotifierProvider<DoubtsSync, void>.internal(
      DoubtsSync.new,
      name: r'doubtsSyncProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$doubtsSyncHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DoubtsSync = AutoDisposeAsyncNotifier<void>;
String _$createDoubtNotifierHash() =>
    r'b015ae4d53e721e0e660c8043260d81fc4d4355c';

/// See also [CreateDoubtNotifier].
@ProviderFor(CreateDoubtNotifier)
final createDoubtNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CreateDoubtNotifier, void>.internal(
      CreateDoubtNotifier.new,
      name: r'createDoubtNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createDoubtNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CreateDoubtNotifier = AutoDisposeAsyncNotifier<void>;
String _$postDoubtReplyNotifierHash() =>
    r'bcee50857504643d07423aa10842537a0e417cd6';

/// See also [PostDoubtReplyNotifier].
@ProviderFor(PostDoubtReplyNotifier)
final postDoubtReplyNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PostDoubtReplyNotifier, void>.internal(
      PostDoubtReplyNotifier.new,
      name: r'postDoubtReplyNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$postDoubtReplyNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PostDoubtReplyNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
