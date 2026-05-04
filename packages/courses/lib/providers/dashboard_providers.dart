import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:core/data/data.dart';
import '../courses.dart';
import '../data/mock_upcoming_tests.dart';

part 'dashboard_providers.g.dart';

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
Future<List<DashboardBannerDto>> promotionBanners(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return mockPromotionBanners;
}

@riverpod
Stream<List<LearnerDto>> learners(Ref ref) async* {
  final repository = await ref.watch(dashboardRepositoryProvider.future);
  yield* repository.watchLearners();
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

final isHomeDrawerOpenProvider = StateProvider<bool>((ref) => false);
