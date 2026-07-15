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
String _$authHash() => r'a317284be4fab87ed698a81f4ff3c0a6a70b8a97';

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
