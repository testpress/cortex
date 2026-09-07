// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qotd_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$qotdHash() => r'02a3a1bd810b7d90af0c804c39f669f173d63d2d';

/// Provider to fetch the Question of the Day list from the repository.
///
/// Copied from [qotd].
@ProviderFor(qotd)
final qotdProvider = AutoDisposeFutureProvider<List<QotdDto>>.internal(
  qotd,
  name: r'qotdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$qotdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QotdRef = AutoDisposeFutureProviderRef<List<QotdDto>>;
String _$qotdSummaryHash() => r'4891529ceac3c6a34814e146374913bf6994e19c';

/// Provider to fetch overall QOTD statistics/summary.
///
/// Copied from [qotdSummary].
@ProviderFor(qotdSummary)
final qotdSummaryProvider = AutoDisposeFutureProvider<QotdSummaryDto>.internal(
  qotdSummary,
  name: r'qotdSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$qotdSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QotdSummaryRef = AutoDisposeFutureProviderRef<QotdSummaryDto>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
