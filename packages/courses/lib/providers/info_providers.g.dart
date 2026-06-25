// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$infoSyncMetadataHash() => r'ef698891e009e2c904e5a94119b3ddaee4d9d8fb';

/// See also [InfoSyncMetadata].
@ProviderFor(InfoSyncMetadata)
final infoSyncMetadataProvider =
    NotifierProvider<InfoSyncMetadata, DateTime?>.internal(
  InfoSyncMetadata.new,
  name: r'infoSyncMetadataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$infoSyncMetadataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InfoSyncMetadata = Notifier<DateTime?>;
String _$infoListHash() => r'58ac4e4fba532f6ce22014cf7bffb191398b65b6';

/// Notifier that manages the info-specific course list and its independent sync state.
/// This perfectly matches the pattern used in ExamList.
///
/// Copied from [InfoList].
@ProviderFor(InfoList)
final infoListProvider =
    AutoDisposeStreamNotifierProvider<InfoList, List<CourseDto>>.internal(
  InfoList.new,
  name: r'infoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$infoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InfoList = AutoDisposeStreamNotifier<List<CourseDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
