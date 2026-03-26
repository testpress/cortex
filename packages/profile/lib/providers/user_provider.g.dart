// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userHash() => r'bb6951f483be1b4a94b5488905ddf3d83a7a73e6';

/// Reactive provider that exposes the current user's profile metadata from the database.
/// Automatically triggers a background refresh from the network whenever it's watched.
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
    r'd13e232a5b1ed0d9e549f75bf621a6339d831916';

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
