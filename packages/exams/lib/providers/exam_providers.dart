import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../repositories/exam_repository.dart';

part 'exam_providers.g.dart';

/// Repository provider for exam-specific operations.
@Riverpod(keepAlive: true)
ExamRepository examRepository(Ref ref) {
  final dataSource = ref.watch(dataSourceProvider);
  return ExamRepository(dataSource: dataSource);
}

/// Fetches exam details by slug.
@riverpod
Future<ExamDto> examDetail(Ref ref, String slug) async {
  final repo = ref.watch(examRepositoryProvider);
  // Note: loadExam updates the internal state, but here we just return the DTO
  // directly for the instructions screen.
  final dataSource = ref.watch(dataSourceProvider);
  return dataSource.getExam(slug);
}

/// Notifier that manages the active exam attempt lifecycle.
@riverpod
class ExamAttempt extends _$ExamAttempt {
  @override
  Stream<ExamAttemptState> build() {
    final repo = ref.watch(examRepositoryProvider);
    return repo.stateStream;
  }

  Future<void> loadExam(String slug) => ref.read(examRepositoryProvider).loadExam(slug);
  
  Future<void> startStandaloneExam(ExamDto exam) => 
      ref.read(examRepositoryProvider).startStandaloneExam(exam);
      
  Future<void> startCourseLinkedExam(ExamDto exam, String contentAttemptsUrl) =>
      ref.read(examRepositoryProvider).startCourseLinkedExam(exam, contentAttemptsUrl);

  Future<void> submitAnswer(String answerUrl, AnswerDto answer) =>
      ref.read(examRepositoryProvider).submitAnswer(answerUrl, answer);

  Future<void> endExam(String endUrl) =>
      ref.read(examRepositoryProvider).endExam(endUrl);
}

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
        final response = await repo.refreshCourses(
          page: currentPage,
          tags: ['exams', 'classes'],
        );
        
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
