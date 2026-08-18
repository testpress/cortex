// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_stream_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isSyncingInitialPageHash() =>
    r'12e0fb8c0f9d2f5a8383d7d7b4f522068b294862';

/// Tracks if the initial page of live streams is currently syncing.
///
/// Copied from [IsSyncingInitialPage].
@ProviderFor(IsSyncingInitialPage)
final isSyncingInitialPageProvider =
    AutoDisposeNotifierProvider<IsSyncingInitialPage, bool>.internal(
      IsSyncingInitialPage.new,
      name: r'isSyncingInitialPageProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$isSyncingInitialPageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IsSyncingInitialPage = AutoDisposeNotifier<bool>;
String _$liveStreamSyncErrorHash() =>
    r'ae5acbe0c7c8e6f3d01cd1d5613539f42817a17e';

/// Tracks network sync errors.
///
/// Copied from [LiveStreamSyncError].
@ProviderFor(LiveStreamSyncError)
final liveStreamSyncErrorProvider =
    AutoDisposeNotifierProvider<LiveStreamSyncError, Object?>.internal(
      LiveStreamSyncError.new,
      name: r'liveStreamSyncErrorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$liveStreamSyncErrorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LiveStreamSyncError = AutoDisposeNotifier<Object?>;
String _$liveStreamListHash() => r'7dd739ee97bf671f8b8969b8c05baad35570fb48';

/// See also [LiveStreamList].
@ProviderFor(LiveStreamList)
final liveStreamListProvider =
    AutoDisposeStreamNotifierProvider<
      LiveStreamList,
      List<LiveStreamItem>
    >.internal(
      LiveStreamList.new,
      name: r'liveStreamListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$liveStreamListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LiveStreamList = AutoDisposeStreamNotifier<List<LiveStreamItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
