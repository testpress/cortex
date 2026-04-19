// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdk_initialization.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sdkInitializationHash() => r'b02fb25029732b0d1989a2d6c3714502781c4c76';

/// Provider that handles the initialization of 3rd party SDKs (like TPStreams).
/// This is centralized in core so all domain packages benefit.
///
/// Copied from [sdkInitialization].
@ProviderFor(sdkInitialization)
final sdkInitializationProvider = AutoDisposeFutureProvider<void>.internal(
  sdkInitialization,
  name: r'sdkInitializationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sdkInitializationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SdkInitializationRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
