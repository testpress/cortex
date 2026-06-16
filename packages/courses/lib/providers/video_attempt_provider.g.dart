// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_attempt_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoAttemptNotifierHash() =>
    r'e78198ca07077083bdd3c77b8122bbd0b9a61ff5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$VideoAttemptNotifier
    extends BuildlessAutoDisposeNotifier<void> {
  late final int chapterContentId;

  void build(
    int chapterContentId,
  );
}

/// See also [VideoAttemptNotifier].
@ProviderFor(VideoAttemptNotifier)
const videoAttemptNotifierProvider = VideoAttemptNotifierFamily();

/// See also [VideoAttemptNotifier].
class VideoAttemptNotifierFamily extends Family<void> {
  /// See also [VideoAttemptNotifier].
  const VideoAttemptNotifierFamily();

  /// See also [VideoAttemptNotifier].
  VideoAttemptNotifierProvider call(
    int chapterContentId,
  ) {
    return VideoAttemptNotifierProvider(
      chapterContentId,
    );
  }

  @override
  VideoAttemptNotifierProvider getProviderOverride(
    covariant VideoAttemptNotifierProvider provider,
  ) {
    return call(
      provider.chapterContentId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'videoAttemptNotifierProvider';
}

/// See also [VideoAttemptNotifier].
class VideoAttemptNotifierProvider
    extends AutoDisposeNotifierProviderImpl<VideoAttemptNotifier, void> {
  /// See also [VideoAttemptNotifier].
  VideoAttemptNotifierProvider(
    int chapterContentId,
  ) : this._internal(
          () => VideoAttemptNotifier()..chapterContentId = chapterContentId,
          from: videoAttemptNotifierProvider,
          name: r'videoAttemptNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$videoAttemptNotifierHash,
          dependencies: VideoAttemptNotifierFamily._dependencies,
          allTransitiveDependencies:
              VideoAttemptNotifierFamily._allTransitiveDependencies,
          chapterContentId: chapterContentId,
        );

  VideoAttemptNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterContentId,
  }) : super.internal();

  final int chapterContentId;

  @override
  void runNotifierBuild(
    covariant VideoAttemptNotifier notifier,
  ) {
    return notifier.build(
      chapterContentId,
    );
  }

  @override
  Override overrideWith(VideoAttemptNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: VideoAttemptNotifierProvider._internal(
        () => create()..chapterContentId = chapterContentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterContentId: chapterContentId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<VideoAttemptNotifier, void>
      createElement() {
    return _VideoAttemptNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoAttemptNotifierProvider &&
        other.chapterContentId == chapterContentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterContentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VideoAttemptNotifierRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `chapterContentId` of this provider.
  int get chapterContentId;
}

class _VideoAttemptNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<VideoAttemptNotifier, void>
    with VideoAttemptNotifierRef {
  _VideoAttemptNotifierProviderElement(super.provider);

  @override
  int get chapterContentId =>
      (origin as VideoAttemptNotifierProvider).chapterContentId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
