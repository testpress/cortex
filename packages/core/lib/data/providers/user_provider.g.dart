// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

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
String _$userHash() => r'4cdb4ee2cc5fed12ec6df3465a6a36b4db1212c0';

/// Reactive provider that exposes the current user's profile metadata from the database.
///
/// Copied from [user].
@ProviderFor(user)
final userProvider = AutoDisposeStreamProvider<UsersTableData?>.internal(
  user,
  name: r'userProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRef = AutoDisposeStreamProviderRef<UsersTableData?>;
String _$userActionsControllerHash() =>
    r'90f7705db4d8f6af4fea95f3a3a22c3af652f53b';

/// Controller used to trigger profile-related actions like updates.
///
/// Copied from [UserActionsController].
@ProviderFor(UserActionsController)
final userActionsControllerProvider =
    AutoDisposeNotifierProvider<UserActionsController, void>.internal(
      UserActionsController.new,
      name: r'userActionsControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userActionsControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserActionsController = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
