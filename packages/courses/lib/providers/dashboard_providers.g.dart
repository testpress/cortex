// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardBootstrapHash() =>
    r'02cd49e31a0858a811708b359dff8a6c68291928';

/// See also [dashboardBootstrap].
@ProviderFor(dashboardBootstrap)
final dashboardBootstrapProvider = AutoDisposeFutureProvider<void>.internal(
  dashboardBootstrap,
  name: r'dashboardBootstrapProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardBootstrapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardBootstrapRef = AutoDisposeFutureProviderRef<void>;
String _$appVersionHash() => r'e8bdf0eb01e50b65eb7931eadc45c32b561fce64';

/// See also [appVersion].
@ProviderFor(appVersion)
final appVersionProvider = AutoDisposeFutureProvider<String>.internal(
  appVersion,
  name: r'appVersionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appVersionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppVersionRef = AutoDisposeFutureProviderRef<String>;
String _$todayClassesHash() => r'2b7ed9170d498415e7295bc96e4937024efecb78';

/// See also [todayClasses].
@ProviderFor(todayClasses)
final todayClassesProvider =
    AutoDisposeFutureProvider<List<LiveClassDto>>.internal(
  todayClasses,
  name: r'todayClassesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayClassesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayClassesRef = AutoDisposeFutureProviderRef<List<LiveClassDto>>;
String _$pendingAssignmentsHash() =>
    r'f103562af86f598095782b3cebedc100d1ace694';

/// See also [pendingAssignments].
@ProviderFor(pendingAssignments)
final pendingAssignmentsProvider =
    AutoDisposeFutureProvider<List<AssignmentDto>>.internal(
  pendingAssignments,
  name: r'pendingAssignmentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingAssignmentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingAssignmentsRef
    = AutoDisposeFutureProviderRef<List<AssignmentDto>>;
String _$upcomingTestsHash() => r'8f7727e7bc108c68a4613fd37d4b294afe246f60';

/// See also [upcomingTests].
@ProviderFor(upcomingTests)
final upcomingTestsProvider =
    AutoDisposeFutureProvider<List<ScheduledTest>>.internal(
  upcomingTests,
  name: r'upcomingTestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingTestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingTestsRef = AutoDisposeFutureProviderRef<List<ScheduledTest>>;
String _$heroBannersHash() => r'a7e08b451e2c20c612423baae41b548201c434ec';

/// See also [heroBanners].
@ProviderFor(heroBanners)
final heroBannersProvider =
    AutoDisposeStreamProvider<List<DashboardBannerDto>>.internal(
  heroBanners,
  name: r'heroBannersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$heroBannersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HeroBannersRef = AutoDisposeStreamProviderRef<List<DashboardBannerDto>>;
String _$promotionBannersHash() => r'3099fb8dbd8de6979ab08ba1ec0abf007dac0c66';

/// See also [promotionBanners].
@ProviderFor(promotionBanners)
final promotionBannersProvider =
    AutoDisposeFutureProvider<List<DashboardBannerDto>>.internal(
  promotionBanners,
  name: r'promotionBannersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$promotionBannersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PromotionBannersRef
    = AutoDisposeFutureProviderRef<List<DashboardBannerDto>>;
String _$learnersHash() => r'b9222aef15875e6bc5f67b0c8da9e1f8995f7b16';

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

/// See also [learners].
@ProviderFor(learners)
const learnersProvider = LearnersFamily();

/// See also [learners].
class LearnersFamily extends Family<AsyncValue<List<LearnerDto>>> {
  /// See also [learners].
  const LearnersFamily();

  /// See also [learners].
  LearnersProvider call({
    LeaderboardTimeline timeline = LeaderboardTimeline.thisWeek,
    int? limit,
  }) {
    return LearnersProvider(
      timeline: timeline,
      limit: limit,
    );
  }

  @override
  LearnersProvider getProviderOverride(
    covariant LearnersProvider provider,
  ) {
    return call(
      timeline: provider.timeline,
      limit: provider.limit,
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
  String? get name => r'learnersProvider';
}

/// See also [learners].
class LearnersProvider extends AutoDisposeStreamProvider<List<LearnerDto>> {
  /// See also [learners].
  LearnersProvider({
    LeaderboardTimeline timeline = LeaderboardTimeline.thisWeek,
    int? limit,
  }) : this._internal(
          (ref) => learners(
            ref as LearnersRef,
            timeline: timeline,
            limit: limit,
          ),
          from: learnersProvider,
          name: r'learnersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$learnersHash,
          dependencies: LearnersFamily._dependencies,
          allTransitiveDependencies: LearnersFamily._allTransitiveDependencies,
          timeline: timeline,
          limit: limit,
        );

  LearnersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.timeline,
    required this.limit,
  }) : super.internal();

  final LeaderboardTimeline timeline;
  final int? limit;

  @override
  Override overrideWith(
    Stream<List<LearnerDto>> Function(LearnersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LearnersProvider._internal(
        (ref) => create(ref as LearnersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        timeline: timeline,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<LearnerDto>> createElement() {
    return _LearnersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LearnersProvider &&
        other.timeline == timeline &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, timeline.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LearnersRef on AutoDisposeStreamProviderRef<List<LearnerDto>> {
  /// The parameter `timeline` of this provider.
  LeaderboardTimeline get timeline;

  /// The parameter `limit` of this provider.
  int? get limit;
}

class _LearnersProviderElement
    extends AutoDisposeStreamProviderElement<List<LearnerDto>>
    with LearnersRef {
  _LearnersProviderElement(super.provider);

  @override
  LeaderboardTimeline get timeline => (origin as LearnersProvider).timeline;
  @override
  int? get limit => (origin as LearnersProvider).limit;
}

String _$quickShortcutsHash() => r'ba6b6c2b269ef7d8f60a4f782a9e8fbb1b2d24a6';

/// See also [quickShortcuts].
@ProviderFor(quickShortcuts)
final quickShortcutsProvider =
    AutoDisposeFutureProvider<List<QuickShortcutDto>>.internal(
  quickShortcuts,
  name: r'quickShortcutsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quickShortcutsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuickShortcutsRef
    = AutoDisposeFutureProviderRef<List<QuickShortcutDto>>;
String _$whatsNewFeedHash() => r'fa7da6a2eb5e51808e1244fbd391eec46195c20c';

/// See also [whatsNewFeed].
@ProviderFor(whatsNewFeed)
final whatsNewFeedProvider =
    AutoDisposeStreamProvider<List<DashboardContentDto>>.internal(
  whatsNewFeed,
  name: r'whatsNewFeedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$whatsNewFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WhatsNewFeedRef
    = AutoDisposeStreamProviderRef<List<DashboardContentDto>>;
String _$resumeLearningFeedHash() =>
    r'8c9c9bde804ba459c64381422388a1f9519fce0e';

/// See also [resumeLearningFeed].
@ProviderFor(resumeLearningFeed)
final resumeLearningFeedProvider =
    AutoDisposeStreamProvider<List<DashboardContentDto>>.internal(
  resumeLearningFeed,
  name: r'resumeLearningFeedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resumeLearningFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResumeLearningFeedRef
    = AutoDisposeStreamProviderRef<List<DashboardContentDto>>;
String _$recentlyCompletedFeedHash() =>
    r'2bab52aaec17f480b8582ea82864c054ac934c09';

/// See also [recentlyCompletedFeed].
@ProviderFor(recentlyCompletedFeed)
final recentlyCompletedFeedProvider =
    AutoDisposeStreamProvider<List<DashboardContentDto>>.internal(
  recentlyCompletedFeed,
  name: r'recentlyCompletedFeedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentlyCompletedFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentlyCompletedFeedRef
    = AutoDisposeStreamProviderRef<List<DashboardContentDto>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
