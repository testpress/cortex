// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lessonDetailHash() => r'42b3924defadc4bfebcbf317ed0bb0109d40bdf7';

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
/// This provider searches through all chapters of all enrolled courses
/// to find the matching [LessonDto] and maps it to the domain [Lesson].
///
/// Copied from [lessonDetail].
@ProviderFor(lessonDetail)
const lessonDetailProvider = LessonDetailFamily();

/// Provider that fetches a specific lesson domain model by its ID.
///
/// This provider searches through all chapters of all enrolled courses
/// to find the matching [LessonDto] and maps it to the domain [Lesson].
///
/// Copied from [lessonDetail].
class LessonDetailFamily extends Family<AsyncValue<Lesson?>> {
  /// Provider that fetches a specific lesson domain model by its ID.
  ///
  /// This provider searches through all chapters of all enrolled courses
  /// to find the matching [LessonDto] and maps it to the domain [Lesson].
  ///
  /// Copied from [lessonDetail].
  const LessonDetailFamily();

  /// Provider that fetches a specific lesson domain model by its ID.
  ///
  /// This provider searches through all chapters of all enrolled courses
  /// to find the matching [LessonDto] and maps it to the domain [Lesson].
  ///
  /// Copied from [lessonDetail].
  LessonDetailProvider call(String lessonId) {
    return LessonDetailProvider(lessonId);
  }

  @override
  LessonDetailProvider getProviderOverride(
    covariant LessonDetailProvider provider,
  ) {
    return call(provider.lessonId);
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
/// This provider searches through all chapters of all enrolled courses
/// to find the matching [LessonDto] and maps it to the domain [Lesson].
///
/// Copied from [lessonDetail].
class LessonDetailProvider extends AutoDisposeFutureProvider<Lesson?> {
  /// Provider that fetches a specific lesson domain model by its ID.
  ///
  /// This provider searches through all chapters of all enrolled courses
  /// to find the matching [LessonDto] and maps it to the domain [Lesson].
  ///
  /// Copied from [lessonDetail].
  LessonDetailProvider(String lessonId)
    : this._internal(
        (ref) => lessonDetail(ref as LessonDetailRef, lessonId),
        from: lessonDetailProvider,
        name: r'lessonDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
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
    FutureOr<Lesson?> Function(LessonDetailRef provider) create,
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
  AutoDisposeFutureProviderElement<Lesson?> createElement() {
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
mixin LessonDetailRef on AutoDisposeFutureProviderRef<Lesson?> {
  /// The parameter `lessonId` of this provider.
  String get lessonId;
}

class _LessonDetailProviderElement
    extends AutoDisposeFutureProviderElement<Lesson?>
    with LessonDetailRef {
  _LessonDetailProviderElement(super.provider);

  @override
  String get lessonId => (origin as LessonDetailProvider).lessonId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
