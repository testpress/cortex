// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseDetailHash() => r'3ac000bde610ea984625c81f3916fba09b2acb25';

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

/// Provider that fetches a specific course with its full curriculum (chapters and lessons).
///
/// Copied from [courseDetail].
@ProviderFor(courseDetail)
const courseDetailProvider = CourseDetailFamily();

/// Provider that fetches a specific course with its full curriculum (chapters and lessons).
///
/// Copied from [courseDetail].
class CourseDetailFamily extends Family<AsyncValue<CourseDto?>> {
  /// Provider that fetches a specific course with its full curriculum (chapters and lessons).
  ///
  /// Copied from [courseDetail].
  const CourseDetailFamily();

  /// Provider that fetches a specific course with its full curriculum (chapters and lessons).
  ///
  /// Copied from [courseDetail].
  CourseDetailProvider call(
    String courseId,
  ) {
    return CourseDetailProvider(
      courseId,
    );
  }

  @override
  CourseDetailProvider getProviderOverride(
    covariant CourseDetailProvider provider,
  ) {
    return call(
      provider.courseId,
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
  String? get name => r'courseDetailProvider';
}

/// Provider that fetches a specific course with its full curriculum (chapters and lessons).
///
/// Copied from [courseDetail].
class CourseDetailProvider extends StreamProvider<CourseDto?> {
  /// Provider that fetches a specific course with its full curriculum (chapters and lessons).
  ///
  /// Copied from [courseDetail].
  CourseDetailProvider(
    String courseId,
  ) : this._internal(
          (ref) => courseDetail(
            ref as CourseDetailRef,
            courseId,
          ),
          from: courseDetailProvider,
          name: r'courseDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$courseDetailHash,
          dependencies: CourseDetailFamily._dependencies,
          allTransitiveDependencies:
              CourseDetailFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  CourseDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
  }) : super.internal();

  final String courseId;

  @override
  Override overrideWith(
    Stream<CourseDto?> Function(CourseDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CourseDetailProvider._internal(
        (ref) => create(ref as CourseDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
      ),
    );
  }

  @override
  StreamProviderElement<CourseDto?> createElement() {
    return _CourseDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseDetailProvider && other.courseId == courseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CourseDetailRef on StreamProviderRef<CourseDto?> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseDetailProviderElement extends StreamProviderElement<CourseDto?>
    with CourseDetailRef {
  _CourseDetailProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseDetailProvider).courseId;
}

String _$subChaptersHash() => r'7c34d8e7024a31ff3fa102e331d82ad99cc6031a';

/// A provider that watches chapters for a specific parent (folder).
/// Triggers a refresh if the folder has not been synced yet.
///
/// Copied from [subChapters].
@ProviderFor(subChapters)
const subChaptersProvider = SubChaptersFamily();

/// A provider that watches chapters for a specific parent (folder).
/// Triggers a refresh if the folder has not been synced yet.
///
/// Copied from [subChapters].
class SubChaptersFamily extends Family<AsyncValue<List<ChapterDto>>> {
  /// A provider that watches chapters for a specific parent (folder).
  /// Triggers a refresh if the folder has not been synced yet.
  ///
  /// Copied from [subChapters].
  const SubChaptersFamily();

  /// A provider that watches chapters for a specific parent (folder).
  /// Triggers a refresh if the folder has not been synced yet.
  ///
  /// Copied from [subChapters].
  SubChaptersProvider call(
    String courseId,
    String? parentId,
  ) {
    return SubChaptersProvider(
      courseId,
      parentId,
    );
  }

  @override
  SubChaptersProvider getProviderOverride(
    covariant SubChaptersProvider provider,
  ) {
    return call(
      provider.courseId,
      provider.parentId,
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
  String? get name => r'subChaptersProvider';
}

/// A provider that watches chapters for a specific parent (folder).
/// Triggers a refresh if the folder has not been synced yet.
///
/// Copied from [subChapters].
class SubChaptersProvider extends StreamProvider<List<ChapterDto>> {
  /// A provider that watches chapters for a specific parent (folder).
  /// Triggers a refresh if the folder has not been synced yet.
  ///
  /// Copied from [subChapters].
  SubChaptersProvider(
    String courseId,
    String? parentId,
  ) : this._internal(
          (ref) => subChapters(
            ref as SubChaptersRef,
            courseId,
            parentId,
          ),
          from: subChaptersProvider,
          name: r'subChaptersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$subChaptersHash,
          dependencies: SubChaptersFamily._dependencies,
          allTransitiveDependencies:
              SubChaptersFamily._allTransitiveDependencies,
          courseId: courseId,
          parentId: parentId,
        );

  SubChaptersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
    required this.parentId,
  }) : super.internal();

  final String courseId;
  final String? parentId;

  @override
  Override overrideWith(
    Stream<List<ChapterDto>> Function(SubChaptersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SubChaptersProvider._internal(
        (ref) => create(ref as SubChaptersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
        parentId: parentId,
      ),
    );
  }

  @override
  StreamProviderElement<List<ChapterDto>> createElement() {
    return _SubChaptersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SubChaptersProvider &&
        other.courseId == courseId &&
        other.parentId == parentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);
    hash = _SystemHash.combine(hash, parentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SubChaptersRef on StreamProviderRef<List<ChapterDto>> {
  /// The parameter `courseId` of this provider.
  String get courseId;

  /// The parameter `parentId` of this provider.
  String? get parentId;
}

class _SubChaptersProviderElement
    extends StreamProviderElement<List<ChapterDto>> with SubChaptersRef {
  _SubChaptersProviderElement(super.provider);

  @override
  String get courseId => (origin as SubChaptersProvider).courseId;
  @override
  String? get parentId => (origin as SubChaptersProvider).parentId;
}

String _$chapterLessonsHash() => r'9e5732ff9d1eb0f5200bdaffe50bebfed25bd4f1';

/// See also [chapterLessons].
@ProviderFor(chapterLessons)
const chapterLessonsProvider = ChapterLessonsFamily();

/// See also [chapterLessons].
class ChapterLessonsFamily extends Family<AsyncValue<List<LessonDto>>> {
  /// See also [chapterLessons].
  const ChapterLessonsFamily();

  /// See also [chapterLessons].
  ChapterLessonsProvider call(
    String courseId,
    String chapterId,
  ) {
    return ChapterLessonsProvider(
      courseId,
      chapterId,
    );
  }

  @override
  ChapterLessonsProvider getProviderOverride(
    covariant ChapterLessonsProvider provider,
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
  String? get name => r'chapterLessonsProvider';
}

/// See also [chapterLessons].
class ChapterLessonsProvider extends StreamProvider<List<LessonDto>> {
  /// See also [chapterLessons].
  ChapterLessonsProvider(
    String courseId,
    String chapterId,
  ) : this._internal(
          (ref) => chapterLessons(
            ref as ChapterLessonsRef,
            courseId,
            chapterId,
          ),
          from: chapterLessonsProvider,
          name: r'chapterLessonsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterLessonsHash,
          dependencies: ChapterLessonsFamily._dependencies,
          allTransitiveDependencies:
              ChapterLessonsFamily._allTransitiveDependencies,
          courseId: courseId,
          chapterId: chapterId,
        );

  ChapterLessonsProvider._internal(
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
    Stream<List<LessonDto>> Function(ChapterLessonsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterLessonsProvider._internal(
        (ref) => create(ref as ChapterLessonsRef),
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
  StreamProviderElement<List<LessonDto>> createElement() {
    return _ChapterLessonsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterLessonsProvider &&
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
mixin ChapterLessonsRef on StreamProviderRef<List<LessonDto>> {
  /// The parameter `courseId` of this provider.
  String get courseId;

  /// The parameter `chapterId` of this provider.
  String get chapterId;
}

class _ChapterLessonsProviderElement
    extends StreamProviderElement<List<LessonDto>> with ChapterLessonsRef {
  _ChapterLessonsProviderElement(super.provider);

  @override
  String get courseId => (origin as ChapterLessonsProvider).courseId;
  @override
  String get chapterId => (origin as ChapterLessonsProvider).chapterId;
}

String _$courseSyncStatusHash() => r'4d2341bacc55705011f56b5cd001365dcbb262fb';

/// Provider that tracks if a specific course is currently undergoing a structural sync.
///
/// Copied from [courseSyncStatus].
@ProviderFor(courseSyncStatus)
const courseSyncStatusProvider = CourseSyncStatusFamily();

/// Provider that tracks if a specific course is currently undergoing a structural sync.
///
/// Copied from [courseSyncStatus].
class CourseSyncStatusFamily extends Family<AsyncValue<bool>> {
  /// Provider that tracks if a specific course is currently undergoing a structural sync.
  ///
  /// Copied from [courseSyncStatus].
  const CourseSyncStatusFamily();

  /// Provider that tracks if a specific course is currently undergoing a structural sync.
  ///
  /// Copied from [courseSyncStatus].
  CourseSyncStatusProvider call(
    String courseId,
  ) {
    return CourseSyncStatusProvider(
      courseId,
    );
  }

  @override
  CourseSyncStatusProvider getProviderOverride(
    covariant CourseSyncStatusProvider provider,
  ) {
    return call(
      provider.courseId,
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
  String? get name => r'courseSyncStatusProvider';
}

/// Provider that tracks if a specific course is currently undergoing a structural sync.
///
/// Copied from [courseSyncStatus].
class CourseSyncStatusProvider extends StreamProvider<bool> {
  /// Provider that tracks if a specific course is currently undergoing a structural sync.
  ///
  /// Copied from [courseSyncStatus].
  CourseSyncStatusProvider(
    String courseId,
  ) : this._internal(
          (ref) => courseSyncStatus(
            ref as CourseSyncStatusRef,
            courseId,
          ),
          from: courseSyncStatusProvider,
          name: r'courseSyncStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$courseSyncStatusHash,
          dependencies: CourseSyncStatusFamily._dependencies,
          allTransitiveDependencies:
              CourseSyncStatusFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  CourseSyncStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
  }) : super.internal();

  final String courseId;

  @override
  Override overrideWith(
    Stream<bool> Function(CourseSyncStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CourseSyncStatusProvider._internal(
        (ref) => create(ref as CourseSyncStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
      ),
    );
  }

  @override
  StreamProviderElement<bool> createElement() {
    return _CourseSyncStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseSyncStatusProvider && other.courseId == courseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CourseSyncStatusRef on StreamProviderRef<bool> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseSyncStatusProviderElement extends StreamProviderElement<bool>
    with CourseSyncStatusRef {
  _CourseSyncStatusProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseSyncStatusProvider).courseId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
