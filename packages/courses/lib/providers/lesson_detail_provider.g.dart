// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lessonDetailHash() => r'9e139df21ca5187821988236c2364807a9c53f7d';

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

/// Provider that fetches a specific lesson domain model by its ID.
///
/// Copied from [lessonDetail].
@ProviderFor(lessonDetail)
const lessonDetailProvider = LessonDetailFamily();

/// Provider that fetches a specific lesson domain model by its ID.
///
/// Copied from [lessonDetail].
class LessonDetailFamily extends Family<AsyncValue<Lesson?>> {
  /// Provider that fetches a specific lesson domain model by its ID.
  ///
  /// Copied from [lessonDetail].
  const LessonDetailFamily();

  /// Provider that fetches a specific lesson domain model by its ID.
  ///
  /// Copied from [lessonDetail].
  LessonDetailProvider call(
    String lessonId,
  ) {
    return LessonDetailProvider(
      lessonId,
    );
  }

  @override
  LessonDetailProvider getProviderOverride(
    covariant LessonDetailProvider provider,
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
  String? get name => r'lessonDetailProvider';
}

/// Provider that fetches a specific lesson domain model by its ID.
///
/// Copied from [lessonDetail].
class LessonDetailProvider extends AutoDisposeStreamProvider<Lesson?> {
  /// Provider that fetches a specific lesson domain model by its ID.
  ///
  /// Copied from [lessonDetail].
  LessonDetailProvider(
    String lessonId,
  ) : this._internal(
          (ref) => lessonDetail(
            ref as LessonDetailRef,
            lessonId,
          ),
          from: lessonDetailProvider,
          name: r'lessonDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lessonDetailHash,
          dependencies: LessonDetailFamily._dependencies,
          allTransitiveDependencies:
              LessonDetailFamily._allTransitiveDependencies,
          lessonId: lessonId,
        );

  LessonDetailProvider._internal(
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
    Stream<Lesson?> Function(LessonDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LessonDetailProvider._internal(
        (ref) => create(ref as LessonDetailRef),
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
  AutoDisposeStreamProviderElement<Lesson?> createElement() {
    return _LessonDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonDetailProvider && other.lessonId == lessonId;
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
mixin LessonDetailRef on AutoDisposeStreamProviderRef<Lesson?> {
  /// The parameter `lessonId` of this provider.
  String get lessonId;
}

class _LessonDetailProviderElement
    extends AutoDisposeStreamProviderElement<Lesson?> with LessonDetailRef {
  _LessonDetailProviderElement(super.provider);

  @override
  String get lessonId => (origin as LessonDetailProvider).lessonId;
}

String _$lessonBookmarkHash() => r'5a2993eba7aeac8e300bbf1f51eaf2bfb54a813b';

/// Provider that watches and manages the bookmark status of a specific lesson.
///
/// Copied from [lessonBookmark].
@ProviderFor(lessonBookmark)
const lessonBookmarkProvider = LessonBookmarkFamily();

/// Provider that watches and manages the bookmark status of a specific lesson.
///
/// Copied from [lessonBookmark].
class LessonBookmarkFamily extends Family<AsyncValue<bool>> {
  /// Provider that watches and manages the bookmark status of a specific lesson.
  ///
  /// Copied from [lessonBookmark].
  const LessonBookmarkFamily();

  /// Provider that watches and manages the bookmark status of a specific lesson.
  ///
  /// Copied from [lessonBookmark].
  LessonBookmarkProvider call(
    String lessonId,
  ) {
    return LessonBookmarkProvider(
      lessonId,
    );
  }

  @override
  LessonBookmarkProvider getProviderOverride(
    covariant LessonBookmarkProvider provider,
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
  String? get name => r'lessonBookmarkProvider';
}

/// Provider that watches and manages the bookmark status of a specific lesson.
///
/// Copied from [lessonBookmark].
class LessonBookmarkProvider extends AutoDisposeStreamProvider<bool> {
  /// Provider that watches and manages the bookmark status of a specific lesson.
  ///
  /// Copied from [lessonBookmark].
  LessonBookmarkProvider(
    String lessonId,
  ) : this._internal(
          (ref) => lessonBookmark(
            ref as LessonBookmarkRef,
            lessonId,
          ),
          from: lessonBookmarkProvider,
          name: r'lessonBookmarkProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lessonBookmarkHash,
          dependencies: LessonBookmarkFamily._dependencies,
          allTransitiveDependencies:
              LessonBookmarkFamily._allTransitiveDependencies,
          lessonId: lessonId,
        );

  LessonBookmarkProvider._internal(
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
    Stream<bool> Function(LessonBookmarkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LessonBookmarkProvider._internal(
        (ref) => create(ref as LessonBookmarkRef),
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
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _LessonBookmarkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonBookmarkProvider && other.lessonId == lessonId;
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
mixin LessonBookmarkRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `lessonId` of this provider.
  String get lessonId;
}

class _LessonBookmarkProviderElement
    extends AutoDisposeStreamProviderElement<bool> with LessonBookmarkRef {
  _LessonBookmarkProviderElement(super.provider);

  @override
  String get lessonId => (origin as LessonBookmarkProvider).lessonId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
