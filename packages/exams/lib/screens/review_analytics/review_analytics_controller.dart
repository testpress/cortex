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
  final ExamDto? exam;
  final List<QuestionDto> questions;
  final Map<String, AnswerDto> attemptStates;

  ReviewAnalyticsParam({
    required this.attempt,
    this.exam,
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

    // Score might be "6.00/6.00", just "6.00", or null
    double scoreValD = 0;
    double maxScoreValD = 0;
    final totalQs = attempt.totalQuestions ?? param.questions.length;
    final correct = attempt.correctCount ?? 0;
    final incorrect = attempt.incorrectCount ?? 0;

    final double? markPerQuestion = double.tryParse(param.exam?.markPerQuestion ?? '') ??
        double.tryParse(attempt.markPerQuestion ?? '');
    final double negativeMarks = double.tryParse(param.exam?.negativeMarks ?? '') ??
        double.tryParse(attempt.negativeMarks ?? '') ?? 0.0;

    if (attempt.score != null && attempt.score!.isNotEmpty) {
      final parts = attempt.score!.split('/');
      scoreValD = double.tryParse(parts[0].trim()) ?? 0;
      if (parts.length > 1) {
        maxScoreValD = double.tryParse(parts[1].trim()) ?? 0;
      }
    } else {
      if (markPerQuestion != null) {
        scoreValD = (correct * markPerQuestion) - (incorrect * negativeMarks);
      }
    }

    // If max score is 0 (either missing from string or score was null), calculate it
    if (maxScoreValD == 0 && markPerQuestion != null) {
      maxScoreValD = totalQs * markPerQuestion;
    }

    final scoreVal = scoreValD.round();
    final maxScoreVal = maxScoreValD.round();

    Duration? timeTaken;
    if (attempt.timeTaken != null) {
      timeTaken = Duration(seconds: _parseDurationToSeconds(attempt.timeTaken));
    }

    Duration? totalTime;
    final examDurationSeconds = _parseDurationToSeconds(param.exam?.duration);
    if (examDurationSeconds > 0) {
      totalTime = Duration(seconds: examDurationSeconds);
    } else if (attempt.timeTaken != null && attempt.remainingTime != null) {
      totalTime = Duration(seconds: _parseDurationToSeconds(attempt.timeTaken) + _parseDurationToSeconds(attempt.remainingTime));
    }

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
      rankEnabled: attempt.rankEnabled,
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

      // Use markPerQuestion from exam (preferred) then fall back to attempt field
      final double? markPerQuestion = double.tryParse(param.exam?.markPerQuestion ?? '') ??
          double.tryParse(attempt.markPerQuestion ?? '');
      final double negativeMarks = double.tryParse(param.exam?.negativeMarks ?? '') ??
          double.tryParse(attempt.negativeMarks ?? '') ?? 0.0;

      final mappedSections = subjects.map((s) {
        final subjectScore = markPerQuestion != null 
            ? ((s.correct * markPerQuestion) - (s.incorrect * negativeMarks)) 
            : 0.0;
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
