// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterDetailHash() => r'c0726a6f59e65b33915e0ea7e9e5ed6e2f654927';

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

/// Provider that fetches a specific chapter with its lessons.
/// This provider maps the underlying DTOs to the [ChapterDto] domain model.
///
/// Copied from [chapterDetail].
@ProviderFor(chapterDetail)
const chapterDetailProvider = ChapterDetailFamily();

/// Provider that fetches a specific chapter with its lessons.
/// This provider maps the underlying DTOs to the [ChapterDto] domain model.
///
/// Copied from [chapterDetail].
class ChapterDetailFamily extends Family<AsyncValue<(ChapterDto, String?)?>> {
  /// Provider that fetches a specific chapter with its lessons.
  /// This provider maps the underlying DTOs to the [ChapterDto] domain model.
  ///
  /// Copied from [chapterDetail].
  const ChapterDetailFamily();

  /// Provider that fetches a specific chapter with its lessons.
  /// This provider maps the underlying DTOs to the [ChapterDto] domain model.
  ///
  /// Copied from [chapterDetail].
  ChapterDetailProvider call(
    String courseId,
    String chapterId,
  ) {
    return ChapterDetailProvider(
      courseId,
      chapterId,
    );
  }

  @override
  ChapterDetailProvider getProviderOverride(
    covariant ChapterDetailProvider provider,
  ) {
    return call(
      provider.courseId,
      provider.chapterId,
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
  String? get name => r'chapterDetailProvider';
}

/// Provider that fetches a specific chapter with its lessons.
/// This provider maps the underlying DTOs to the [ChapterDto] domain model.
///
/// Copied from [chapterDetail].
class ChapterDetailProvider extends StreamProvider<(ChapterDto, String?)?> {
  /// Provider that fetches a specific chapter with its lessons.
  /// This provider maps the underlying DTOs to the [ChapterDto] domain model.
  ///
  /// Copied from [chapterDetail].
  ChapterDetailProvider(
    String courseId,
    String chapterId,
  ) : this._internal(
          (ref) => chapterDetail(
            ref as ChapterDetailRef,
            courseId,
            chapterId,
          ),
          from: chapterDetailProvider,
          name: r'chapterDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterDetailHash,
          dependencies: ChapterDetailFamily._dependencies,
          allTransitiveDependencies:
              ChapterDetailFamily._allTransitiveDependencies,
          courseId: courseId,
          chapterId: chapterId,
        );

  ChapterDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
    required this.chapterId,
  }) : super.internal();

  final String courseId;
  final String chapterId;

  @override
  Override overrideWith(
    Stream<(ChapterDto, String?)?> Function(ChapterDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterDetailProvider._internal(
        (ref) => create(ref as ChapterDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
        chapterId: chapterId,
      ),
    );
  }

  @override
  StreamProviderElement<(ChapterDto, String?)?> createElement() {
    return _ChapterDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterDetailProvider &&
        other.courseId == courseId &&
        other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterDetailRef on StreamProviderRef<(ChapterDto, String?)?> {
  /// The parameter `courseId` of this provider.
  String get courseId;

  /// The parameter `chapterId` of this provider.
  String get chapterId;
}

class _ChapterDetailProviderElement
    extends StreamProviderElement<(ChapterDto, String?)?>
    with ChapterDetailRef {
  _ChapterDetailProviderElement(super.provider);

  @override
  String get courseId => (origin as ChapterDetailProvider).courseId;
  @override
  String get chapterId => (origin as ChapterDetailProvider).chapterId;
}

String _$chapterDetailControllerHash() =>
    r'0c348d1734fc955a747cae94ebff0e923486c836';

/// See also [ChapterDetailController].
@ProviderFor(ChapterDetailController)
final chapterDetailControllerProvider =
    AutoDisposeNotifierProvider<ChapterDetailController, bool>.internal(
  ChapterDetailController.new,
  name: r'chapterDetailControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chapterDetailControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChapterDetailController = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
