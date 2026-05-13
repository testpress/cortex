import 'dart:async';
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
  final dataSource = ref.watch(dataSourceProvider);
  return dataSource.getExam(slug);
}

/// Fetches attempt history for an exam.
@riverpod
Future<List<AttemptDto>> examAttempts(Ref ref, String attemptsUrl) async {
  final dataSource = ref.watch(dataSourceProvider);
  return dataSource.getAttempts(attemptsUrl);
}

/// Notifier that manages the active exam attempt lifecycle.
@riverpod
class ExamAttempt extends _$ExamAttempt {
  StreamSubscription<ExamAttemptState>? _subscription;

  @override
  ExamAttemptState build() {
    final repo = ref.watch(examRepositoryProvider);
    
    // Subscribe to repository updates
    _subscription?.cancel();
    _subscription = repo.stateStream.listen((newState) {
      state = newState;
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return repo.state;
  }

  Future<void> loadExam(String slug) => ref.read(examRepositoryProvider).loadExam(slug);
  
  void reset() => ref.read(examRepositoryProvider).reset();
  
  Future<void> startStandaloneExam(ExamDto exam) => 
      ref.read(examRepositoryProvider).startStandaloneExam(exam);
      
  Future<void> startCourseLinkedExam(ExamDto exam, String contentAttemptsUrl) =>
      ref.read(examRepositoryProvider).startCourseLinkedExam(exam, contentAttemptsUrl);

  Future<void> submitAnswer(String answerUrl, AnswerDto answer) =>
      ref.read(examRepositoryProvider).submitAnswer(answerUrl, answer);

  Future<void> endExam(String endUrl) =>
      ref.read(examRepositoryProvider).endExam(endUrl);

  Future<void> switchSection(int index) =>
      ref.read(examRepositoryProvider).switchSection(index);
}

/// Notifier that manages the exam-specific course list and its independent sync state.
@Riverpod(keepAlive: true)
class ExamList extends _$ExamList {
  bool _isInitialized = false;
  PaginationState _paginationTracker = const PaginationState();
  Future<void>? _pendingSyncRequest;

  @override
  Stream<List<CourseDto>> build() async* {
    final repo = await ref.watch(courseRepositoryProvider.future);
    
    // Yield the filtered stream from the repository (shared cache)
    yield* repo.watchExamCourses().map(
          (rows) => rows.map((row) => repo.rowToCourseDto(row)).toList(),
        );
  }

  /// Triggers an independent sync for the Exams tab by fetching the first page.
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    if (_pendingSyncRequest != null) return _pendingSyncRequest;
    _isInitialized = true;

    _pendingSyncRequest = _performSync(isReset: true);
    try {
      await _pendingSyncRequest;
    } catch (_) {
      _isInitialized = false; // Allow retry on error
    } finally {
      _pendingSyncRequest = null;
    }
  }

  Future<void> loadMore() async {
    if (!_paginationTracker.hasMore || _pendingSyncRequest != null) return;

    _pendingSyncRequest = _performSync(isReset: false);
    try {
      await _pendingSyncRequest;
    } finally {
      _pendingSyncRequest = null;
    }
  }

  Future<void> _performSync({required bool isReset}) async {
    if (isReset) {
      _paginationTracker = const PaginationState();
      
      // Only show the initial loader if the local database is actually empty.
      final hasData = state.valueOrNull?.isNotEmpty ?? false;
      if (!hasData) {
        Future.microtask(() {
          ref.read(isSyncingExamsProvider.notifier).state = true;
        });
      }
    } else {
      ref.read(isSyncingMoreExamsProvider.notifier).state = true;
    }

    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      final response = await repo.refreshCourses(
        page: _paginationTracker.nextPage,
        tags: 'exams',
      );

      if (response.results.isEmpty) {
        _paginationTracker = _paginationTracker.copyWith(hasMore: false);
      } else {
        const pagination = PaginationService();
        _paginationTracker = pagination.calculateNextState(
          response: response,
          currentPage: _paginationTracker.nextPage,
        );
      }
    } finally {
      if (isReset) {
        Future.microtask(() {
          ref.read(isSyncingExamsProvider.notifier).state = false;
        });
      } else {
        Future.microtask(() {
          ref.read(isSyncingMoreExamsProvider.notifier).state = false;
        });
      }
    }
  }
}

/// Simple provider to track the independent loading state of the Exams tab.
final isSyncingExamsProvider = StateProvider<bool>((ref) => false);
final isSyncingMoreExamsProvider = StateProvider<bool>((ref) => false);
