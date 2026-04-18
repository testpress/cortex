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
  CourseDetailProvider call(String courseId) {
    return CourseDetailProvider(courseId);
  }

  @override
  CourseDetailProvider getProviderOverride(
    covariant CourseDetailProvider provider,
  ) {
    return call(provider.courseId);
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
  CourseDetailProvider(String courseId)
    : this._internal(
        (ref) => courseDetail(ref as CourseDetailRef, courseId),
        from: courseDetailProvider,
        name: r'courseDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
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

String _$subChaptersHash() => r'1fcdcc0a0935bddab8fe5718da9c3b93da24f2d1';

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
  SubChaptersProvider call(String courseId, String? parentId) {
    return SubChaptersProvider(courseId, parentId);
  }

  @override
  SubChaptersProvider getProviderOverride(
    covariant SubChaptersProvider provider,
  ) {
    return call(provider.courseId, provider.parentId);
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
class SubChaptersProvider extends AutoDisposeStreamProvider<List<ChapterDto>> {
  /// A provider that watches chapters for a specific parent (folder).
  /// Triggers a refresh if the folder has not been synced yet.
  ///
  /// Copied from [subChapters].
  SubChaptersProvider(String courseId, String? parentId)
    : this._internal(
        (ref) => subChapters(ref as SubChaptersRef, courseId, parentId),
        from: subChaptersProvider,
        name: r'subChaptersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$subChaptersHash,
        dependencies: SubChaptersFamily._dependencies,
        allTransitiveDependencies: SubChaptersFamily._allTransitiveDependencies,
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
  AutoDisposeStreamProviderElement<List<ChapterDto>> createElement() {
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
mixin SubChaptersRef on AutoDisposeStreamProviderRef<List<ChapterDto>> {
  /// The parameter `courseId` of this provider.
  String get courseId;

  /// The parameter `parentId` of this provider.
  String? get parentId;
}

class _SubChaptersProviderElement
    extends AutoDisposeStreamProviderElement<List<ChapterDto>>
    with SubChaptersRef {
  _SubChaptersProviderElement(super.provider);

  @override
  String get courseId => (origin as SubChaptersProvider).courseId;
  @override
  String? get parentId => (origin as SubChaptersProvider).parentId;
}

String _$allCourseLessonsHash() => r'3746368636296b244a8128a159dfa96f3fa69684';

/// A provider that flattens all lessons for a specific course into a single list.
/// Used for filtering lessons by type across the entire course.
///
/// Copied from [allCourseLessons].
@ProviderFor(allCourseLessons)
const allCourseLessonsProvider = AllCourseLessonsFamily();

/// A provider that flattens all lessons for a specific course into a single list.
/// Used for filtering lessons by type across the entire course.
///
/// Copied from [allCourseLessons].
class AllCourseLessonsFamily extends Family<AsyncValue<List<LessonDto>>> {
  /// A provider that flattens all lessons for a specific course into a single list.
  /// Used for filtering lessons by type across the entire course.
  ///
  /// Copied from [allCourseLessons].
  const AllCourseLessonsFamily();

  /// A provider that flattens all lessons for a specific course into a single list.
  /// Used for filtering lessons by type across the entire course.
  ///
  /// Copied from [allCourseLessons].
  AllCourseLessonsProvider call(String courseId) {
    return AllCourseLessonsProvider(courseId);
  }

  @override
  AllCourseLessonsProvider getProviderOverride(
    covariant AllCourseLessonsProvider provider,
  ) {
    return call(provider.courseId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allCourseLessonsProvider';
}

/// A provider that flattens all lessons for a specific course into a single list.
/// Used for filtering lessons by type across the entire course.
///
/// Copied from [allCourseLessons].
class AllCourseLessonsProvider
    extends AutoDisposeFutureProvider<List<LessonDto>> {
  /// A provider that flattens all lessons for a specific course into a single list.
  /// Used for filtering lessons by type across the entire course.
  ///
  /// Copied from [allCourseLessons].
  AllCourseLessonsProvider(String courseId)
    : this._internal(
        (ref) => allCourseLessons(ref as AllCourseLessonsRef, courseId),
        from: allCourseLessonsProvider,
        name: r'allCourseLessonsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$allCourseLessonsHash,
        dependencies: AllCourseLessonsFamily._dependencies,
        allTransitiveDependencies:
            AllCourseLessonsFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  AllCourseLessonsProvider._internal(
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
    FutureOr<List<LessonDto>> Function(AllCourseLessonsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllCourseLessonsProvider._internal(
        (ref) => create(ref as AllCourseLessonsRef),
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
  AutoDisposeFutureProviderElement<List<LessonDto>> createElement() {
    return _AllCourseLessonsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllCourseLessonsProvider && other.courseId == courseId;
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
mixin AllCourseLessonsRef on AutoDisposeFutureProviderRef<List<LessonDto>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _AllCourseLessonsProviderElement
    extends AutoDisposeFutureProviderElement<List<LessonDto>>
    with AllCourseLessonsRef {
  _AllCourseLessonsProviderElement(super.provider);

  @override
  String get courseId => (origin as AllCourseLessonsProvider).courseId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
