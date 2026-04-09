// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allLessonsHash() => r'2e3abd56f29f24bcccd2ec4671b99e843582e019';

/// Flattens the course/chapter hierarchy into a single stream of all lessons.
/// This allows for efficient O(N) filtering in the UI.
///
/// Copied from [allLessons].
@ProviderFor(allLessons)
final allLessonsProvider = AutoDisposeProvider<List<LessonDto>>.internal(
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
typedef AllLessonsRef = AutoDisposeProviderRef<List<LessonDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
