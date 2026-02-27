import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repository_providers.dart';
import 'auth_provider.dart';

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
    // Refresh global content
    await courseRepo.refreshCourses();

    // Deep-seed mock curriculum for the main courses to support Resume Card metadata
    // In a real app, this would be lazy-loaded, but we need it for the MVP resume join.
    for (final courseId in ['jee-main-2026', 'neet-2026']) {
      await courseRepo.refreshChapters(courseId);
    }

    // Seed lessons for the first few chapters of JEE Main (where progress exists)
    for (final chapterId in ['jee-main-ch-1', 'jee-main-ch-2']) {
      await courseRepo.refreshLessons(chapterId);
    }

    // Refresh user-specific content
    await userRepo.refreshProgress(user.id);
  } catch (e) {
    // Initialization errors are handled here or surfaced to the listener
    rethrow;
  }
}
