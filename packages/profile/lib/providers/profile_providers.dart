import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../repositories/user_repository.dart';
import '../data/profile_mock_data.dart';
import '../models/recent_activity_dto.dart';

part 'profile_providers.g.dart';

@riverpod
Future<UserRepository> userRepository(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final source = ref.watch(dataSourceProvider);
  return UserRepository(db, source);
}

@riverpod
Future<List<RecentActivityDto>> profileRecentActivity(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return mockRecentActivity;
}

/// Provides enrolled courses directly from the DB layer to avoid depending on the `courses` package.
@riverpod
Stream<List<CourseDto>> profileEnrollment(Ref ref) async* {
  final db = await ref.watch(appDatabaseProvider.future);
  yield* db.watchAllCourses().map((rows) => rows.map((row) => CourseDto(
        id: row.id,
        title: row.title,
        colorIndex: row.colorIndex,
        chapterCount: row.chapterCount,
        totalDuration: row.totalDuration,
        totalContents: row.totalContents,
        progress: row.progress,
        completedLessons: row.completedLessons,
        totalLessons: row.totalLessons,
      )).toList());
}

final isLogoutSheetOpenProvider = StateProvider<bool>((ref) => false);
