// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learnlens_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$learnLensNetworkClientHash() =>
    r'4b64098957ad78508b934b69fe9c2c143ea6736c';

/// Provider for the singleton [LearnLensNetworkClient] instance.
///
/// Copied from [learnLensNetworkClient].
@ProviderFor(learnLensNetworkClient)
final learnLensNetworkClientProvider =
    AutoDisposeProvider<LearnLensNetworkClient>.internal(
  learnLensNetworkClient,
  name: r'learnLensNetworkClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$learnLensNetworkClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LearnLensNetworkClientRef
    = AutoDisposeProviderRef<LearnLensNetworkClient>;
String _$learnLensRepositoryHash() =>
    r'9a60f3811621aa27f55124e1676bc71f4e76314b';

/// Provider for the singleton [LearnLensRepository] instance.
///
/// Copied from [learnLensRepository].
@ProviderFor(learnLensRepository)
final learnLensRepositoryProvider =
    AutoDisposeProvider<LearnLensRepository>.internal(
  learnLensRepository,
  name: r'learnLensRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$learnLensRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LearnLensRepositoryRef = AutoDisposeProviderRef<LearnLensRepository>;
String _$learnlensSessionHash() => r'02dd6e9eb1ad4d0de37778f48ed43693dac845a2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$LearnlensSession
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>?> {
  late final int contentId;

  FutureOr<Map<String, dynamic>?> build(
    int contentId,
  );
}

/// See also [LearnlensSession].
@ProviderFor(LearnlensSession)
const learnlensSessionProvider = LearnlensSessionFamily();

/// See also [LearnlensSession].
class LearnlensSessionFamily extends Family<AsyncValue<Map<String, dynamic>?>> {
  /// See also [LearnlensSession].
  const LearnlensSessionFamily();

  /// See also [LearnlensSession].
  LearnlensSessionProvider call(
    int contentId,
  ) {
    return LearnlensSessionProvider(
      contentId,
    );
  }

  @override
  LearnlensSessionProvider getProviderOverride(
    covariant LearnlensSessionProvider provider,
  ) {
    return call(
      provider.contentId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'learnlensSessionProvider';
}

/// See also [LearnlensSession].
class LearnlensSessionProvider extends AutoDisposeAsyncNotifierProviderImpl<
    LearnlensSession, Map<String, dynamic>?> {
  /// See also [LearnlensSession].
  LearnlensSessionProvider(
    int contentId,
  ) : this._internal(
          () => LearnlensSession()..contentId = contentId,
          from: learnlensSessionProvider,
          name: r'learnlensSessionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$learnlensSessionHash,
          dependencies: LearnlensSessionFamily._dependencies,
          allTransitiveDependencies:
              LearnlensSessionFamily._allTransitiveDependencies,
          contentId: contentId,
        );

  LearnlensSessionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contentId,
  }) : super.internal();

  final int contentId;

  @override
  FutureOr<Map<String, dynamic>?> runNotifierBuild(
    covariant LearnlensSession notifier,
  ) {
    return notifier.build(
      contentId,
    );
  }

  @override
  Override overrideWith(LearnlensSession Function() create) {
    return ProviderOverride(
      origin: this,
      override: LearnlensSessionProvider._internal(
        () => create()..contentId = contentId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contentId: contentId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<LearnlensSession,
      Map<String, dynamic>?> createElement() {
    return _LearnlensSessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LearnlensSessionProvider && other.contentId == contentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LearnlensSessionRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>?> {
  /// The parameter `contentId` of this provider.
  int get contentId;
}

class _LearnlensSessionProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LearnlensSession,
        Map<String, dynamic>?> with LearnlensSessionRef {
  _LearnlensSessionProviderElement(super.provider);

  @override
  int get contentId => (origin as LearnlensSessionProvider).contentId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
