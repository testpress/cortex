// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$enrollmentHash() => r'693ae1fcbe2ffe3fda36c1e380b223095a327abd';

/// Provider for the list of courses the user is currently enrolled in.
///
/// Copied from [enrollment].
@ProviderFor(enrollment)
final enrollmentProvider = AutoDisposeStreamProvider<List<CourseDto>>.internal(
  enrollment,
  name: r'enrollmentProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$enrollmentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EnrollmentRef = AutoDisposeStreamProviderRef<List<CourseDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
