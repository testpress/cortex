// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'dd0b45d11cae8f7ff468fbbc0d89d30eb9c8eb33';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider =
    AutoDisposeFutureProvider<UserRepository>.internal(
      userRepository,
      name: r'userRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = AutoDisposeFutureProviderRef<UserRepository>;
String _$profileRecentActivityHash() =>
    r'e70b9a9072f04f1b120c0a1eb7c80ee239b04cc8';

/// See also [profileRecentActivity].
@ProviderFor(profileRecentActivity)
final profileRecentActivityProvider =
    AutoDisposeFutureProvider<List<RecentActivityDto>>.internal(
      profileRecentActivity,
      name: r'profileRecentActivityProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileRecentActivityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRecentActivityRef =
    AutoDisposeFutureProviderRef<List<RecentActivityDto>>;
String _$profileEnrollmentHash() => r'00cb75b8678351229a31fa1ef477d50ea492b104';

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
