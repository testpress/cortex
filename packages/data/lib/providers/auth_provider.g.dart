// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authHash() => r'2fdc7c1db09b22d2f0a106253163c859b8322ce8';

/// Provider for the currently authenticated user.
/// In a real app, this would be managed by an AuthService/SessionManager.
///
/// Copied from [Auth].
@ProviderFor(Auth)
final authProvider = NotifierProvider<Auth, UserDto>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = Notifier<UserDto>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
