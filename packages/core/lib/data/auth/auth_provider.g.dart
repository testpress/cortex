// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userIdHash() => r'3eba5f054510dd368b6da24ced0813b0cc1317e9';

/// See also [userId].
@ProviderFor(userId)
final userIdProvider = StreamProvider<String?>.internal(
  userId,
  name: r'userIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserIdRef = StreamProviderRef<String?>;
String _$authHash() => r'e40e98d4feab4981f9a8db786cf63e8aec59c08c';

/// See also [Auth].
@ProviderFor(Auth)
final authProvider = AsyncNotifierProvider<Auth, bool>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = AsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
