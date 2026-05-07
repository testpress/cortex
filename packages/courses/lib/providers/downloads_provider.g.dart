// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$downloadsHash() => r'd38fcb42ffa6e6da9c11c266b5ae05b6cd738306';

/// See also [downloads].
@ProviderFor(downloads)
final downloadsProvider =
    AutoDisposeStreamProvider<List<DownloadItem>>.internal(
  downloads,
  name: r'downloadsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$downloadsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DownloadsRef = AutoDisposeStreamProviderRef<List<DownloadItem>>;
String _$downloadsBootstrapHash() =>
    r'd7c62526a846b5413475a0704d4e837a7c8c7788';

/// Triggers a background sync on every screen visit.
/// Auto-dispose ensures it re-runs each time the screen subscribes.
///
/// Copied from [downloadsBootstrap].
@ProviderFor(downloadsBootstrap)
final downloadsBootstrapProvider = AutoDisposeFutureProvider<void>.internal(
  downloadsBootstrap,
  name: r'downloadsBootstrapProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$downloadsBootstrapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DownloadsBootstrapRef = AutoDisposeFutureProviderRef<void>;
String _$pauseDownloadHash() => r'b42b7a8e51d74a6d9c25db75cf30ec3e293a2496';

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

/// See also [pauseDownload].
@ProviderFor(pauseDownload)
const pauseDownloadProvider = PauseDownloadFamily();

/// See also [pauseDownload].
class PauseDownloadFamily extends Family<AsyncValue<void>> {
  /// See also [pauseDownload].
  const PauseDownloadFamily();

  /// See also [pauseDownload].
  PauseDownloadProvider call(
    String id,
  ) {
    return PauseDownloadProvider(
      id,
    );
  }

  @override
  PauseDownloadProvider getProviderOverride(
    covariant PauseDownloadProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'pauseDownloadProvider';
}

/// See also [pauseDownload].
class PauseDownloadProvider extends AutoDisposeFutureProvider<void> {
  /// See also [pauseDownload].
  PauseDownloadProvider(
    String id,
  ) : this._internal(
          (ref) => pauseDownload(
            ref as PauseDownloadRef,
            id,
          ),
          from: pauseDownloadProvider,
          name: r'pauseDownloadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pauseDownloadHash,
          dependencies: PauseDownloadFamily._dependencies,
          allTransitiveDependencies:
              PauseDownloadFamily._allTransitiveDependencies,
          id: id,
        );

  PauseDownloadProvider._internal(
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
    FutureOr<void> Function(PauseDownloadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PauseDownloadProvider._internal(
        (ref) => create(ref as PauseDownloadRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _PauseDownloadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PauseDownloadProvider && other.id == id;
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
mixin PauseDownloadRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PauseDownloadProviderElement
    extends AutoDisposeFutureProviderElement<void> with PauseDownloadRef {
  _PauseDownloadProviderElement(super.provider);

  @override
  String get id => (origin as PauseDownloadProvider).id;
}

String _$resumeDownloadHash() => r'0581770841aa7d876e063b171e66c4ee8b0766ee';

/// See also [resumeDownload].
@ProviderFor(resumeDownload)
const resumeDownloadProvider = ResumeDownloadFamily();

/// See also [resumeDownload].
class ResumeDownloadFamily extends Family<AsyncValue<void>> {
  /// See also [resumeDownload].
  const ResumeDownloadFamily();

  /// See also [resumeDownload].
  ResumeDownloadProvider call(
    String id,
  ) {
    return ResumeDownloadProvider(
      id,
    );
  }

  @override
  ResumeDownloadProvider getProviderOverride(
    covariant ResumeDownloadProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'resumeDownloadProvider';
}

/// See also [resumeDownload].
class ResumeDownloadProvider extends AutoDisposeFutureProvider<void> {
  /// See also [resumeDownload].
  ResumeDownloadProvider(
    String id,
  ) : this._internal(
          (ref) => resumeDownload(
            ref as ResumeDownloadRef,
            id,
          ),
          from: resumeDownloadProvider,
          name: r'resumeDownloadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$resumeDownloadHash,
          dependencies: ResumeDownloadFamily._dependencies,
          allTransitiveDependencies:
              ResumeDownloadFamily._allTransitiveDependencies,
          id: id,
        );

  ResumeDownloadProvider._internal(
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
    FutureOr<void> Function(ResumeDownloadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ResumeDownloadProvider._internal(
        (ref) => create(ref as ResumeDownloadRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ResumeDownloadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ResumeDownloadProvider && other.id == id;
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
mixin ResumeDownloadRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ResumeDownloadProviderElement
    extends AutoDisposeFutureProviderElement<void> with ResumeDownloadRef {
  _ResumeDownloadProviderElement(super.provider);

  @override
  String get id => (origin as ResumeDownloadProvider).id;
}

String _$deleteDownloadHash() => r'9bcf6ce5ae4e269c2382d09118732022874aca3d';

/// See also [deleteDownload].
@ProviderFor(deleteDownload)
const deleteDownloadProvider = DeleteDownloadFamily();

/// See also [deleteDownload].
class DeleteDownloadFamily extends Family<AsyncValue<void>> {
  /// See also [deleteDownload].
  const DeleteDownloadFamily();

  /// See also [deleteDownload].
  DeleteDownloadProvider call(
    String id,
  ) {
    return DeleteDownloadProvider(
      id,
    );
  }

  @override
  DeleteDownloadProvider getProviderOverride(
    covariant DeleteDownloadProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'deleteDownloadProvider';
}

/// See also [deleteDownload].
class DeleteDownloadProvider extends AutoDisposeFutureProvider<void> {
  /// See also [deleteDownload].
  DeleteDownloadProvider(
    String id,
  ) : this._internal(
          (ref) => deleteDownload(
            ref as DeleteDownloadRef,
            id,
          ),
          from: deleteDownloadProvider,
          name: r'deleteDownloadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteDownloadHash,
          dependencies: DeleteDownloadFamily._dependencies,
          allTransitiveDependencies:
              DeleteDownloadFamily._allTransitiveDependencies,
          id: id,
        );

  DeleteDownloadProvider._internal(
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
    FutureOr<void> Function(DeleteDownloadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteDownloadProvider._internal(
        (ref) => create(ref as DeleteDownloadRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteDownloadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteDownloadProvider && other.id == id;
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
mixin DeleteDownloadRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `id` of this provider.
  String get id;
}

class _DeleteDownloadProviderElement
    extends AutoDisposeFutureProviderElement<void> with DeleteDownloadRef {
  _DeleteDownloadProviderElement(super.provider);

  @override
  String get id => (origin as DeleteDownloadProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
