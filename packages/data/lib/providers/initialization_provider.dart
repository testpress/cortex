import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repository_providers.dart';
import 'auth_provider.dart';
import 'recent_activity_provider.dart';

part 'initialization_provider.g.dart';

/// Provider that handles app-wide data initialization and refresh logic.
/// This prevents side effects within UI-driven data providers.
@riverpod
Future<void> appInitialization(AppInitializationRef ref) async {
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final courseRepo = await ref.watch(courseRepositoryProvider.future);
  final user = ref.watch(authProvider);

  // Initialize core data in background
  try {
    // 1. Refresh the list of enrolled courses from the network/mock source
    final courses = await courseRepo.refreshCourses();

    // 2. Refresh chapters for all enrolled courses so the curriculum is populated
    for (final course in courses) {
      await courseRepo.refreshChapters(course.id);
    }

    // 3. Refresh user progress to see what was recently completed
    await userRepo.refreshProgress(user.id);

    // 4. To support the Resume Card labels (Need titles for Lesson/Chapter/Course),
    // we deep-sync the lessons for the most recent activities.
    // Use .read instead of .watch/future here because this is a one-time startup sync
    final recent = await ref.read(recentActivityProvider.future);
    if (recent != null) {
      // Find the chapter this lesson belongs to and sync its lessons
      // In a real API, the progress object would likely include chapterId.
      // For mock, we simply sync a known chapter if it matches.
      await courseRepo.refreshLessons('jee-main-ch-1');
      await courseRepo.refreshLessons('neet-ch-1');
    }
  } catch (e) {
    // Initialization errors are handled here or surfaced to the listener
    rethrow;
  }
}
