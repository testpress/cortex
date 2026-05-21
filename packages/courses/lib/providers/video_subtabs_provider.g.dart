// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_subtabs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoSubtabsRepositoryHash() =>
    r'6bbe4c1556ecb1ac7747d2c87dad8df18361e749';

/// Provider for the singleton [VideoSubtabsRepository] instance.
///
/// Copied from [videoSubtabsRepository].
@ProviderFor(videoSubtabsRepository)
final videoSubtabsRepositoryProvider =
    AutoDisposeProvider<VideoSubtabsRepository>.internal(
  videoSubtabsRepository,
  name: r'videoSubtabsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$videoSubtabsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VideoSubtabsRepositoryRef
    = AutoDisposeProviderRef<VideoSubtabsRepository>;
String _$fetchNotesMarkdownHash() =>
    r'd47729e10c6bf9626ae961a00b31b109b3f2e0a2';

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

/// Provider that fetches markdown notes from the given [url].
///
/// Copied from [fetchNotesMarkdown].
@ProviderFor(fetchNotesMarkdown)
const fetchNotesMarkdownProvider = FetchNotesMarkdownFamily();

/// Provider that fetches markdown notes from the given [url].
///
/// Copied from [fetchNotesMarkdown].
class FetchNotesMarkdownFamily extends Family<AsyncValue<String>> {
  /// Provider that fetches markdown notes from the given [url].
  ///
  /// Copied from [fetchNotesMarkdown].
  const FetchNotesMarkdownFamily();

  /// Provider that fetches markdown notes from the given [url].
  ///
  /// Copied from [fetchNotesMarkdown].
  FetchNotesMarkdownProvider call(
    String url,
  ) {
    return FetchNotesMarkdownProvider(
      url,
    );
  }

  @override
  FetchNotesMarkdownProvider getProviderOverride(
    covariant FetchNotesMarkdownProvider provider,
  ) {
    return call(
      provider.url,
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
  String? get name => r'fetchNotesMarkdownProvider';
}

/// Provider that fetches markdown notes from the given [url].
///
/// Copied from [fetchNotesMarkdown].
class FetchNotesMarkdownProvider extends AutoDisposeFutureProvider<String> {
  /// Provider that fetches markdown notes from the given [url].
  ///
  /// Copied from [fetchNotesMarkdown].
  FetchNotesMarkdownProvider(
    String url,
  ) : this._internal(
          (ref) => fetchNotesMarkdown(
            ref as FetchNotesMarkdownRef,
            url,
          ),
          from: fetchNotesMarkdownProvider,
          name: r'fetchNotesMarkdownProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchNotesMarkdownHash,
          dependencies: FetchNotesMarkdownFamily._dependencies,
          allTransitiveDependencies:
              FetchNotesMarkdownFamily._allTransitiveDependencies,
          url: url,
        );

  FetchNotesMarkdownProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Override overrideWith(
    FutureOr<String> Function(FetchNotesMarkdownRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchNotesMarkdownProvider._internal(
        (ref) => create(ref as FetchNotesMarkdownRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _FetchNotesMarkdownProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchNotesMarkdownProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchNotesMarkdownRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `url` of this provider.
  String get url;
}

class _FetchNotesMarkdownProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with FetchNotesMarkdownRef {
  _FetchNotesMarkdownProviderElement(super.provider);

  @override
  String get url => (origin as FetchNotesMarkdownProvider).url;
}

String _$fetchTranscriptHash() => r'6a803bf8e42948bbd021ddcb16d27f541731e704';

/// Provider that fetches and parses the transcript VTT cues from the given [url].
///
/// Copied from [fetchTranscript].
@ProviderFor(fetchTranscript)
const fetchTranscriptProvider = FetchTranscriptFamily();

/// Provider that fetches and parses the transcript VTT cues from the given [url].
///
/// Copied from [fetchTranscript].
class FetchTranscriptFamily extends Family<AsyncValue<List<VttCue>>> {
  /// Provider that fetches and parses the transcript VTT cues from the given [url].
  ///
  /// Copied from [fetchTranscript].
  const FetchTranscriptFamily();

  /// Provider that fetches and parses the transcript VTT cues from the given [url].
  ///
  /// Copied from [fetchTranscript].
  FetchTranscriptProvider call(
    String url,
  ) {
    return FetchTranscriptProvider(
      url,
    );
  }

  @override
  FetchTranscriptProvider getProviderOverride(
    covariant FetchTranscriptProvider provider,
  ) {
    return call(
      provider.url,
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
  String? get name => r'fetchTranscriptProvider';
}

/// Provider that fetches and parses the transcript VTT cues from the given [url].
///
/// Copied from [fetchTranscript].
class FetchTranscriptProvider extends AutoDisposeFutureProvider<List<VttCue>> {
  /// Provider that fetches and parses the transcript VTT cues from the given [url].
  ///
  /// Copied from [fetchTranscript].
  FetchTranscriptProvider(
    String url,
  ) : this._internal(
          (ref) => fetchTranscript(
            ref as FetchTranscriptRef,
            url,
          ),
          from: fetchTranscriptProvider,
          name: r'fetchTranscriptProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchTranscriptHash,
          dependencies: FetchTranscriptFamily._dependencies,
          allTransitiveDependencies:
              FetchTranscriptFamily._allTransitiveDependencies,
          url: url,
        );

  FetchTranscriptProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Override overrideWith(
    FutureOr<List<VttCue>> Function(FetchTranscriptRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchTranscriptProvider._internal(
        (ref) => create(ref as FetchTranscriptRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<VttCue>> createElement() {
    return _FetchTranscriptProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchTranscriptProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchTranscriptRef on AutoDisposeFutureProviderRef<List<VttCue>> {
  /// The parameter `url` of this provider.
  String get url;
}

class _FetchTranscriptProviderElement
    extends AutoDisposeFutureProviderElement<List<VttCue>>
    with FetchTranscriptRef {
  _FetchTranscriptProviderElement(super.provider);

  @override
  String get url => (origin as FetchTranscriptProvider).url;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
