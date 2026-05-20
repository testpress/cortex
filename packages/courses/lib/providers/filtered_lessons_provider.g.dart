// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_lessons_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredLessonsHash() => r'c454b8c9d3e0299dbd08c84223ee83da50ba81f2';

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

abstract class _$FilteredLessons
    extends BuildlessNotifier<FilteredLessonsState> {
  late final String courseId;
  late final String? chapterId;
  late final String? type;

  FilteredLessonsState build(
    String courseId, {
    String? chapterId,
    String? type,
  });
}

/// See also [FilteredLessons].
@ProviderFor(FilteredLessons)
const filteredLessonsProvider = FilteredLessonsFamily();

/// See also [FilteredLessons].
class FilteredLessonsFamily extends Family<FilteredLessonsState> {
  /// See also [FilteredLessons].
  const FilteredLessonsFamily();

  /// See also [FilteredLessons].
  FilteredLessonsProvider call(
    String courseId, {
    String? chapterId,
    String? type,
  }) {
    return FilteredLessonsProvider(
      courseId,
      chapterId: chapterId,
      type: type,
    );
  }

  @override
  FilteredLessonsProvider getProviderOverride(
    covariant FilteredLessonsProvider provider,
  ) {
    return call(
      provider.courseId,
      chapterId: provider.chapterId,
      type: provider.type,
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
  String? get name => r'filteredLessonsProvider';
}

/// See also [FilteredLessons].
class FilteredLessonsProvider
    extends NotifierProviderImpl<FilteredLessons, FilteredLessonsState> {
  /// See also [FilteredLessons].
  FilteredLessonsProvider(
    String courseId, {
    String? chapterId,
    String? type,
  }) : this._internal(
          () => FilteredLessons()
            ..courseId = courseId
            ..chapterId = chapterId
            ..type = type,
          from: filteredLessonsProvider,
          name: r'filteredLessonsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredLessonsHash,
          dependencies: FilteredLessonsFamily._dependencies,
          allTransitiveDependencies:
              FilteredLessonsFamily._allTransitiveDependencies,
          courseId: courseId,
          chapterId: chapterId,
          type: type,
        );

  FilteredLessonsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
    required this.chapterId,
    required this.type,
  }) : super.internal();

  final String courseId;
  final String? chapterId;
  final String? type;

  @override
  FilteredLessonsState runNotifierBuild(
    covariant FilteredLessons notifier,
  ) {
    return notifier.build(
      courseId,
      chapterId: chapterId,
      type: type,
    );
  }

  @override
  Override overrideWith(FilteredLessons Function() create) {
    return ProviderOverride(
      origin: this,
      override: FilteredLessonsProvider._internal(
        () => create()
          ..courseId = courseId
          ..chapterId = chapterId
          ..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
        chapterId: chapterId,
        type: type,
      ),
    );
  }

  @override
  NotifierProviderElement<FilteredLessons, FilteredLessonsState>
      createElement() {
    return _FilteredLessonsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredLessonsProvider &&
        other.courseId == courseId &&
        other.chapterId == chapterId &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredLessonsRef on NotifierProviderRef<FilteredLessonsState> {
  /// The parameter `courseId` of this provider.
  String get courseId;

  /// The parameter `chapterId` of this provider.
  String? get chapterId;

  /// The parameter `type` of this provider.
  String? get type;
}

class _FilteredLessonsProviderElement
    extends NotifierProviderElement<FilteredLessons, FilteredLessonsState>
    with FilteredLessonsRef {
  _FilteredLessonsProviderElement(super.provider);

  @override
  String get courseId => (origin as FilteredLessonsProvider).courseId;
  @override
  String? get chapterId => (origin as FilteredLessonsProvider).chapterId;
  @override
  String? get type => (origin as FilteredLessonsProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
