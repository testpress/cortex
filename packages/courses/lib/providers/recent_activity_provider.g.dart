// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_activity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentActivityHash() => r'dd30320375d550af00aa965be15aa01bb4a2fd26';

/// Provider for the most recently accessed lesson (for the Resume card).
///
/// Copied from [recentActivity].
@ProviderFor(recentActivity)
final recentActivityProvider =
    AutoDisposeStreamProvider<RecentActivityVo?>.internal(
      recentActivity,
      name: r'recentActivityProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentActivityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentActivityRef = AutoDisposeStreamProviderRef<RecentActivityVo?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
