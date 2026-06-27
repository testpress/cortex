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
  final dbFuture = ref.watch(appDatabaseProvider.future);
  return ExamRepository(dataSource: dataSource, dbFuture: dbFuture);
}

/// Fetches attempt history for an exam.
@riverpod
Future<List<AttemptDto>> examAttempts(Ref ref, String attemptsUrl) async {
  final repository = ref.watch(examRepositoryProvider);
  return repository.getAttempts(attemptsUrl);
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

  void reset() => ref.read(examRepositoryProvider).reset();

  Future<void> startStandaloneExam(
    ExamDto exam, {
    bool isQuizMode = false,
    bool isPartial = false,
  }) => ref
      .read(examRepositoryProvider)
      .startStandaloneExam(exam, isQuizMode: isQuizMode, isPartial: isPartial);

  Future<void> startCourseLinkedExam(
    ExamDto exam,
    String contentAttemptsUrl, {
    bool isQuizMode = false,
    bool isPartial = false,
  }) => ref
      .read(examRepositoryProvider)
      .startCourseLinkedExam(
        exam,
        contentAttemptsUrl,
        isQuizMode: isQuizMode,
        isPartial: isPartial,
      );

  Future<void> submitAnswer(String questionId, AnswerDto answer) =>
      ref.read(examRepositoryProvider).submitAnswer(questionId, answer);

  void updateLocalAnswer(String questionId, AnswerDto answer) =>
      ref.read(examRepositoryProvider).updateLocalAnswer(questionId, answer);

  Future<void> checkQuizAnswer(String questionId, AnswerDto answer) =>
      ref.read(examRepositoryProvider).checkQuizAnswer(questionId, answer);

  void updateShortText(String questionId, String text) =>
      ref.read(examRepositoryProvider).updateShortText(questionId, text);

  void updateEssayText(String questionId, String text) =>
      ref.read(examRepositoryProvider).updateEssayText(questionId, text);

  void markQuestionAsChecked(String questionId) =>
      ref.read(examRepositoryProvider).markQuestionAsChecked(questionId);

  Future<void> endExam() => ref.read(examRepositoryProvider).endExam();

  Future<void> switchSection(int index) =>
      ref.read(examRepositoryProvider).switchSection(index);
}

@Riverpod(keepAlive: true)
class ExamSyncMetadata extends _$ExamSyncMetadata {
  @override
  DateTime? build() {
    ref.watch(authProvider);
    return null;
  }

  void markSynced() {
    state = DateTime.now();
  }
}

/// Notifier that manages the exam-specific course list and its independent sync state.
@riverpod
class ExamList extends _$ExamList {
  PaginationState _paginationTracker = const PaginationState();
  Future<void>? _pendingSyncRequest;
  bool _isPendingSyncReset = false;

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
    final lastSync = ref.read(examSyncMetadataProvider);
    if (lastSync != null) {
      return;
    }

    if (_pendingSyncRequest != null) {
      if (_isPendingSyncReset) return _pendingSyncRequest;
      await _pendingSyncRequest;
    }

    final currentSync = _performSync(isReset: true);
    _pendingSyncRequest = currentSync;
    _isPendingSyncReset = true;
    try {
      await currentSync;
      ref.read(examSyncMetadataProvider.notifier).markSynced();
    } catch (_) {
      // Allow retry on next initialize call by not marking as synced
    } finally {
      if (_pendingSyncRequest == currentSync) {
        _pendingSyncRequest = null;
      }
    }
  }

  Future<void> loadMore() async {
    if (!_paginationTracker.hasMore || _pendingSyncRequest != null) return;

    final currentSync = _performSync(isReset: false);
    _pendingSyncRequest = currentSync;
    _isPendingSyncReset = false;
    try {
      await currentSync;
    } finally {
      if (_pendingSyncRequest == currentSync) {
        _pendingSyncRequest = null;
      }
    }
  }

  Future<void> refresh() async {
    if (_pendingSyncRequest != null) {
      if (_isPendingSyncReset) return _pendingSyncRequest;
      await _pendingSyncRequest;
    }

    final currentSync = _performSync(isReset: true);
    _pendingSyncRequest = currentSync;
    _isPendingSyncReset = true;
    try {
      await currentSync;
      ref.read(examSyncMetadataProvider.notifier).markSynced();
    } finally {
      if (_pendingSyncRequest == currentSync) {
        _pendingSyncRequest = null;
      }
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
