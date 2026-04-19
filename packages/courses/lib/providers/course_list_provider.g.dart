// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseRepositoryHash() => r'62b30446b43101d61052e9c469030f2209080475';

/// See also [courseRepository].
@ProviderFor(courseRepository)
final courseRepositoryProvider = FutureProvider<CourseRepository>.internal(
  courseRepository,
  name: r'courseRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$courseRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CourseRepositoryRef = FutureProviderRef<CourseRepository>;
String _$courseChaptersHash() => r'18443e3a7d1dff852a979b3a2ffca20e46b26592';

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

/// Provider for a specific course's chapters.
///
/// Copied from [courseChapters].
@ProviderFor(courseChapters)
const courseChaptersProvider = CourseChaptersFamily();

/// Provider for a specific course's chapters.
///
/// Copied from [courseChapters].
class CourseChaptersFamily extends Family<AsyncValue<List<ChapterDto>>> {
  /// Provider for a specific course's chapters.
  ///
  /// Copied from [courseChapters].
  const CourseChaptersFamily();

  /// Provider for a specific course's chapters.
  ///
  /// Copied from [courseChapters].
  CourseChaptersProvider call(
    String courseId,
  ) {
    return CourseChaptersProvider(
      courseId,
    );
  }

  @override
  CourseChaptersProvider getProviderOverride(
    covariant CourseChaptersProvider provider,
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
  String? get name => r'courseChaptersProvider';
}

/// Provider for a specific course's chapters.
///
/// Copied from [courseChapters].
class CourseChaptersProvider extends StreamProvider<List<ChapterDto>> {
  /// Provider for a specific course's chapters.
  ///
  /// Copied from [courseChapters].
  CourseChaptersProvider(
    String courseId,
  ) : this._internal(
          (ref) => courseChapters(
            ref as CourseChaptersRef,
            courseId,
          ),
          from: courseChaptersProvider,
          name: r'courseChaptersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$courseChaptersHash,
          dependencies: CourseChaptersFamily._dependencies,
          allTransitiveDependencies:
              CourseChaptersFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  CourseChaptersProvider._internal(
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
    Stream<List<ChapterDto>> Function(CourseChaptersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CourseChaptersProvider._internal(
        (ref) => create(ref as CourseChaptersRef),
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
  StreamProviderElement<List<ChapterDto>> createElement() {
    return _CourseChaptersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseChaptersProvider && other.courseId == courseId;
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
mixin CourseChaptersRef on StreamProviderRef<List<ChapterDto>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseChaptersProviderElement
    extends StreamProviderElement<List<ChapterDto>> with CourseChaptersRef {
  _CourseChaptersProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseChaptersProvider).courseId;
}

String _$allChaptersHash() => r'6a346b9d21ffc0beffdff6921ae7774edb428ff5';

/// Provider for a specific course's chapters (all depths).
///
/// Copied from [allChapters].
@ProviderFor(allChapters)
const allChaptersProvider = AllChaptersFamily();

/// Provider for a specific course's chapters (all depths).
///
/// Copied from [allChapters].
class AllChaptersFamily extends Family<AsyncValue<List<ChapterDto>>> {
  /// Provider for a specific course's chapters (all depths).
  ///
  /// Copied from [allChapters].
  const AllChaptersFamily();

  /// Provider for a specific course's chapters (all depths).
  ///
  /// Copied from [allChapters].
  AllChaptersProvider call(
    String courseId,
  ) {
    return AllChaptersProvider(
      courseId,
    );
  }

  @override
  AllChaptersProvider getProviderOverride(
    covariant AllChaptersProvider provider,
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
  String? get name => r'allChaptersProvider';
}

/// Provider for a specific course's chapters (all depths).
///
/// Copied from [allChapters].
class AllChaptersProvider extends StreamProvider<List<ChapterDto>> {
  /// Provider for a specific course's chapters (all depths).
  ///
  /// Copied from [allChapters].
  AllChaptersProvider(
    String courseId,
  ) : this._internal(
          (ref) => allChapters(
            ref as AllChaptersRef,
            courseId,
          ),
          from: allChaptersProvider,
          name: r'allChaptersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allChaptersHash,
          dependencies: AllChaptersFamily._dependencies,
          allTransitiveDependencies:
              AllChaptersFamily._allTransitiveDependencies,
          courseId: courseId,
        );

  AllChaptersProvider._internal(
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
    Stream<List<ChapterDto>> Function(AllChaptersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllChaptersProvider._internal(
        (ref) => create(ref as AllChaptersRef),
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
  StreamProviderElement<List<ChapterDto>> createElement() {
    return _AllChaptersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllChaptersProvider && other.courseId == courseId;
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
mixin AllChaptersRef on StreamProviderRef<List<ChapterDto>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _AllChaptersProviderElement
    extends StreamProviderElement<List<ChapterDto>> with AllChaptersRef {
  _AllChaptersProviderElement(super.provider);

  @override
  String get courseId => (origin as AllChaptersProvider).courseId;
}

String _$chapterLessonsHash() => r'cf777f7871c4f857df0252b3a944df03938877bd';

/// Provider for a specific chapter's lessons.
///
/// Copied from [chapterLessons].
@ProviderFor(chapterLessons)
const chapterLessonsProvider = ChapterLessonsFamily();

/// Provider for a specific chapter's lessons.
///
/// Copied from [chapterLessons].
class ChapterLessonsFamily extends Family<AsyncValue<List<LessonDto>>> {
  /// Provider for a specific chapter's lessons.
  ///
  /// Copied from [chapterLessons].
  const ChapterLessonsFamily();

  /// Provider for a specific chapter's lessons.
  ///
  /// Copied from [chapterLessons].
  ChapterLessonsProvider call(
    String chapterId,
  ) {
    return ChapterLessonsProvider(
      chapterId,
    );
  }

  @override
  ChapterLessonsProvider getProviderOverride(
    covariant ChapterLessonsProvider provider,
  ) {
    return call(
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

/// Provider for a specific chapter's lessons.
///
/// Copied from [chapterLessons].
class ChapterLessonsProvider extends StreamProvider<List<LessonDto>> {
  /// Provider for a specific chapter's lessons.
  ///
  /// Copied from [chapterLessons].
  ChapterLessonsProvider(
    String chapterId,
  ) : this._internal(
          (ref) => chapterLessons(
            ref as ChapterLessonsRef,
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
          chapterId: chapterId,
        );

  ChapterLessonsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
  }) : super.internal();

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
    return other is ChapterLessonsProvider && other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterLessonsRef on StreamProviderRef<List<LessonDto>> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;
}

class _ChapterLessonsProviderElement
    extends StreamProviderElement<List<LessonDto>> with ChapterLessonsRef {
  _ChapterLessonsProviderElement(super.provider);

  @override
  String get chapterId => (origin as ChapterLessonsProvider).chapterId;
}

String _$courseListHash() => r'b86fbfec15af5dd98b0b841b88f6f462bc15fcf4';

/// See also [CourseList].
@ProviderFor(CourseList)
final courseListProvider =
    StreamNotifierProvider<CourseList, List<CourseDto>>.internal(
  CourseList.new,
  name: r'courseListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$courseListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CourseList = StreamNotifier<List<CourseDto>>;
String _$courseSearchHash() => r'770f25e1a505b2bf43f2399232dc309ea7ef55b7';

/// See also [CourseSearch].
@ProviderFor(CourseSearch)
final courseSearchProvider =
    NotifierProvider<CourseSearch, CourseSearchState>.internal(
  CourseSearch.new,
  name: r'courseSearchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$courseSearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CourseSearch = Notifier<CourseSearchState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
