// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$downloadsHash() => r'005d68270a247ae6fca8f59c4bca3eaa97234d7f';

/// Single entry point for all download state and actions.
/// Mirrors the [Auth] notifier pattern from auth_provider.dart.
///
/// Usage:
///   - Watch state: `ref.watch(downloadsProvider)`
///   - Dispatch actions: `ref.read(downloadsProvider.notifier).startAttachmentDownload(...)`
///
/// Copied from [Downloads].
@ProviderFor(Downloads)
final downloadsProvider =
    StreamNotifierProvider<Downloads, List<DownloadItem>>.internal(
  Downloads.new,
  name: r'downloadsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$downloadsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Downloads = StreamNotifier<List<DownloadItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
