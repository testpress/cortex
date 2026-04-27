// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseForumThreadsHash() =>
    r'8eb3cf3d8bd35c7052a52c2afe532bd881d4655e';

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

String _$forumThreadDetailHash() => r'35a663ac2c423f4a02b845397f6ea8ccc4e6c055';

/// See also [forumThreadDetail].
@ProviderFor(forumThreadDetail)
const forumThreadDetailProvider = ForumThreadDetailFamily();

/// See also [forumThreadDetail].
class ForumThreadDetailFamily extends Family<AsyncValue<ForumThreadDto?>> {
  /// See also [forumThreadDetail].
  const ForumThreadDetailFamily();

  /// See also [forumThreadDetail].
  ForumThreadDetailProvider call({
    required String courseId,
    required String threadId,
  }) {
    return ForumThreadDetailProvider(courseId: courseId, threadId: threadId);
  }

  @override
  ForumThreadDetailProvider getProviderOverride(
    covariant ForumThreadDetailProvider provider,
  ) {
    return call(courseId: provider.courseId, threadId: provider.threadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'forumThreadDetailProvider';
}

/// See also [forumThreadDetail].
class ForumThreadDetailProvider extends StreamProvider<ForumThreadDto?> {
  /// See also [forumThreadDetail].
  ForumThreadDetailProvider({
    required String courseId,
    required String threadId,
  }) : this._internal(
         (ref) => forumThreadDetail(
           ref as ForumThreadDetailRef,
           courseId: courseId,
           threadId: threadId,
         ),
         from: forumThreadDetailProvider,
         name: r'forumThreadDetailProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$forumThreadDetailHash,
         dependencies: ForumThreadDetailFamily._dependencies,
         allTransitiveDependencies:
             ForumThreadDetailFamily._allTransitiveDependencies,
         courseId: courseId,
         threadId: threadId,
       );

  ForumThreadDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
    required this.threadId,
  }) : super.internal();

  final String courseId;
  final String threadId;

  @override
  Override overrideWith(
    Stream<ForumThreadDto?> Function(ForumThreadDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForumThreadDetailProvider._internal(
        (ref) => create(ref as ForumThreadDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
        threadId: threadId,
      ),
    );
  }

  @override
  StreamProviderElement<ForumThreadDto?> createElement() {
    return _ForumThreadDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForumThreadDetailProvider &&
        other.courseId == courseId &&
        other.threadId == threadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ForumThreadDetailRef on StreamProviderRef<ForumThreadDto?> {
  /// The parameter `courseId` of this provider.
  String get courseId;

  /// The parameter `threadId` of this provider.
  String get threadId;
}

class _ForumThreadDetailProviderElement
    extends StreamProviderElement<ForumThreadDto?>
    with ForumThreadDetailRef {
  _ForumThreadDetailProviderElement(super.provider);

  @override
  String get courseId => (origin as ForumThreadDetailProvider).courseId;
  @override
  String get threadId => (origin as ForumThreadDetailProvider).threadId;
}

String _$threadCommentsHash() => r'a118b04e5f7c9bd558208e18564d882b623f6de8';

/// See also [threadComments].
@ProviderFor(threadComments)
const threadCommentsProvider = ThreadCommentsFamily();

/// See also [threadComments].
class ThreadCommentsFamily extends Family<AsyncValue<List<ForumCommentDto>>> {
  /// See also [threadComments].
  const ThreadCommentsFamily();

  /// See also [threadComments].
  ThreadCommentsProvider call(String threadId) {
    return ThreadCommentsProvider(threadId);
  }

  @override
  ThreadCommentsProvider getProviderOverride(
    covariant ThreadCommentsProvider provider,
  ) {
    return call(provider.threadId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'threadCommentsProvider';
}

/// See also [threadComments].
class ThreadCommentsProvider extends StreamProvider<List<ForumCommentDto>> {
  /// See also [threadComments].
  ThreadCommentsProvider(String threadId)
    : this._internal(
        (ref) => threadComments(ref as ThreadCommentsRef, threadId),
        from: threadCommentsProvider,
        name: r'threadCommentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$threadCommentsHash,
        dependencies: ThreadCommentsFamily._dependencies,
        allTransitiveDependencies:
            ThreadCommentsFamily._allTransitiveDependencies,
        threadId: threadId,
      );

  ThreadCommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadId,
  }) : super.internal();

  final String threadId;

  @override
  Override overrideWith(
    Stream<List<ForumCommentDto>> Function(ThreadCommentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ThreadCommentsProvider._internal(
        (ref) => create(ref as ThreadCommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threadId: threadId,
      ),
    );
  }

  @override
  StreamProviderElement<List<ForumCommentDto>> createElement() {
    return _ThreadCommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThreadCommentsProvider && other.threadId == threadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ThreadCommentsRef on StreamProviderRef<List<ForumCommentDto>> {
  /// The parameter `threadId` of this provider.
  String get threadId;
}

class _ThreadCommentsProviderElement
    extends StreamProviderElement<List<ForumCommentDto>>
    with ThreadCommentsRef {
  _ThreadCommentsProviderElement(super.provider);

  @override
  String get threadId => (origin as ThreadCommentsProvider).threadId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
