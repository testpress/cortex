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
String _$examAttemptsHash() => r'02cf0665e87034ed8a5e43e4a7104ddc85da2800';

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

/// Fetches attempt history for an exam.
///
/// Copied from [examAttempts].
@ProviderFor(examAttempts)
const examAttemptsProvider = ExamAttemptsFamily();

/// Fetches attempt history for an exam.
///
/// Copied from [examAttempts].
class ExamAttemptsFamily extends Family<AsyncValue<List<AttemptDto>>> {
  /// Fetches attempt history for an exam.
  ///
  /// Copied from [examAttempts].
  const ExamAttemptsFamily();

  /// Fetches attempt history for an exam.
  ///
  /// Copied from [examAttempts].
  ExamAttemptsProvider call(String attemptsUrl) {
    return ExamAttemptsProvider(attemptsUrl);
  }

  @override
  ExamAttemptsProvider getProviderOverride(
    covariant ExamAttemptsProvider provider,
  ) {
    return call(provider.attemptsUrl);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'examAttemptsProvider';
}

/// Fetches attempt history for an exam.
///
/// Copied from [examAttempts].
class ExamAttemptsProvider extends AutoDisposeFutureProvider<List<AttemptDto>> {
  /// Fetches attempt history for an exam.
  ///
  /// Copied from [examAttempts].
  ExamAttemptsProvider(String attemptsUrl)
    : this._internal(
        (ref) => examAttempts(ref as ExamAttemptsRef, attemptsUrl),
        from: examAttemptsProvider,
        name: r'examAttemptsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$examAttemptsHash,
        dependencies: ExamAttemptsFamily._dependencies,
        allTransitiveDependencies:
            ExamAttemptsFamily._allTransitiveDependencies,
        attemptsUrl: attemptsUrl,
      );

  ExamAttemptsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.attemptsUrl,
  }) : super.internal();

  final String attemptsUrl;

  @override
  Override overrideWith(
    FutureOr<List<AttemptDto>> Function(ExamAttemptsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExamAttemptsProvider._internal(
        (ref) => create(ref as ExamAttemptsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        attemptsUrl: attemptsUrl,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AttemptDto>> createElement() {
    return _ExamAttemptsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExamAttemptsProvider && other.attemptsUrl == attemptsUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, attemptsUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExamAttemptsRef on AutoDisposeFutureProviderRef<List<AttemptDto>> {
  /// The parameter `attemptsUrl` of this provider.
  String get attemptsUrl;
}

class _ExamAttemptsProviderElement
    extends AutoDisposeFutureProviderElement<List<AttemptDto>>
    with ExamAttemptsRef {
  _ExamAttemptsProviderElement(super.provider);

  @override
  String get attemptsUrl => (origin as ExamAttemptsProvider).attemptsUrl;
}

String _$examDetailHash() => r'8fa06e72cb0b5d9dfd87e416b3efabbe35ee1ffa';

abstract class _$ExamDetail extends BuildlessAsyncNotifier<ExamDto> {
  late final String slug;

  FutureOr<ExamDto> build(String slug);
}

/// Fetches exam details by slug with Stale-While-Revalidate (SWR) cache.
///
/// Copied from [ExamDetail].
@ProviderFor(ExamDetail)
const examDetailProvider = ExamDetailFamily();

/// Fetches exam details by slug with Stale-While-Revalidate (SWR) cache.
///
/// Copied from [ExamDetail].
class ExamDetailFamily extends Family<AsyncValue<ExamDto>> {
  /// Fetches exam details by slug with Stale-While-Revalidate (SWR) cache.
  ///
  /// Copied from [ExamDetail].
  const ExamDetailFamily();

  /// Fetches exam details by slug with Stale-While-Revalidate (SWR) cache.
  ///
  /// Copied from [ExamDetail].
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

/// Fetches exam details by slug with Stale-While-Revalidate (SWR) cache.
///
/// Copied from [ExamDetail].
class ExamDetailProvider
    extends AsyncNotifierProviderImpl<ExamDetail, ExamDto> {
  /// Fetches exam details by slug with Stale-While-Revalidate (SWR) cache.
  ///
  /// Copied from [ExamDetail].
  ExamDetailProvider(String slug)
    : this._internal(
        () => ExamDetail()..slug = slug,
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
  FutureOr<ExamDto> runNotifierBuild(covariant ExamDetail notifier) {
    return notifier.build(slug);
  }

  @override
  Override overrideWith(ExamDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExamDetailProvider._internal(
        () => create()..slug = slug,
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
  AsyncNotifierProviderElement<ExamDetail, ExamDto> createElement() {
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
mixin ExamDetailRef on AsyncNotifierProviderRef<ExamDto> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _ExamDetailProviderElement
    extends AsyncNotifierProviderElement<ExamDetail, ExamDto>
    with ExamDetailRef {
  _ExamDetailProviderElement(super.provider);

  @override
  String get slug => (origin as ExamDetailProvider).slug;
}

String _$examAttemptHash() => r'b3478bac8b427f40dc758c3cf7c73dcf085ceb6e';

/// Notifier that manages the active exam attempt lifecycle.
///
/// Copied from [ExamAttempt].
@ProviderFor(ExamAttempt)
final examAttemptProvider =
    AutoDisposeNotifierProvider<ExamAttempt, ExamAttemptState>.internal(
      ExamAttempt.new,
      name: r'examAttemptProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$examAttemptHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExamAttempt = AutoDisposeNotifier<ExamAttemptState>;
String _$examListHash() => r'1fcbb9ebe9053e236eaf5a63b62e568dce1a00bd';

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
