// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$infoSyncMetadataHash() => r'53aca41c197f041e1b8e21d885fc9ac36d031e67';

/// See also [InfoSyncMetadata].
@ProviderFor(InfoSyncMetadata)
final infoSyncMetadataProvider =
    AutoDisposeNotifierProvider<InfoSyncMetadata, DateTime?>.internal(
  InfoSyncMetadata.new,
  name: r'infoSyncMetadataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$infoSyncMetadataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InfoSyncMetadata = AutoDisposeNotifier<DateTime?>;
String _$infoListHash() => r'2c512a7ddda227b53cb2a18f6863de28cc348417';

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
