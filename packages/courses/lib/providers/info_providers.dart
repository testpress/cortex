import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'course_list_provider.dart';

part 'info_providers.g.dart';

/// Notifier that manages the info-specific course list and its independent sync state.
/// This perfectly matches the pattern used in ExamList.
@Riverpod(keepAlive: true)
class InfoList extends _$InfoList {
  bool _isInitialized = false;

  @override
  Stream<List<CourseDto>> build() async* {
    final repo = await ref.watch(courseRepositoryProvider.future);
    
    // Yield the filtered stream from the repository
    yield* repo.watchInfoCourses().map(
          (rows) => rows.map((row) => repo.rowToCourseDto(row)).toList(),
        );
  }

  /// Triggers an independent sync for the Info tab.
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isInitialized = true;
    ref.read(isSyncingInfoProvider.notifier).state = true;
    
    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      
      int currentPage = 1;
      bool hasMore = true;
      
      while (hasMore) {
        final response = await repo.refreshCourses(
          page: currentPage,
          tags: 'info',
        );
        
        if (response.next == null) {
          hasMore = false;
        } else {
          currentPage++;
          if (currentPage > 10) hasMore = false; // Safety cap
        }
      }
    } catch (e) {
      _isInitialized = false; // Allow retry on error
    } finally {
      ref.read(isSyncingInfoProvider.notifier).state = false;
    }
  }

  Future<void> loadMore() async {
    // Note: The simple loop in initialize already fetches all pages 
    // to match the ExamList pattern. If you need explicit "Load More" 
    // on scroll, we can implement paginated sync here.
  }
}

/// Simple provider to track the independent loading state of the Info tab.
final isSyncingInfoProvider = StateProvider<bool>((ref) => false);
