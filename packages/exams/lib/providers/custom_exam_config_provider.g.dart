// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_exam_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customExamConfigHash() => r'd6ca9ce2182f98e809116ddc1c8a0d733bbaf423';

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

abstract class _$CustomExamConfig
    extends BuildlessAutoDisposeAsyncNotifier<CustomTestConfigDto> {
  late final String courseId;

  FutureOr<CustomTestConfigDto> build(String courseId);
}

/// Fetches the configuration (subjects, difficulties, question types, limits)
/// for the custom exam builder. Cached per-course by Riverpod.
///
/// Copied from [CustomExamConfig].
@ProviderFor(CustomExamConfig)
const customExamConfigProvider = CustomExamConfigFamily();

/// Fetches the configuration (subjects, difficulties, question types, limits)
/// for the custom exam builder. Cached per-course by Riverpod.
///
/// Copied from [CustomExamConfig].
class CustomExamConfigFamily extends Family<AsyncValue<CustomTestConfigDto>> {
  /// Fetches the configuration (subjects, difficulties, question types, limits)
  /// for the custom exam builder. Cached per-course by Riverpod.
  ///
  /// Copied from [CustomExamConfig].
  const CustomExamConfigFamily();

  /// Fetches the configuration (subjects, difficulties, question types, limits)
  /// for the custom exam builder. Cached per-course by Riverpod.
  ///
  /// Copied from [CustomExamConfig].
  CustomExamConfigProvider call(String courseId) {
    return CustomExamConfigProvider(courseId);
  }

  @override
  CustomExamConfigProvider getProviderOverride(
    covariant CustomExamConfigProvider provider,
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
  String? get name => r'customExamConfigProvider';
}

/// Fetches the configuration (subjects, difficulties, question types, limits)
/// for the custom exam builder. Cached per-course by Riverpod.
///
/// Copied from [CustomExamConfig].
class CustomExamConfigProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          CustomExamConfig,
          CustomTestConfigDto
        > {
  /// Fetches the configuration (subjects, difficulties, question types, limits)
  /// for the custom exam builder. Cached per-course by Riverpod.
  ///
  /// Copied from [CustomExamConfig].
  CustomExamConfigProvider(String courseId)
    : this._internal(
        () => CustomExamConfig()..courseId = courseId,
        from: customExamConfigProvider,
        name: r'customExamConfigProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$customExamConfigHash,
        dependencies: CustomExamConfigFamily._dependencies,
        allTransitiveDependencies:
            CustomExamConfigFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  CustomExamConfigProvider._internal(
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
  FutureOr<CustomTestConfigDto> runNotifierBuild(
    covariant CustomExamConfig notifier,
  ) {
    return notifier.build(courseId);
  }

  @override
  Override overrideWith(CustomExamConfig Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomExamConfigProvider._internal(
        () => create()..courseId = courseId,
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
  AutoDisposeAsyncNotifierProviderElement<CustomExamConfig, CustomTestConfigDto>
  createElement() {
    return _CustomExamConfigProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomExamConfigProvider && other.courseId == courseId;
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
mixin CustomExamConfigRef
    on AutoDisposeAsyncNotifierProviderRef<CustomTestConfigDto> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CustomExamConfigProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CustomExamConfig,
          CustomTestConfigDto
        >
    with CustomExamConfigRef {
  _CustomExamConfigProviderElement(super.provider);

  @override
  String get courseId => (origin as CustomExamConfigProvider).courseId;
}

String _$generateCustomExamHash() =>
    r'0526d6ae2fcee39b2164d00d5c7561dc8bd28a27';

/// Manages the API call to generate a custom exam from the built blocks.
///
/// Copied from [GenerateCustomExam].
@ProviderFor(GenerateCustomExam)
final generateCustomExamProvider =
    AutoDisposeAsyncNotifierProvider<GenerateCustomExam, AttemptDto?>.internal(
      GenerateCustomExam.new,
      name: r'generateCustomExamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$generateCustomExamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GenerateCustomExam = AutoDisposeAsyncNotifier<AttemptDto?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
