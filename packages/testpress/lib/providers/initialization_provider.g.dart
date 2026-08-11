// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initialization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appInitializationHash() => r'67e1624bf5450989b9523e5e6622d5a121a04613';

/// Provider that handles app-wide data initialization and refresh logic.
/// This prevents side effects within UI-driven data providers.
///
/// Copied from [appInitialization].
@ProviderFor(appInitialization)
final appInitializationProvider = FutureProvider<void>.internal(
  appInitialization,
  name: r'appInitializationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appInitializationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppInitializationRef = FutureProviderRef<void>;
String _$settingsInitializationHash() =>
    r'b3e2890299fd3b27b4383271e3ae9aeac33f4290';

/// See also [settingsInitialization].
@ProviderFor(settingsInitialization)
final settingsInitializationProvider = FutureProvider<void>.internal(
  settingsInitialization,
  name: r'settingsInitializationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsInitializationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsInitializationRef = FutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
