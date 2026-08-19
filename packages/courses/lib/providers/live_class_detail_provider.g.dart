// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_class_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$liveClassDetailHash() => r'def850371212792c3a32a79d756b27f74b2f8e49';

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

/// Provider that fetches a specific live class domain model by its ID.
///
/// Uses a timed keep-alive cache exactly like lessonDetailProvider.
///
/// Copied from [liveClassDetail].
@ProviderFor(liveClassDetail)
const liveClassDetailProvider = LiveClassDetailFamily();

/// Provider that fetches a specific live class domain model by its ID.
///
/// Uses a timed keep-alive cache exactly like lessonDetailProvider.
///
/// Copied from [liveClassDetail].
class LiveClassDetailFamily extends Family<AsyncValue<LessonDto?>> {
  /// Provider that fetches a specific live class domain model by its ID.
  ///
  /// Uses a timed keep-alive cache exactly like lessonDetailProvider.
  ///
  /// Copied from [liveClassDetail].
  const LiveClassDetailFamily();

  /// Provider that fetches a specific live class domain model by its ID.
  ///
  /// Uses a timed keep-alive cache exactly like lessonDetailProvider.
  ///
  /// Copied from [liveClassDetail].
  LiveClassDetailProvider call(
    String lessonId,
  ) {
    return LiveClassDetailProvider(
      lessonId,
    );
  }

  @override
  LiveClassDetailProvider getProviderOverride(
    covariant LiveClassDetailProvider provider,
  ) {
    return call(
      provider.lessonId,
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
  String? get name => r'liveClassDetailProvider';
}

/// Provider that fetches a specific live class domain model by its ID.
///
/// Uses a timed keep-alive cache exactly like lessonDetailProvider.
///
/// Copied from [liveClassDetail].
class LiveClassDetailProvider extends AutoDisposeStreamProvider<LessonDto?> {
  /// Provider that fetches a specific live class domain model by its ID.
  ///
  /// Uses a timed keep-alive cache exactly like lessonDetailProvider.
  ///
  /// Copied from [liveClassDetail].
  LiveClassDetailProvider(
    String lessonId,
  ) : this._internal(
          (ref) => liveClassDetail(
            ref as LiveClassDetailRef,
            lessonId,
          ),
          from: liveClassDetailProvider,
          name: r'liveClassDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$liveClassDetailHash,
          dependencies: LiveClassDetailFamily._dependencies,
          allTransitiveDependencies:
              LiveClassDetailFamily._allTransitiveDependencies,
          lessonId: lessonId,
        );

  LiveClassDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lessonId,
  }) : super.internal();

  final String lessonId;

  @override
  Override overrideWith(
    Stream<LessonDto?> Function(LiveClassDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LiveClassDetailProvider._internal(
        (ref) => create(ref as LiveClassDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lessonId: lessonId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<LessonDto?> createElement() {
    return _LiveClassDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LiveClassDetailProvider && other.lessonId == lessonId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LiveClassDetailRef on AutoDisposeStreamProviderRef<LessonDto?> {
  /// The parameter `lessonId` of this provider.
  String get lessonId;
}

class _LiveClassDetailProviderElement
    extends AutoDisposeStreamProviderElement<LessonDto?>
    with LiveClassDetailRef {
  _LiveClassDetailProviderElement(super.provider);

  @override
  String get lessonId => (origin as LiveClassDetailProvider).lessonId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
