// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$examRepositoryHash() => r'2c586dc51ef3f378caca0a83aaa3e71d26a9528a';

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
String _$examAttemptsHash() => r'42f952f3c74098dae420a492213a434c67697c05';

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

String _$examAttemptHash() => r'1cd9cbc38e418998d8a56c374df2852bc26d0dc1';

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
String _$examSyncMetadataHash() => r'fd00ee17ef2b17e986488a634e5b00d0d352b726';

/// See also [ExamSyncMetadata].
@ProviderFor(ExamSyncMetadata)
final examSyncMetadataProvider =
    NotifierProvider<ExamSyncMetadata, DateTime?>.internal(
      ExamSyncMetadata.new,
      name: r'examSyncMetadataProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$examSyncMetadataHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExamSyncMetadata = Notifier<DateTime?>;
String _$examListHash() => r'2cd7560739d0bfca4496265e50c11a22e2c148ac';

/// Notifier that manages the exam-specific course list and its independent sync state.
///
/// Copied from [ExamList].
@ProviderFor(ExamList)
final examListProvider =
    AutoDisposeStreamNotifierProvider<ExamList, List<CourseDto>>.internal(
      ExamList.new,
      name: r'examListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$examListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExamList = AutoDisposeStreamNotifier<List<CourseDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
