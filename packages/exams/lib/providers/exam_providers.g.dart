// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$examRepositoryHash() => r'52332a2f1aac0aeb79b5fe89412ea09c4f399b6f';

/// Repository provider for exam-specific operations.
///
/// Copied from [examRepository].
@ProviderFor(examRepository)
final examRepositoryProvider = Provider<ExamRepository>.internal(
  examRepository,
  name: r'examRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$examRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExamRepositoryRef = ProviderRef<ExamRepository>;
String _$examDetailHash() => r'b399234225881306c8bc66191e7e3494fd840c9b';

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

/// Fetches exam details by slug.
///
/// Copied from [examDetail].
@ProviderFor(examDetail)
const examDetailProvider = ExamDetailFamily();

/// Fetches exam details by slug.
///
/// Copied from [examDetail].
class ExamDetailFamily extends Family<AsyncValue<ExamDto>> {
  /// Fetches exam details by slug.
  ///
  /// Copied from [examDetail].
  const ExamDetailFamily();

  /// Fetches exam details by slug.
  ///
  /// Copied from [examDetail].
  ExamDetailProvider call(String slug) {
    return ExamDetailProvider(slug);
  }

  @override
  ExamDetailProvider getProviderOverride(
    covariant ExamDetailProvider provider,
  ) {
    return call(provider.slug);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'examDetailProvider';
}

/// Fetches exam details by slug.
///
/// Copied from [examDetail].
class ExamDetailProvider extends AutoDisposeFutureProvider<ExamDto> {
  /// Fetches exam details by slug.
  ///
  /// Copied from [examDetail].
  ExamDetailProvider(String slug)
    : this._internal(
        (ref) => examDetail(ref as ExamDetailRef, slug),
        from: examDetailProvider,
        name: r'examDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$examDetailHash,
        dependencies: ExamDetailFamily._dependencies,
        allTransitiveDependencies: ExamDetailFamily._allTransitiveDependencies,
        slug: slug,
      );

  ExamDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  Override overrideWith(
    FutureOr<ExamDto> Function(ExamDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExamDetailProvider._internal(
        (ref) => create(ref as ExamDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ExamDto> createElement() {
    return _ExamDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExamDetailProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExamDetailRef on AutoDisposeFutureProviderRef<ExamDto> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _ExamDetailProviderElement
    extends AutoDisposeFutureProviderElement<ExamDto>
    with ExamDetailRef {
  _ExamDetailProviderElement(super.provider);

  @override
  String get slug => (origin as ExamDetailProvider).slug;
}

String _$examAttemptHash() => r'b3d17c40eea31ad8e3560ba9da0a18049fffe0c1';

/// Notifier that manages the active exam attempt lifecycle.
///
/// Copied from [ExamAttempt].
@ProviderFor(ExamAttempt)
final examAttemptProvider =
    AutoDisposeStreamNotifierProvider<ExamAttempt, ExamAttemptState>.internal(
      ExamAttempt.new,
      name: r'examAttemptProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$examAttemptHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExamAttempt = AutoDisposeStreamNotifier<ExamAttemptState>;
String _$examListHash() => r'a73c7f8e327fd62dec2e9ab3a277b8cbf10a14c9';

/// Notifier that manages the exam-specific course list and its independent sync state.
///
/// Copied from [ExamList].
@ProviderFor(ExamList)
final examListProvider =
    StreamNotifierProvider<ExamList, List<CourseDto>>.internal(
      ExamList.new,
      name: r'examListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$examListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExamList = StreamNotifier<List<CourseDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
