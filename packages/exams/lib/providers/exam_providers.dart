import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';

part 'exam_providers.g.dart';

/// Notifier that manages the exam-specific course list and its independent sync state.
@Riverpod(keepAlive: true)
class ExamList extends _$ExamList {
  bool _isInitialized = false;

  @override
  Stream<List<CourseDto>> build() async* {
    final repo = await ref.watch(courseRepositoryProvider.future);
    
    // Yield the filtered stream from the repository (shared cache)
    yield* repo.watchExamCourses().map(
          (rows) => rows.map((row) => repo.rowToCourseDto(row)).toList(),
        );
  }

  /// Triggers an independent sync for the Exams tab by fetching all pages.
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isInitialized = true;
    Future.microtask(() {
      ref.read(isSyncingExamsProvider.notifier).state = true;
    });
    
    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      
      int currentPage = 1;
      bool hasMore = true;
      
      while (hasMore) {
        final response = await repo.refreshCourses(page: currentPage);
        
        if (response.next == null) {
          hasMore = false;
        } else {
          currentPage++;
          if (currentPage > 20) hasMore = false; 
        }
      }
    } catch (e) {
      _isInitialized = false; // Allow retry on error
    } finally {
      ref.read(isSyncingExamsProvider.notifier).state = false;
    }
  }
}

/// Simple provider to track the independent loading state of the Exams tab.
final isSyncingExamsProvider = StateProvider<bool>((ref) => false);
