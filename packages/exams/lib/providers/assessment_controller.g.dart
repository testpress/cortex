// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assessmentControllerHash() =>
    r'58c5d4175b303800a73a166f097d560a1ddb35a7';

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

abstract class _$AssessmentController
    extends BuildlessAutoDisposeNotifier<AssessmentState> {
  late final AssessmentParam param;

  AssessmentState build(AssessmentParam param);
}

/// Controller managing business logic, state mutations, and network interactions for assessments.
///
/// Copied from [AssessmentController].
@ProviderFor(AssessmentController)
const assessmentControllerProvider = AssessmentControllerFamily();

/// Controller managing business logic, state mutations, and network interactions for assessments.
///
/// Copied from [AssessmentController].
class AssessmentControllerFamily extends Family<AssessmentState> {
  /// Controller managing business logic, state mutations, and network interactions for assessments.
  ///
  /// Copied from [AssessmentController].
  const AssessmentControllerFamily();

  /// Controller managing business logic, state mutations, and network interactions for assessments.
  ///
  /// Copied from [AssessmentController].
  AssessmentControllerProvider call(AssessmentParam param) {
    return AssessmentControllerProvider(param);
  }

  @override
  AssessmentControllerProvider getProviderOverride(
    covariant AssessmentControllerProvider provider,
  ) {
    return call(provider.param);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assessmentControllerProvider';
}

/// Controller managing business logic, state mutations, and network interactions for assessments.
///
/// Copied from [AssessmentController].
class AssessmentControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<AssessmentController, AssessmentState> {
  /// Controller managing business logic, state mutations, and network interactions for assessments.
  ///
  /// Copied from [AssessmentController].
  AssessmentControllerProvider(AssessmentParam param)
    : this._internal(
        () => AssessmentController()..param = param,
        from: assessmentControllerProvider,
        name: r'assessmentControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assessmentControllerHash,
        dependencies: AssessmentControllerFamily._dependencies,
        allTransitiveDependencies:
            AssessmentControllerFamily._allTransitiveDependencies,
        param: param,
      );

  AssessmentControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.param,
  }) : super.internal();

  final AssessmentParam param;

  @override
  AssessmentState runNotifierBuild(covariant AssessmentController notifier) {
    return notifier.build(param);
  }

  @override
  Override overrideWith(AssessmentController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AssessmentControllerProvider._internal(
        () => create()..param = param,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        param: param,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AssessmentController, AssessmentState>
  createElement() {
    return _AssessmentControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssessmentControllerProvider && other.param == param;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, param.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssessmentControllerRef
    on AutoDisposeNotifierProviderRef<AssessmentState> {
  /// The parameter `param` of this provider.
  AssessmentParam get param;
}

class _AssessmentControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          AssessmentController,
          AssessmentState
        >
    with AssessmentControllerRef {
  _AssessmentControllerProviderElement(super.provider);

  @override
  AssessmentParam get param => (origin as AssessmentControllerProvider).param;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
