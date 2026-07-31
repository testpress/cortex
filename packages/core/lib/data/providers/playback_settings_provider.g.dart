// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playbackSettingsNotifierHash() =>
    r'6a1eb20a7ae0b849e8ade00d4dfcc8d5bf7b417d';

/// The active playback settings, owned by core so domain packages (courses,
/// profile) can read and update them without importing each other.
/// See ADR 0005-user-state-in-core.md.
///
/// Copied from [PlaybackSettingsNotifier].
@ProviderFor(PlaybackSettingsNotifier)
final playbackSettingsNotifierProvider =
    AsyncNotifierProvider<PlaybackSettingsNotifier, PlaybackSettings>.internal(
      PlaybackSettingsNotifier.new,
      name: r'playbackSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$playbackSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PlaybackSettingsNotifier = AsyncNotifier<PlaybackSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
