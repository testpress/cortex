// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileEnrollmentHash() => r'a60cd132485bf3a8841f292a07589d819860b009';

/// Provides enrolled courses directly from the DB layer to avoid depending on the `courses` package.
///
/// Copied from [profileEnrollment].
@ProviderFor(profileEnrollment)
final profileEnrollmentProvider =
    AutoDisposeStreamProvider<List<CourseDto>>.internal(
      profileEnrollment,
      name: r'profileEnrollmentProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileEnrollmentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileEnrollmentRef = AutoDisposeStreamProviderRef<List<CourseDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
