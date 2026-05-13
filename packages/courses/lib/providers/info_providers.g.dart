// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$infoListHash() => r'07e86c63d036a7ffc1ba3047e4d8052e51d7f995';

/// Notifier that manages the info-specific course list and its independent sync state.
/// This perfectly matches the pattern used in ExamList.
///
/// Copied from [InfoList].
@ProviderFor(InfoList)
final infoListProvider =
    StreamNotifierProvider<InfoList, List<CourseDto>>.internal(
  InfoList.new,
  name: r'infoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$infoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InfoList = StreamNotifier<List<CourseDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
