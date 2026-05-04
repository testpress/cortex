// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$learnersHash() => r'8a404337f6c8195a3af2fa4d91deecd77b10c82d';

/// See also [learners].
@ProviderFor(learners)
final learnersProvider = AutoDisposeStreamProvider<List<LearnerDto>>.internal(
  learners,
  name: r'learnersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$learnersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LearnersRef = AutoDisposeStreamProviderRef<List<LearnerDto>>;
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
