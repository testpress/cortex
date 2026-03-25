import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:courses/courses.dart';
import 'package:profile/profile.dart';

part 'initialization_provider.g.dart';

/// Provider that handles app-wide data initialization and refresh logic.
/// This prevents side effects within UI-driven data providers.
@riverpod
Future<void> appInitialization(AppInitializationRef ref) async {
  final courseRepo = await ref.watch(courseRepositoryProvider.future);

  // Initialize core data in background
  try {
    // 1. Refresh the list of enrolled courses from the network/mock source
    final courses = await courseRepo.refreshCourses();

    // 2. Refresh chapters and lessons for every enrolled course
    // This ensures the entire study curriculum is available offline/locally.
    // Progress is now included in the lesson payload.
    for (final course in courses) {
      final chapters = await courseRepo.refreshChapters(course.id);

      for (final chapter in chapters) {
        await courseRepo.refreshLessons(chapter.id);
      }
    }
  } catch (e) {
    // Initialization errors are handled here or surfaced to the listener
    rethrow;
  }
}
