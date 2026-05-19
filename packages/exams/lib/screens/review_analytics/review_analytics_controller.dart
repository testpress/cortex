import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_review_analytics.dart';
import '../../models/analytics_overview.dart';
import '../../models/section_performance_overview.dart';
import '../../providers/exam_providers.dart';
import '../../repositories/exam_repository.dart';

class ReviewAnalyticsState {
  final bool isLoading;
  final AnalyticsOverview? overview;
  final List<SectionPerformanceOverview> sections;
  final SectionPerformanceOverview? sectionTotals;
  final String? errorMessage;

  ReviewAnalyticsState({
    required this.isLoading,
    this.overview,
    this.sections = const [],
    this.sectionTotals,
    this.errorMessage,
  });

  ReviewAnalyticsState copyWith({
    bool? isLoading,
    AnalyticsOverview? overview,
    List<SectionPerformanceOverview>? sections,
    SectionPerformanceOverview? sectionTotals,
    String? errorMessage,
  }) {
    return ReviewAnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      overview: overview ?? this.overview,
      sections: sections ?? this.sections,
      sectionTotals: sectionTotals ?? this.sectionTotals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ReviewAnalyticsParam {
  final AttemptDto? attempt;
  final List<QuestionDto> questions;
  final Map<String, AnswerDto> attemptStates;

  ReviewAnalyticsParam({
    required this.attempt,
    required this.questions,
    required this.attemptStates,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewAnalyticsParam &&
          runtimeType == other.runtimeType &&
          attempt?.id == other.attempt?.id &&
          questions.length == other.questions.length &&
          attemptStates.length == other.attemptStates.length;

  @override
  int get hashCode =>
      (attempt?.id ?? '').hashCode ^
      questions.length.hashCode ^
      attemptStates.length.hashCode;
}

class ReviewAnalyticsController extends StateNotifier<ReviewAnalyticsState> {
  final ReviewAnalyticsParam param;
  final ExamRepository examRepository;

  ReviewAnalyticsController({
    required this.param,
    required this.examRepository,
  }) : super(ReviewAnalyticsState(isLoading: true)) {
    _initializeData();
  }

  void _initializeData() {
    final attempt = param.attempt;
    if (attempt == null) {
      // Fallback to local mock data generator if no attempt is supplied
      final dataset = MockReviewAnalyticsFactory.createDataset(
        questions: param.questions,
        attemptStates: param.attemptStates,
      );
      state = ReviewAnalyticsState(
        isLoading: false,
        overview: dataset.overview,
        sections: dataset.sections,
        sectionTotals: dataset.sectionTotals,
      );
      return;
    }

    // Parse overview stats immediately from attempt DTO to show UI instantly
    int scoreVal = 0;
    int maxScoreVal = 0;
    final totalQs = attempt.totalQuestions ?? param.questions.length;
    double derivedMarkPerQuestion = double.tryParse(attempt.markPerQuestion ?? '') ?? 4.0;

    if (attempt.score != null) {
      final parts = attempt.score!.split('/');
      scoreVal = int.tryParse(parts[0]) ?? 0;
      if (parts.length > 1) {
        maxScoreVal = int.tryParse(parts[1]) ?? 0;
        if (maxScoreVal > 0 && totalQs > 0 && attempt.markPerQuestion == null) {
          derivedMarkPerQuestion = maxScoreVal / totalQs;
        }
      }
    }
    if (maxScoreVal == 0) {
      maxScoreVal = (totalQs * derivedMarkPerQuestion).toInt();
    }

    int totalDurationSeconds = 0;
    int remainingSeconds = 0;
    if (attempt.sections != null) {
      for (final s in attempt.sections!) {
        totalDurationSeconds += _parseDurationToSeconds(s.duration);
        remainingSeconds += _parseDurationToSeconds(s.remainingTime);
      }
    }

    final totalTime = totalDurationSeconds > 0
        ? Duration(seconds: totalDurationSeconds)
        : Duration(minutes: totalQs * 2);

    final timeTaken = totalDurationSeconds > 0
        ? Duration(seconds: (totalDurationSeconds - remainingSeconds).clamp(0, totalDurationSeconds))
        : const Duration(minutes: 10);

    final correct = attempt.correctCount ?? 0;
    final incorrect = attempt.incorrectCount ?? 0;
    final attempted = correct + incorrect;
    final unanswered = (totalQs - attempted).clamp(0, totalQs);

    final overview = AnalyticsOverview(
      totalScore: scoreVal,
      maxScore: maxScoreVal,
      attemptedQuestions: attempted,
      totalQuestions: totalQs,
      percentile: double.tryParse(attempt.percentile ?? '') ?? 0.0,
      accuracy: (attempt.accuracy ?? 0).toDouble(),
      timeTaken: timeTaken,
      totalTime: totalTime,
      overallRank: int.tryParse(attempt.rank ?? '') ?? 0,
      totalParticipants: int.tryParse(attempt.maxRank ?? '') ?? 0,
      correct: correct,
      incorrect: incorrect,
      unanswered: unanswered,
      performanceLevel: _performanceLevel(scoreVal, maxScoreVal),
    );

    state = ReviewAnalyticsState(
      isLoading: true,
      overview: overview,
    );

    _fetchSubjectAnalytics();
  }

  int _parseDurationToSeconds(String? durStr) {
    if (durStr == null) return 0;
    final parts = durStr.split(':');
    if (parts.length == 3) {
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      final seconds = int.tryParse(parts[2]) ?? 0;
      return hours * 3600 + minutes * 60 + seconds;
    }
    return 0;
  }

  String _performanceLevel(int score, int maxScore) {
    if (maxScore == 0) return 'Bad';
    final percent = score / maxScore * 100;
    if (percent >= 80) return 'Excellent';
    if (percent >= 65) return 'Good';
    if (percent >= 45) return 'Average';
    return 'Bad';
  }

  Future<void> _fetchSubjectAnalytics() async {
    final attempt = param.attempt;
    if (attempt == null) return;

    try {
      final String analyticsUrl = attempt.reviewUrl != null
          ? attempt.reviewUrl!.replaceFirst('/review/', '/review/subjects/')
          : ApiEndpoints.subjectAnalytics(attempt.id);

      final subjects = await examRepository.getSubjectAnalytics(analyticsUrl);

      // Derive marking parameters dynamically from attempt score
      final totalQs = attempt.totalQuestions ?? param.questions.length;
      double derivedMarkPerQuestion = double.tryParse(attempt.markPerQuestion ?? '') ?? 4.0;
      if (attempt.score != null) {
        final parts = attempt.score!.split('/');
        if (parts.length > 1) {
          final maxScoreVal = double.tryParse(parts[1]) ?? 0.0;
          if (maxScoreVal > 0 && totalQs > 0 && attempt.markPerQuestion == null) {
            derivedMarkPerQuestion = maxScoreVal / totalQs;
          }
        }
      }
      final double negativeMarks = double.tryParse(attempt.negativeMarks ?? '') ?? (derivedMarkPerQuestion / 4.0);

      final mappedSections = subjects.map((s) {
        final subjectScore = (s.correct * derivedMarkPerQuestion) - (s.incorrect * negativeMarks);
        return SectionPerformanceOverview(
          name: s.name,
          totalQuestions: s.total,
          correct: s.correct,
          incorrect: s.incorrect,
          score: subjectScore.toInt(),
          accuracy: s.correctPercentage,
          timeSpent: Duration.zero,
          totalTime: Duration.zero,
        );
      }).toList();

      int totQuestions = 0;
      int totCorrect = 0;
      int totIncorrect = 0;
      int totScore = 0;

      for (final s in mappedSections) {
        totQuestions += s.totalQuestions;
        totCorrect += s.correct;
        totIncorrect += s.incorrect;
        totScore += s.score;
      }

      final totAccuracy = (totCorrect + totIncorrect) == 0
          ? 0.0
          : (totCorrect / (totCorrect + totIncorrect) * 100);

      final mappedTotals = SectionPerformanceOverview(
        name: 'Overall',
        totalQuestions: totQuestions,
        correct: totCorrect,
        incorrect: totIncorrect,
        score: totScore,
        accuracy: totAccuracy,
        timeSpent: Duration.zero,
        totalTime: Duration.zero,
      );

      state = state.copyWith(
        isLoading: false,
        sections: mappedSections,
        sectionTotals: mappedTotals,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final reviewAnalyticsControllerProvider = StateNotifierProvider.family<
    ReviewAnalyticsController,
    ReviewAnalyticsState,
    ReviewAnalyticsParam
>((ref, param) {
  final repository = ref.watch(examRepositoryProvider);
  return ReviewAnalyticsController(
    param: param,
    examRepository: repository,
  );
});
