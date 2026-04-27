// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseForumThreadsHash() =>
    r'286cd08bed34a9ab60bde3a8e539e359b0815274';

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

/// See also [courseForumThreads].
@ProviderFor(courseForumThreads)
const courseForumThreadsProvider = CourseForumThreadsFamily();

/// See also [courseForumThreads].
class CourseForumThreadsFamily
    extends Family<AsyncValue<List<ForumThreadDto>>> {
  /// See also [courseForumThreads].
  const CourseForumThreadsFamily();

  /// See also [courseForumThreads].
  CourseForumThreadsProvider call(String courseId) {
    return CourseForumThreadsProvider(courseId);
  }

  @override
  CourseForumThreadsProvider getProviderOverride(
    covariant CourseForumThreadsProvider provider,
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
  String? get name => r'courseForumThreadsProvider';
}

/// See also [courseForumThreads].
class CourseForumThreadsProvider extends StreamProvider<List<ForumThreadDto>> {
  /// See also [courseForumThreads].
  CourseForumThreadsProvider(String courseId)
    : this._internal(
        (ref) => courseForumThreads(ref as CourseForumThreadsRef, courseId),
        from: courseForumThreadsProvider,
        name: r'courseForumThreadsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$courseForumThreadsHash,
        dependencies: CourseForumThreadsFamily._dependencies,
        allTransitiveDependencies:
            CourseForumThreadsFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  CourseForumThreadsProvider._internal(
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
    Stream<List<ForumThreadDto>> Function(CourseForumThreadsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CourseForumThreadsProvider._internal(
        (ref) => create(ref as CourseForumThreadsRef),
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
  StreamProviderElement<List<ForumThreadDto>> createElement() {
    return _CourseForumThreadsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseForumThreadsProvider && other.courseId == courseId;
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
mixin CourseForumThreadsRef on StreamProviderRef<List<ForumThreadDto>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseForumThreadsProviderElement
    extends StreamProviderElement<List<ForumThreadDto>>
    with CourseForumThreadsRef {
  _CourseForumThreadsProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseForumThreadsProvider).courseId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
