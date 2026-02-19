// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseListHash() => r'1fe2c93c58f635aaf386d66c6b1905e58d9179a5';

/// Stream provider for the full course list.
/// On first watch: triggers a refresh from DataSource → Drift.
/// Thereafter: streams live updates from the Drift DB.
///
/// Copied from [courseList].
@ProviderFor(courseList)
final courseListProvider = AutoDisposeStreamProvider<List<CourseDto>>.internal(
  courseList,
  name: r'courseListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$courseListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CourseListRef = AutoDisposeStreamProviderRef<List<CourseDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
