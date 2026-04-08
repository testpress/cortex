import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import 'package:profile/profile.dart';

part 'initialization_provider.g.dart';

/// Provider that handles app-wide data initialization and refresh logic.
/// This prevents side effects within UI-driven data providers.
@riverpod
Future<void> appInitialization(AppInitializationRef ref) async {
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final userProgressRepo = await ref.watch(userProgressRepositoryProvider.future);
  final courseRepo = await ref.watch(courseRepositoryProvider.future);

  final isLoggedIn = ref.watch(authProvider).asData?.value ?? false;

  // Initialize core data in background
  try {
    // 1. Refresh the list of enrolled courses from the network/mock source
    if (isLoggedIn) {
      final response = await courseRepo.refreshCourses(page: 1);
      final courses = response.results;

      // 2. Refresh chapters and lessons for every enrolled course
      // This ensures the entire study curriculum is available offline/locally.
      for (final course in courses) {
        final chapters = await courseRepo.refreshChapters(course.id);

        for (final chapter in chapters) {
          await courseRepo.refreshLessons(chapter.id);
        }
      }
    }

    // 3. Refresh user profile and progress to see what was recently completed
    // This allows the Resume Card to find the most recent lesson in the fully-populated DB.
    if (isLoggedIn) {
      final user = await userRepo.refreshProfile();
      await userProgressRepo.refreshProgress(user.id);
    }
  } catch (e) {
    // Initialization errors are handled here or surfaced to the listener
    rethrow;
  }
}
