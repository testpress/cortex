// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allLessonsHash() => r'5545b3e72aa94aae83d09e13f6245baecd94f039';

/// Flattens the course/chapter hierarchy into a single stream of all lessons.
///
/// This allows for efficient O(N) filtering in the UI across the entire local cache.
///
/// Copied from [allLessons].
@ProviderFor(allLessons)
final allLessonsProvider = AutoDisposeStreamProvider<List<LessonDto>>.internal(
  allLessons,
  name: r'allLessonsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allLessonsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllLessonsRef = AutoDisposeStreamProviderRef<List<LessonDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
