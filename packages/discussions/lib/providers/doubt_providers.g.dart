// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doubt_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$doubtRepositoryHash() => r'864cd8b3965d7aacb98a202a48fc79c9b77cceb9';

/// See also [doubtRepository].
@ProviderFor(doubtRepository)
final doubtRepositoryProvider = Provider<DoubtRepository>.internal(
  doubtRepository,
  name: r'doubtRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$doubtRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DoubtRepositoryRef = ProviderRef<DoubtRepository>;
String _$doubtsListHash() => r'7ce81d9eef7762fe93f55ec2c558e60c64d33174';

/// See also [doubtsList].
@ProviderFor(doubtsList)
final doubtsListProvider = AutoDisposeStreamProvider<List<DoubtDto>>.internal(
  doubtsList,
  name: r'doubtsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$doubtsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DoubtsListRef = AutoDisposeStreamProviderRef<List<DoubtDto>>;
String _$doubtSearchHash() => r'bb52cc4e4d4152e00308e29bec16de2cc92f7513';

/// See also [DoubtSearch].
@ProviderFor(DoubtSearch)
final doubtSearchProvider =
    AutoDisposeNotifierProvider<DoubtSearch, String>.internal(
      DoubtSearch.new,
      name: r'doubtSearchProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$doubtSearchHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DoubtSearch = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
