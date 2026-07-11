// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$forumRepositoryHash() => r'085755f0b01a618f5faaf049e8ed0dfe66ae4989';

/// See also [forumRepository].
@ProviderFor(forumRepository)
final forumRepositoryProvider = FutureProvider<ForumRepository>.internal(
  forumRepository,
  name: r'forumRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$forumRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ForumRepositoryRef = FutureProviderRef<ForumRepository>;
String _$globalForumCategoriesHash() =>
    r'84bad9a5238ba442a11a6f16f947bf2add28cb11';

/// See also [globalForumCategories].
@ProviderFor(globalForumCategories)
final globalForumCategoriesProvider =
    FutureProvider<List<ForumCategoryDto>>.internal(
      globalForumCategories,
      name: r'globalForumCategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$globalForumCategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GlobalForumCategoriesRef = FutureProviderRef<List<ForumCategoryDto>>;
String _$postForumCommentHash() => r'dff11df23405bb814a6b893d54a56694ade1f7ec';

/// See also [PostForumComment].
@ProviderFor(PostForumComment)
final postForumCommentProvider =
    AutoDisposeAsyncNotifierProvider<PostForumComment, void>.internal(
      PostForumComment.new,
      name: r'postForumCommentProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$postForumCommentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PostForumComment = AutoDisposeAsyncNotifier<void>;
String _$createForumThreadHash() => r'68830dfb776fb7f593f0f6ebd16e3a2127fcad1e';

/// See also [CreateForumThread].
@ProviderFor(CreateForumThread)
final createForumThreadProvider =
    AutoDisposeAsyncNotifierProvider<CreateForumThread, void>.internal(
      CreateForumThread.new,
      name: r'createForumThreadProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createForumThreadHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CreateForumThread = AutoDisposeAsyncNotifier<void>;
String _$globalForumFeedHash() => r'736c942f31480e9c06c8589528dd7157b96c7c81';

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

abstract class _$GlobalForumFeed
    extends BuildlessAutoDisposeAsyncNotifier<GlobalForumFeedState> {
  late final int? categoryId;
  late final String? searchQuery;
  late final ForumActivityFilter? activityFilter;
  late final ForumSort? sortOrder;

  FutureOr<GlobalForumFeedState> build({
    int? categoryId,
    String? searchQuery,
    ForumActivityFilter? activityFilter,
    ForumSort? sortOrder,
  });
}

/// See also [GlobalForumFeed].
@ProviderFor(GlobalForumFeed)
const globalForumFeedProvider = GlobalForumFeedFamily();

/// See also [GlobalForumFeed].
class GlobalForumFeedFamily extends Family<AsyncValue<GlobalForumFeedState>> {
  /// See also [GlobalForumFeed].
  const GlobalForumFeedFamily();

  /// See also [GlobalForumFeed].
  GlobalForumFeedProvider call({
    int? categoryId,
    String? searchQuery,
    ForumActivityFilter? activityFilter,
    ForumSort? sortOrder,
  }) {
    return GlobalForumFeedProvider(
      categoryId: categoryId,
      searchQuery: searchQuery,
      activityFilter: activityFilter,
      sortOrder: sortOrder,
    );
  }

  @override
  GlobalForumFeedProvider getProviderOverride(
    covariant GlobalForumFeedProvider provider,
  ) {
    return call(
      categoryId: provider.categoryId,
      searchQuery: provider.searchQuery,
      activityFilter: provider.activityFilter,
      sortOrder: provider.sortOrder,
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
  String? get name => r'globalForumFeedProvider';
}

/// See also [GlobalForumFeed].
class GlobalForumFeedProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          GlobalForumFeed,
          GlobalForumFeedState
        > {
  /// See also [GlobalForumFeed].
  GlobalForumFeedProvider({
    int? categoryId,
    String? searchQuery,
    ForumActivityFilter? activityFilter,
    ForumSort? sortOrder,
  }) : this._internal(
         () => GlobalForumFeed()
           ..categoryId = categoryId
           ..searchQuery = searchQuery
           ..activityFilter = activityFilter
           ..sortOrder = sortOrder,
         from: globalForumFeedProvider,
         name: r'globalForumFeedProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$globalForumFeedHash,
         dependencies: GlobalForumFeedFamily._dependencies,
         allTransitiveDependencies:
             GlobalForumFeedFamily._allTransitiveDependencies,
         categoryId: categoryId,
         searchQuery: searchQuery,
         activityFilter: activityFilter,
         sortOrder: sortOrder,
       );

  GlobalForumFeedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.searchQuery,
    required this.activityFilter,
    required this.sortOrder,
  }) : super.internal();

  final int? categoryId;
  final String? searchQuery;
  final ForumActivityFilter? activityFilter;
  final ForumSort? sortOrder;

  @override
  FutureOr<GlobalForumFeedState> runNotifierBuild(
    covariant GlobalForumFeed notifier,
  ) {
    return notifier.build(
      categoryId: categoryId,
      searchQuery: searchQuery,
      activityFilter: activityFilter,
      sortOrder: sortOrder,
    );
  }

  @override
  Override overrideWith(GlobalForumFeed Function() create) {
    return ProviderOverride(
      origin: this,
      override: GlobalForumFeedProvider._internal(
        () => create()
          ..categoryId = categoryId
          ..searchQuery = searchQuery
          ..activityFilter = activityFilter
          ..sortOrder = sortOrder,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        searchQuery: searchQuery,
        activityFilter: activityFilter,
        sortOrder: sortOrder,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GlobalForumFeed, GlobalForumFeedState>
  createElement() {
    return _GlobalForumFeedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GlobalForumFeedProvider &&
        other.categoryId == categoryId &&
        other.searchQuery == searchQuery &&
        other.activityFilter == activityFilter &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);
    hash = _SystemHash.combine(hash, activityFilter.hashCode);
    hash = _SystemHash.combine(hash, sortOrder.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GlobalForumFeedRef
    on AutoDisposeAsyncNotifierProviderRef<GlobalForumFeedState> {
  /// The parameter `categoryId` of this provider.
  int? get categoryId;

  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;

  /// The parameter `activityFilter` of this provider.
  ForumActivityFilter? get activityFilter;

  /// The parameter `sortOrder` of this provider.
  ForumSort? get sortOrder;
}

class _GlobalForumFeedProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          GlobalForumFeed,
          GlobalForumFeedState
        >
    with GlobalForumFeedRef {
  _GlobalForumFeedProviderElement(super.provider);

  @override
  int? get categoryId => (origin as GlobalForumFeedProvider).categoryId;
  @override
  String? get searchQuery => (origin as GlobalForumFeedProvider).searchQuery;
  @override
  ForumActivityFilter? get activityFilter =>
      (origin as GlobalForumFeedProvider).activityFilter;
  @override
  ForumSort? get sortOrder => (origin as GlobalForumFeedProvider).sortOrder;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
