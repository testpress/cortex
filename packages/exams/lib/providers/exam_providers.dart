import 'dart:async';
import 'dart:convert';
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

/// Fetches exam details by slug with Stale-While-Revalidate (SWR) cache.
@Riverpod(keepAlive: true)
class ExamDetail extends _$ExamDetail {
  DateTime? _lastLocalPausedUpdate;

  @override
  FutureOr<ExamDto> build(String slug) async {
    final db = await ref.watch(appDatabaseProvider.future);

    // 1. Emit cached data instantly if it exists
    final cachedJson = await db.watchLessonExamMetadataBySlug(slug).first;
    if (cachedJson != null) {
      try {
        state = AsyncData(ExamDto.fromJson(jsonDecode(cachedJson)));
      } catch (_) {
        // Fallback if JSON is malformed
      }
    }

    // 2. Fetch fresh data from network in background
    revalidate(slug);

    // 3. Keep the future resolving based on cache or a new fetch
    if (state.hasValue) {
      return state.requireValue;
    }

    // First ever fetch (no cache)
    final dataSource = ref.watch(dataSourceProvider);
    final freshDto = await dataSource.getExam(slug);
    await db.updateLessonExamMetadata(slug, jsonEncode(freshDto.toJson()));
    return freshDto;
  }

  Future<void> revalidate(String slug) async {
    try {
      final dataSource = ref.read(dataSourceProvider);
      final freshDto = await dataSource.getExam(slug);

      final db = await ref.read(appDatabaseProvider.future);
      final cachedJson = await db.watchLessonExamMetadataBySlug(slug).first;

      // If we recently updated the paused attempts locally, ignore the API's count
      // because the API or CDN might be serving stale data.
      final freshJsonMap = freshDto.toJson();

      DateTime? lastPausedUpdate = _lastLocalPausedUpdate;
      if (cachedJson != null) {
        try {
          final cachedJsonMap = jsonDecode(cachedJson);
          final lastUpdateStr =
              cachedJsonMap['last_local_paused_update'] as String?;
          if (lastUpdateStr != null) {
            final parsedDate = DateTime.tryParse(lastUpdateStr);
            if (parsedDate != null &&
                (lastPausedUpdate == null ||
                    parsedDate.isAfter(lastPausedUpdate))) {
              lastPausedUpdate = parsedDate;
            }
          }
        } catch (_) {}
      }

      if (lastPausedUpdate != null &&
          DateTime.now().difference(lastPausedUpdate) <
              const Duration(minutes: 5)) {
        if (cachedJson != null) {
          try {
            final cachedJsonMap = jsonDecode(cachedJson);
            if (cachedJsonMap.containsKey('paused_attempts_count')) {
              freshJsonMap['paused_attempts_count'] =
                  cachedJsonMap['paused_attempts_count'];
              freshJsonMap['last_local_paused_update'] = lastPausedUpdate
                  .toIso8601String();
            }
          } catch (_) {}
        }
      }

      final freshJsonToSave = jsonEncode(freshJsonMap);

      // Only upsert if data changed
      if (cachedJson != freshJsonToSave) {
        await db.updateLessonExamMetadata(slug, freshJsonToSave);
        state = AsyncData(ExamDto.fromJson(freshJsonMap));
      }
    } catch (e, stack) {
      // SWR silently ignores background fetch errors if we have cache
      if (!state.hasValue) {
        state = AsyncError(e, stack);
      }
    }
  }

  Future<void> setPausedAttemptsCount(String slug, int count) async {
    _lastLocalPausedUpdate = DateTime.now();
    final db = await ref.read(appDatabaseProvider.future);
    final cachedJsonStr = await db.watchLessonExamMetadataBySlug(slug).first;
    Map<String, dynamic>? json;
    if (cachedJsonStr != null) {
      try {
        json = jsonDecode(cachedJsonStr) as Map<String, dynamic>;
      } catch (_) {}
    }

    json ??= state.valueOrNull?.toJson();

    if (json != null) {
      try {
        json['paused_attempts_count'] = count;
        json['last_local_paused_update'] = _lastLocalPausedUpdate
            ?.toIso8601String();
        final updatedJsonStr = jsonEncode(json);
        await db.updateLessonExamMetadata(slug, updatedJsonStr);
        state = AsyncData(ExamDto.fromJson(json));
      } catch (_) {}
    }
  }
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

  Future<void> loadExam(String slug, {bool isQuizMode = false}) =>
      ref.read(examRepositoryProvider).loadExam(slug, isQuizMode: isQuizMode);

  void reset() => ref.read(examRepositoryProvider).reset();

  Future<void> startStandaloneExam(ExamDto exam, {bool isQuizMode = false}) =>
      ref
          .read(examRepositoryProvider)
          .startStandaloneExam(exam, isQuizMode: isQuizMode);

  Future<void> startCourseLinkedExam(
    ExamDto exam,
    String contentAttemptsUrl, {
    bool isQuizMode = false,
  }) => ref
      .read(examRepositoryProvider)
      .startCourseLinkedExam(exam, contentAttemptsUrl, isQuizMode: isQuizMode);

  Future<void> submitAnswer(String answerUrl, AnswerDto answer) =>
      ref.read(examRepositoryProvider).submitAnswer(answerUrl, answer);

  void updateLocalAnswer(String questionId, AnswerDto answer) =>
      ref.read(examRepositoryProvider).updateLocalAnswer(questionId, answer);

  Future<void> checkQuizAnswer(String answerUrl, AnswerDto answer) =>
      ref.read(examRepositoryProvider).checkQuizAnswer(answerUrl, answer);

  void updateShortText(String questionId, String answerUrl, String text) => ref
      .read(examRepositoryProvider)
      .updateShortText(questionId, answerUrl, text);

  void updateEssayText(String questionId, String answerUrl, String text) => ref
      .read(examRepositoryProvider)
      .updateEssayText(questionId, answerUrl, text);

  void markQuestionAsChecked(String questionId) =>
      ref.read(examRepositoryProvider).markQuestionAsChecked(questionId);

  Future<void> endExam(String endUrl) =>
      ref.read(examRepositoryProvider).endExam(endUrl);

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

    if (_pendingSyncRequest != null) return _pendingSyncRequest;

    _pendingSyncRequest = _performSync(isReset: true);
    try {
      await _pendingSyncRequest;
      ref.read(examSyncMetadataProvider.notifier).markSynced();
    } catch (_) {
      // Allow retry on next initialize call by not marking as synced
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
