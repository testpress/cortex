import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:data/data.dart';
import '../models/course.dart';
import '../models/recent_activity_dto.dart';
import '../data/mock_data.dart';
import '../data/mock_courses.dart';

part 'dashboard_providers.g.dart';

@riverpod
Future<String> appVersion(Ref ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

@riverpod
Future<List<LiveClassDto>> todayClasses(Ref ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 500));
  return mockTodayClasses;
}

@riverpod
Future<List<AssignmentDto>> pendingAssignments(Ref ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 600));
  return mockAssignments
      .where((a) => a.status != AssignmentStatus.submitted)
      .toList();
}

@riverpod
Future<List<TestDto>> upcomingTests(Ref ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 700));
  return mockTests;
}

@riverpod
Future<StudyMomentumDto> studyMomentum(Ref ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 800));
  return mockStudyMomentum;
}

@riverpod
Future<UserDto> currentUser(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return mockCurrentUser;
}

@riverpod
Future<List<DashboardBannerDto>> heroBanners(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return mockHeroBanners;
}

@riverpod
Future<List<DashboardBannerDto>> promotionBanners(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return mockPromotionBanners;
}

@riverpod
Future<List<LearnerDto>> topLearners(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return mockTopLearners;
}

@riverpod
Future<List<LearnerDto>> otherLearners(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 650));
  return mockOtherLearners;
}

@riverpod
Future<List<QuickShortcutDto>> quickShortcuts(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 450));
  return mockQuickShortcuts;
}

@riverpod
Future<StudyMomentumDto> currentUserStats(Ref ref) async {
  return ref.watch(studyMomentumProvider.future);
}

@riverpod
Future<List<CourseDto>> enrolledCourses(Ref ref) async {
  return ref.watch(enrollmentProvider.future);
}

@riverpod
Future<LearnerDto> currentUserLearnerProfile(Ref ref) async {
  return mockOtherLearners.firstWhere((l) => l.name == 'You');
}

@riverpod
Future<List<RecentActivityDto>> recentActivity(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return mockRecentActivity;
}

final isHomeDrawerOpenProvider = StateProvider<bool>((ref) => false);
final designModeProvider = StateProvider<DesignMode>(
  (ref) => DesignMode.system,
);
