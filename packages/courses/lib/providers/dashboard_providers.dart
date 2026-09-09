import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:core/data/data.dart';
import '../courses.dart';
import '../data/mock_upcoming_tests.dart';

part 'dashboard_providers.g.dart';

@riverpod
Future<void> dashboardBootstrap(Ref ref) async {
  final repository = await ref.watch(dashboardRepositoryProvider.future);
  await repository.refreshDashboard();
}

@riverpod
Future<String> appVersion(Ref ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

@riverpod
Future<List<LiveClassDto>> todayClasses(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return mockTodayClasses;
}

@riverpod
Future<List<AssignmentDto>> pendingAssignments(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return mockAssignments
      .where((a) => a.status != AssignmentStatus.submitted)
      .toList();
}

@riverpod
Future<List<ScheduledTest>> upcomingTests(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return mockUpcomingTests;
}

@riverpod
Stream<List<DashboardBannerDto>> heroBanners(Ref ref) async* {
  final repository = await ref.watch(dashboardRepositoryProvider.future);
  yield* repository.watchHeroBanners();
}

@riverpod
Stream<List<LearnerDto>> learners(
  Ref ref, {
  LeaderboardTimeline timeline = LeaderboardTimeline.thisWeek,
  int? limit,
}) async* {
  final repository = await ref.watch(leaderboardRepositoryProvider.future);
  yield* repository.watchLeaderboard(timeline, limit: limit);
}

@riverpod
Future<List<QuickShortcutDto>> quickShortcuts(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 450));
  return mockQuickShortcuts;
}

@riverpod
Stream<List<DashboardContentDto>> whatsNewFeed(Ref ref) async* {
  final repository = await ref.watch(dashboardRepositoryProvider.future);
  yield* repository.watchWhatsNewFeed();
}

@riverpod
Stream<List<DashboardContentDto>> resumeLearningFeed(Ref ref) async* {
  final repository = await ref.watch(dashboardRepositoryProvider.future);
  yield* repository.watchResumeLearningFeed();
}

@riverpod
Stream<List<DashboardContentDto>> recentlyCompletedFeed(Ref ref) async* {
  final repository = await ref.watch(dashboardRepositoryProvider.future);
  yield* repository.watchRecentlyCompletedFeed();
}

@riverpod
bool hasCachedDashboard(Ref ref) {
  final whatsNew = ref.watch(whatsNewFeedProvider).valueOrNull ?? [];
  final resume = ref.watch(resumeLearningFeedProvider).valueOrNull ?? [];
  final completed = ref.watch(recentlyCompletedFeedProvider).valueOrNull ?? [];
  final banners = ref.watch(heroBannersProvider).valueOrNull ?? [];

  return whatsNew.isNotEmpty ||
      resume.isNotEmpty ||
      completed.isNotEmpty ||
      banners.isNotEmpty;
}

@riverpod
bool isDashboardInitialLoading(Ref ref) {
  final bootstrapState = ref.watch(dashboardBootstrapProvider);
  final hasCache = ref.watch(hasCachedDashboardProvider);
  return bootstrapState.isLoading && !hasCache;
}

final isHomeDrawerOpenProvider = StateProvider<bool>((ref) => false);
