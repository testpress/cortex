// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$downloadsRepositoryHash() =>
    r'6d2716016dcd788e9a8e9051553b32405417b0ff';

/// See also [downloadsRepository].
@ProviderFor(downloadsRepository)
final downloadsRepositoryProvider =
    FutureProvider<DownloadsRepository>.internal(
      downloadsRepository,
      name: r'downloadsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$downloadsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DownloadsRepositoryRef = FutureProviderRef<DownloadsRepository>;
String _$watchDownloadItemHash() => r'2634e2dbb5935b7593a24a3253d63bd2000fd9e0';

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

/// See also [watchDownloadItem].
@ProviderFor(watchDownloadItem)
const watchDownloadItemProvider = WatchDownloadItemFamily();

/// See also [watchDownloadItem].
class WatchDownloadItemFamily extends Family<AsyncValue<DownloadItem?>> {
  /// See also [watchDownloadItem].
  const WatchDownloadItemFamily();

  /// See also [watchDownloadItem].
  WatchDownloadItemProvider call(String id) {
    return WatchDownloadItemProvider(id);
  }

  @override
  WatchDownloadItemProvider getProviderOverride(
    covariant WatchDownloadItemProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'watchDownloadItemProvider';
}

/// See also [watchDownloadItem].
class WatchDownloadItemProvider
    extends AutoDisposeStreamProvider<DownloadItem?> {
  /// See also [watchDownloadItem].
  WatchDownloadItemProvider(String id)
    : this._internal(
        (ref) => watchDownloadItem(ref as WatchDownloadItemRef, id),
        from: watchDownloadItemProvider,
        name: r'watchDownloadItemProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$watchDownloadItemHash,
        dependencies: WatchDownloadItemFamily._dependencies,
        allTransitiveDependencies:
            WatchDownloadItemFamily._allTransitiveDependencies,
        id: id,
      );

  WatchDownloadItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<DownloadItem?> Function(WatchDownloadItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchDownloadItemProvider._internal(
        (ref) => create(ref as WatchDownloadItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<DownloadItem?> createElement() {
    return _WatchDownloadItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchDownloadItemProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WatchDownloadItemRef on AutoDisposeStreamProviderRef<DownloadItem?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _WatchDownloadItemProviderElement
    extends AutoDisposeStreamProviderElement<DownloadItem?>
    with WatchDownloadItemRef {
  _WatchDownloadItemProviderElement(super.provider);

  @override
  String get id => (origin as WatchDownloadItemProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
