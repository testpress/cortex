import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import 'package:flutter/foundation.dart';

part 'initialization_provider.g.dart';

bool _didRunAppInitialization = false;

/// Provider that handles app-wide data initialization and refresh logic.
/// This prevents side effects within UI-driven data providers.
@Riverpod(keepAlive: true)
Future<void> appInitialization(AppInitializationRef ref) async {
  if (_didRunAppInitialization) return;
  _didRunAppInitialization = true;

  final userRepo = await ref.read(userProgressRepositoryProvider.future);
  final courseRepo = await ref.read(courseRepositoryProvider.future);
  final authState = ref.read(authProvider);
  var effectiveUserId = authState.user?.id ?? '';

  if (!authState.isAuthenticated && SessionStorage.instance.hasSession) {
    final hydrated = await ref.read(authProvider.notifier).refreshFromSession();
    effectiveUserId = hydrated?.id ?? effectiveUserId;
  }

  // Initialize core data in background
  try {
    // 1. Refresh courses only when data source supports it.
    if (AppConfig.useMockData || AppConfig.enableHttpCourseSync) {
      final courses = await courseRepo.refreshCourses();

      // 2. Refresh chapters and lessons for every enrolled course.
      for (final course in courses) {
        final chapters = await courseRepo.refreshChapters(course.id);

        for (final chapter in chapters) {
          await courseRepo.refreshLessons(chapter.id);
        }
      }
    }

    // 3. Refresh user progress to see what was recently completed.
    // This allows the Resume Card to find the most recent lesson in the fully-populated DB.
    if (effectiveUserId.isNotEmpty) {
      await userRepo.refreshProgress(effectiveUserId);
    }
  } catch (e, stackTrace) {
    // Keep app usable with cached data, but don't swallow diagnostics.
    debugPrint('Initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}
