// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$examListHash() => r'7f83241d73c2637c66c2f02cb9ae74290a567ccc';

/// Notifier that manages the exam-specific course list and its independent sync state.
///
/// Copied from [ExamList].
@ProviderFor(ExamList)
final examListProvider =
    StreamNotifierProvider<ExamList, List<CourseDto>>.internal(
      ExamList.new,
      name: r'examListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$examListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExamList = StreamNotifier<List<CourseDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
