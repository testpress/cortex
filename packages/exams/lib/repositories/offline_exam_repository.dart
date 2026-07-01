import 'dart:async';
import 'dart:io';
import 'dart:convert' as dart_convert;
import 'package:core/data/data.dart';
import 'package:core/network/file_downloader.dart';
import 'package:core/utils/html_asset_extractor.dart';
import 'package:drift/drift.dart' as drift;
import 'exam_repository.dart';

class OfflineExamRepository implements ExamRepository {
  final AppDatabase _db;
  final DataSource _api;
  final FileDownloader _fileDownloader;
  final String _contentId; // The local lookup key (lesson/content ID)
  final _stateController = StreamController<ExamAttemptState>.broadcast();
  ExamAttemptState _currentState = const ExamAttemptState();
  Timer? _countdownTimer;

  OfflineExamRepository({
    required AppDatabase db,
    required DataSource api,
    required FileDownloader fileDownloader,
    required String
    contentId, // Using contentId instead of examId route parameter
  }) : _db = db,
       _api = api,
       _fileDownloader = fileDownloader,
       _contentId = contentId;

  void _emit(ExamAttemptState state) {
    _currentState = state;
    _stateController.add(state);
  }

  @override
  Stream<ExamAttemptState> get stateStream => _stateController.stream;

  @override
  Stream<ExamAttemptState> watchState() async* {
    yield _currentState;
    yield* _stateController.stream;
  }

  @override
  ExamAttemptState get state => _currentState;

  @override
  void reset() {
    _countdownTimer?.cancel();
    _emit(const ExamAttemptState());
  }

  int _parseDuration(String duration) {
    if (duration.isEmpty) return 0;
    final parts = duration.split(':');
    if (parts.length != 3) return 0;
    try {
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final s = double.parse(parts[2]).toInt();
      return (h * 3600) + (m * 60) + s;
    } catch (_) {
      return 0;
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentState.remainingSeconds > 0) {
        _emit(
          _currentState.copyWith(
            remainingSeconds: _currentState.remainingSeconds - 1,
          ),
        );
      } else {
        timer.cancel();
        endExam();
      }
    });
  }

  @override
  Future<void> pauseExam() async {
    _countdownTimer?.cancel();
    final row = await _db.getDownloadByContentId(_contentId);
    if (row != null && _currentState.exam != null) {
      final totalSeconds = _parseDuration(_currentState.exam!.duration);
      final elapsed = totalSeconds - _currentState.remainingSeconds;
      await _db.upsertDownload(
        row.toCompanion(false).copyWith(elapsedSeconds: drift.Value(elapsed)),
      );
    }
  }

  @override
  Future<void> stopCountdown() async {
    _countdownTimer?.cancel();
  }

  @override
  void stopHeartbeat() {} // Offline exams don't use heartbeats

  @override
  Future<List<AttemptDto>> getAttempts(String attemptsUrl) async {
    // Offline exams don't use real attempts for the UI.
    // The ExamPrescreen now relies entirely on OnlineExamRepository to fetch history.
    return [];
  }

  @override
  Future<void> startStandaloneExam(
    ExamDto exam, {
    bool isQuizMode = false,
    bool isPartial = false,
  }) async {
    await _startOfflineExam(exam, isQuizMode);
  }

  @override
  Future<void> startCourseLinkedExam(
    ExamDto exam,
    String contentAttemptsUrl, {
    bool isQuizMode = false,
    bool isPartial = false,
  }) async {
    await _startOfflineExam(exam, isQuizMode);
  }

  /// Replaces remote image URLs with local cache paths for offline rendering.
  Future<List<QuestionDto>> _substituteOfflineImages(
    List<QuestionDto> questions,
  ) async {
    final updated = <QuestionDto>[];
    for (final q in questions) {
      String modifiedHtml = q.text; // Text contains the HTML for questions
      final urls = HtmlAssetExtractor.extractImageUrls(modifiedHtml);
      for (final url in urls) {
        try {
          final localPath = await _fileDownloader.getLocalPath(
            url,
            StorageType.internalCache,
          );
          if (await File(localPath).exists()) {
            modifiedHtml = modifiedHtml.replaceAll(url, 'file://$localPath');
          }
        } catch (_) {}
      }

      // Do the same for options
      final modifiedOptions = <QuestionOptionDto>[];
      for (final opt in q.options) {
        String optHtml = opt.text; // Text contains the HTML for options
        final optUrls = HtmlAssetExtractor.extractImageUrls(optHtml);
        for (final optUrl in optUrls) {
          try {
            final localPath = await _fileDownloader.getLocalPath(
              optUrl,
              StorageType.internalCache,
            );
            if (await File(localPath).exists()) {
              optHtml = optHtml.replaceAll(optUrl, 'file://$localPath');
            }
          } catch (_) {}
        }
        modifiedOptions.add(opt.copyWith(text: optHtml));
      }

      updated.add(q.copyWith(text: modifiedHtml, options: modifiedOptions));
    }
    return updated;
  }

  Future<void> _startOfflineExam(ExamDto exam, bool isQuizMode) async {
    _emit(ExamAttemptState(status: ExamAttemptStatus.loading, exam: exam));
    try {
      final row = await _db.getDownloadByContentId(_contentId);
      if (row == null) throw Exception("Offline exam not found");

      // Mark as IN_PROGRESS
      await _db.upsertDownload(
        row
            .toCompanion(false)
            .copyWith(
              startedAt: drift.Value(DateTime.now()),
              status: const drift.Value('IN_PROGRESS'),
            ),
      );

      final questionsRaw =
          dart_convert.jsonDecode(row.questionsJson) as List<dynamic>;
      final questions = questionsRaw
          .map((q) => QuestionDto.fromJson(q as Map<String, dynamic>))
          .toList();
      final processedQuestions = await _substituteOfflineImages(questions);

      final savedItems = await _db.getAnswersForDownload(row.id);
      final savedItemsMap = {
        for (final item in savedItems) item.questionId: item,
      };

      final answers = <String, AnswerDto>{};
      final populatedQuestions = processedQuestions.map((q) {
        if (savedItemsMap.containsKey(q.id)) {
          final saved = savedItemsMap[q.id]!;
          List<String> options = [];
          if (saved.selectedChoices != null) {
            try {
              options = List<String>.from(
                dart_convert.jsonDecode(saved.selectedChoices!),
              );
            } catch (_) {}
          }
          final ans = AnswerDto(
            questionId: q.id,
            selectedOptions: options,
            shortText: saved.shortAnswer,
            essayText: saved.shortAnswer,
            review: saved.review,
          );
          answers[q.id] = ans;
          return q.copyWith(
            selectedOptionIds: options,
            shortText: saved.shortAnswer,
            essayText: saved.shortAnswer,
            isMarked: saved.review,
          );
        }
        return q;
      }).toList();

      final totalSeconds = _parseDuration(exam.duration);
      int remainingSeconds = 0;
      if (totalSeconds > 0) {
        remainingSeconds = totalSeconds - row.elapsedSeconds;
        if (remainingSeconds < 0) remainingSeconds = 0;
      }

      _emit(
        ExamAttemptState(
          status: ExamAttemptStatus.inProgress,
          exam: exam,
          attempt: null, // No attempt dummy!
          questions: populatedQuestions,
          answers: answers,
          sections: [],
          currentSectionIndex: 0,
          isQuizMode: isQuizMode,
          remainingSeconds: remainingSeconds,
        ),
      );

      if (remainingSeconds > 0) {
        _startCountdown();
      }
    } catch (e) {
      _emit(
        ExamAttemptState(
          status: ExamAttemptStatus.error,
          exam: exam,
          errorMessage: 'Failed to start offline exam: $e',
        ),
      );
    }
  }

  @override
  Future<void> switchSection(int index) async {
    if (index < 0 || index >= _currentState.sections.length) return;
    _emit(_currentState.copyWith(currentSectionIndex: index));
  }

  @override
  Future<void> submitAnswer(String questionId, AnswerDto answer) async {
    final updatedAnswers = Map<String, AnswerDto>.from(_currentState.answers);
    updatedAnswers[questionId] = answer;
    _emit(_currentState.copyWith(answers: updatedAnswers));

    final row = await _db.getDownloadByContentId(_contentId);
    if (row == null) return;

    final selectedChoices = dart_convert.jsonEncode(answer.selectedOptions);

    await _db.upsertAnswer(
      OfflineExamAnswersTableCompanion.insert(
        downloadId: row.id,
        questionId: questionId,
        selectedChoices: drift.Value(selectedChoices),
        shortAnswer: drift.Value(answer.shortText),
        review: drift.Value(answer.review),
        savedAt: DateTime.now(),
      ),
    );
  }

  @override
  void updateLocalAnswer(String questionId, AnswerDto answer) {
    final updatedAnswers = Map<String, AnswerDto>.from(_currentState.answers);
    updatedAnswers[questionId] = answer;
    _emit(_currentState.copyWith(answers: updatedAnswers));
  }

  @override
  Future<void> checkQuizAnswer(String questionId, AnswerDto answer) async {}

  @override
  void updateShortText(String questionId, String text) {
    final ans =
        _currentState.answers[questionId] ??
        AnswerDto(questionId: questionId, selectedOptions: []);
    updateLocalAnswer(
      questionId,
      AnswerDto(
        questionId: ans.questionId,
        selectedOptions: ans.selectedOptions,
        isMarked: ans.isMarked,
        result: ans.result,
        shortText: text,
        essayText: ans.essayText,
      ),
    );
  }

  @override
  void updateEssayText(String questionId, String text) {
    final ans =
        _currentState.answers[questionId] ??
        AnswerDto(questionId: questionId, selectedOptions: []);
    updateLocalAnswer(
      questionId,
      AnswerDto(
        questionId: ans.questionId,
        selectedOptions: ans.selectedOptions,
        isMarked: ans.isMarked,
        result: ans.result,
        shortText: ans.shortText,
        essayText: text,
      ),
    );
  }

  @override
  void markQuestionAsChecked(String questionId) {
    final ans =
        _currentState.answers[questionId] ??
        AnswerDto(questionId: questionId, selectedOptions: []);
    updateLocalAnswer(
      questionId,
      AnswerDto(
        questionId: ans.questionId,
        selectedOptions: ans.selectedOptions,
        isMarked: true,
        result: ans.result,
        shortText: ans.shortText,
        essayText: ans.essayText,
      ),
    );
  }

  @override
  Future<void> endExam() async {
    _emit(_currentState.copyWith(status: ExamAttemptStatus.submitting));

    final row = await _db.getDownloadByContentId(_contentId);
    if (row != null) {
      await _db.upsertDownload(
        row
            .toCompanion(false)
            .copyWith(
              completedAt: drift.Value(DateTime.now()),
              status: const drift.Value('PENDING_SYNC'),
            ),
      );
    }

    _emit(_currentState.copyWith(status: ExamAttemptStatus.completed));
  }

  @override
  Future<List<ReviewItemDto>> getReviewItems(String reviewUrl) async {
    return []; // Offline review not supported yet
  }

  @override
  Future<List<SubjectAnalyticsDto>> getSubjectAnalytics(
    String analyticsUrl,
  ) async {
    return []; // Offline analytics not supported yet
  }

  // ─── Downloading Logic ─────────────────────────────────────────────────────

  /// Takes an exam JSON string, extracts all image URLs, and downloads them
  /// to the internal cache so they can be served offline.
  Future<void> _cacheExamAssets(String examJson) async {
    final urls = HtmlAssetExtractor.extractImageUrls(examJson);
    final uniqueUrls = urls.toSet();

    final futures = uniqueUrls.map((url) async {
      try {
        final localPath = await _fileDownloader.getLocalPath(
          url,
          StorageType.internalCache,
        );
        if (await File(localPath).exists()) return;
        await _fileDownloader.download(
          url: url,
          type: StorageType.internalCache,
          requireAuth: true,
        );
      } catch (e) {
        // Ignore failures for individual assets
      }
    });

    await Future.wait(futures);
  }

  /// Downloads the exam questions and assets, then saves them
  /// to the local Drift database so they can be taken completely offline.
  Future<void> downloadExam(ExamDto examData) async {
    // 1. Fetch all questions for this exam using the ACTUAL EXAM ID (not the contentId route param)
    final questions = await _api.getOfflineExamQuestions(
      examData.id.toString(),
    );

    // 2. Encode questions as a JSON blob
    final questionsJsonStr = dart_convert.jsonEncode(
      questions.map((q) => q.toJson()).toList(),
    );

    // 3. Cache the HTML assets from the JSON
    await _cacheExamAssets(questionsJsonStr);

    // 4. Clear any existing downloads for this contentId to prevent duplicates
    final existingRows = await (_db.select(
      _db.offlineExamDownloadsTable,
    )..where((t) => t.contentId.equals(_contentId))).get();
    for (final row in existingRows) {
      await _db.deleteDownload(row.id);
    }

    // 5. Save to the new table with PENDING_SYNC/DOWNLOADED status
    await _db.upsertDownload(
      OfflineExamDownloadsTableCompanion.insert(
        contentId: _contentId,
        examId: examData.id.toString(),
        downloadedAt: DateTime.now(),
        status: const drift.Value('DOWNLOADED'),
        questionsJson: questionsJsonStr,
      ),
    );
  }
}
