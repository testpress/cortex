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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
