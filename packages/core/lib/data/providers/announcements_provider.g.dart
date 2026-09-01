// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$announcementsHash() => r'60e6b8d9e7ec37952855932dc6dfab14d026f291';

/// See also [Announcements].
@ProviderFor(Announcements)
final announcementsProvider =
    AutoDisposeStreamNotifierProvider<Announcements, List<PostDto>>.internal(
      Announcements.new,
      name: r'announcementsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$announcementsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Announcements = AutoDisposeStreamNotifier<List<PostDto>>;
String _$postCategoriesHash() => r'94c3254bfe8cdfd11784228f68837007e326d643';

/// See also [PostCategories].
@ProviderFor(PostCategories)
final postCategoriesProvider =
    AutoDisposeStreamNotifierProvider<
      PostCategories,
      List<PostCategoryDto>
    >.internal(
      PostCategories.new,
      name: r'postCategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$postCategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PostCategories = AutoDisposeStreamNotifier<List<PostCategoryDto>>;
String _$announcementsFetchingPageHash() =>
    r'8a7dede4c72097c4f34ff77a1b8201765223bd73';

/// See also [AnnouncementsFetchingPage].
@ProviderFor(AnnouncementsFetchingPage)
final announcementsFetchingPageProvider =
    AutoDisposeNotifierProvider<AnnouncementsFetchingPage, bool>.internal(
      AnnouncementsFetchingPage.new,
      name: r'announcementsFetchingPageProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$announcementsFetchingPageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AnnouncementsFetchingPage = AutoDisposeNotifier<bool>;
String _$categoryPostsHash() => r'1f5263a32be8df79ca28b67b4e4cda1262728ead';

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

abstract class _$CategoryPosts
    extends BuildlessAutoDisposeAsyncNotifier<List<PostDto>> {
  late final String categorySlug;

  FutureOr<List<PostDto>> build(String categorySlug);
}

/// Fetches posts filtered by a specific category slug directly from the server.
///
/// This is intentionally NOT cached to the local DB — it's a fresh, server-side
/// filtered view used when filtering announcements by category.
///
/// Copied from [CategoryPosts].
@ProviderFor(CategoryPosts)
const categoryPostsProvider = CategoryPostsFamily();

/// Fetches posts filtered by a specific category slug directly from the server.
///
/// This is intentionally NOT cached to the local DB — it's a fresh, server-side
/// filtered view used when filtering announcements by category.
///
/// Copied from [CategoryPosts].
class CategoryPostsFamily extends Family<AsyncValue<List<PostDto>>> {
  /// Fetches posts filtered by a specific category slug directly from the server.
  ///
  /// This is intentionally NOT cached to the local DB — it's a fresh, server-side
  /// filtered view used when filtering announcements by category.
  ///
  /// Copied from [CategoryPosts].
  const CategoryPostsFamily();

  /// Fetches posts filtered by a specific category slug directly from the server.
  ///
  /// This is intentionally NOT cached to the local DB — it's a fresh, server-side
  /// filtered view used when filtering announcements by category.
  ///
  /// Copied from [CategoryPosts].
  CategoryPostsProvider call(String categorySlug) {
    return CategoryPostsProvider(categorySlug);
  }

  @override
  CategoryPostsProvider getProviderOverride(
    covariant CategoryPostsProvider provider,
  ) {
    return call(provider.categorySlug);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryPostsProvider';
}

/// Fetches posts filtered by a specific category slug directly from the server.
///
/// This is intentionally NOT cached to the local DB — it's a fresh, server-side
/// filtered view used when filtering announcements by category.
///
/// Copied from [CategoryPosts].
class CategoryPostsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CategoryPosts, List<PostDto>> {
  /// Fetches posts filtered by a specific category slug directly from the server.
  ///
  /// This is intentionally NOT cached to the local DB — it's a fresh, server-side
  /// filtered view used when filtering announcements by category.
  ///
  /// Copied from [CategoryPosts].
  CategoryPostsProvider(String categorySlug)
    : this._internal(
        () => CategoryPosts()..categorySlug = categorySlug,
        from: categoryPostsProvider,
        name: r'categoryPostsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryPostsHash,
        dependencies: CategoryPostsFamily._dependencies,
        allTransitiveDependencies:
            CategoryPostsFamily._allTransitiveDependencies,
        categorySlug: categorySlug,
      );

  CategoryPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categorySlug,
  }) : super.internal();

  final String categorySlug;

  @override
  FutureOr<List<PostDto>> runNotifierBuild(covariant CategoryPosts notifier) {
    return notifier.build(categorySlug);
  }

  @override
  Override overrideWith(CategoryPosts Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryPostsProvider._internal(
        () => create()..categorySlug = categorySlug,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categorySlug: categorySlug,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CategoryPosts, List<PostDto>>
  createElement() {
    return _CategoryPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryPostsProvider && other.categorySlug == categorySlug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categorySlug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryPostsRef on AutoDisposeAsyncNotifierProviderRef<List<PostDto>> {
  /// The parameter `categorySlug` of this provider.
  String get categorySlug;
}

class _CategoryPostsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<CategoryPosts, List<PostDto>>
    with CategoryPostsRef {
  _CategoryPostsProviderElement(super.provider);

  @override
  String get categorySlug => (origin as CategoryPostsProvider).categorySlug;
}

String _$categoryPostsFetchingPageHash() =>
    r'b4a66c4b080b8148d45d76af30b73387c76fa530';

/// See also [CategoryPostsFetchingPage].
@ProviderFor(CategoryPostsFetchingPage)
final categoryPostsFetchingPageProvider =
    AutoDisposeNotifierProvider<CategoryPostsFetchingPage, bool>.internal(
      CategoryPostsFetchingPage.new,
      name: r'categoryPostsFetchingPageProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryPostsFetchingPageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CategoryPostsFetchingPage = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
