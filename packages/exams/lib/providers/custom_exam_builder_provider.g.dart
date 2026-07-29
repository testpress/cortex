// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_exam_builder_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customExamBuilderHash() => r'e29ced3b61c8ce88546da62a886d694fe2def609';

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

abstract class _$CustomExamBuilder
    extends BuildlessAutoDisposeNotifier<CustomExamBuilderState> {
  late final String courseId;

  CustomExamBuilderState build(String courseId);
}

/// See also [CustomExamBuilder].
@ProviderFor(CustomExamBuilder)
const customExamBuilderProvider = CustomExamBuilderFamily();

/// See also [CustomExamBuilder].
class CustomExamBuilderFamily extends Family<CustomExamBuilderState> {
  /// See also [CustomExamBuilder].
  const CustomExamBuilderFamily();

  /// See also [CustomExamBuilder].
  CustomExamBuilderProvider call(String courseId) {
    return CustomExamBuilderProvider(courseId);
  }

  @override
  CustomExamBuilderProvider getProviderOverride(
    covariant CustomExamBuilderProvider provider,
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
  String? get name => r'customExamBuilderProvider';
}

/// See also [CustomExamBuilder].
class CustomExamBuilderProvider
    extends
        AutoDisposeNotifierProviderImpl<
          CustomExamBuilder,
          CustomExamBuilderState
        > {
  /// See also [CustomExamBuilder].
  CustomExamBuilderProvider(String courseId)
    : this._internal(
        () => CustomExamBuilder()..courseId = courseId,
        from: customExamBuilderProvider,
        name: r'customExamBuilderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$customExamBuilderHash,
        dependencies: CustomExamBuilderFamily._dependencies,
        allTransitiveDependencies:
            CustomExamBuilderFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  CustomExamBuilderProvider._internal(
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
  CustomExamBuilderState runNotifierBuild(
    covariant CustomExamBuilder notifier,
  ) {
    return notifier.build(courseId);
  }

  @override
  Override overrideWith(CustomExamBuilder Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomExamBuilderProvider._internal(
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
  AutoDisposeNotifierProviderElement<CustomExamBuilder, CustomExamBuilderState>
  createElement() {
    return _CustomExamBuilderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomExamBuilderProvider && other.courseId == courseId;
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
mixin CustomExamBuilderRef
    on AutoDisposeNotifierProviderRef<CustomExamBuilderState> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CustomExamBuilderProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          CustomExamBuilder,
          CustomExamBuilderState
        >
    with CustomExamBuilderRef {
  _CustomExamBuilderProviderElement(super.provider);

  @override
  String get courseId => (origin as CustomExamBuilderProvider).courseId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
