import '../models/test_model.dart';
import '../models/analytics_overview.dart';
import '../models/section_performance_overview.dart';

class ReviewAnalyticsDataset {
  const ReviewAnalyticsDataset({
    required this.overview,
    required this.sections,
    required this.sectionTotals,
  });

  final AnalyticsOverview overview;
  final List<SectionPerformanceOverview> sections;
  final SectionPerformanceOverview sectionTotals;
}

class MockReviewAnalyticsFactory {
  static ReviewAnalyticsDataset createDataset({
    required List<TestQuestion> questions,
    required Map<String, TestAttemptAnswer> attemptStates,
  }) {
    int totalCorrect = 0;
    int totalIncorrect = 0;
    int totalAttempted = 0;

    // Group questions by subject
    final Map<String, List<TestQuestion>> subjectGroups = {};
    for (final q in questions) {
      if (q.subject.isEmpty) {
        subjectGroups.putIfAbsent('General', () => []).add(q);
      } else {
        subjectGroups.putIfAbsent(q.subject, () => []).add(q);
      }
    }

    final sections = <SectionPerformanceOverview>[];

    for (final entry in subjectGroups.entries) {
      final subject = entry.key;
      final subjectQuestions = entry.value;

      int subjectCorrect = 0;
      int subjectIncorrect = 0;
      int subjectAttempted = 0;

      for (final q in subjectQuestions) {
        final attempt = attemptStates[q.id];
        if (attempt != null && attempt.selectedOptions.isNotEmpty) {
          subjectAttempted++;
          final isCorrect =
              attempt.selectedOptions.length == q.correctOptionIds.length &&
              q.correctOptionIds.every(
                (id) => attempt.selectedOptions.contains(id),
              );
          if (isCorrect) {
            subjectCorrect++;
          } else {
            subjectIncorrect++;
          }
        }
      }

      totalCorrect += subjectCorrect;
      totalIncorrect += subjectIncorrect;
      totalAttempted += subjectAttempted;

      sections.add(
        SectionPerformanceOverview(
          name: subject,
          totalQuestions: subjectQuestions.length,
          correct: subjectCorrect,
          incorrect: subjectIncorrect,
          score: (subjectCorrect * 4) - subjectIncorrect,
          accuracy: subjectAttempted == 0
              ? 0.0
              : (subjectCorrect / subjectAttempted * 100),
          timeSpent: Duration(minutes: subjectAttempted * 2), // Mocking time
          totalTime: Duration(
            minutes: subjectQuestions.length * 2,
          ), // Mocking total time
        ),
      );
    }

    final totalQuestions = questions.length;
    final totalUnanswered = totalQuestions - totalAttempted;
    final totalScore = ((totalCorrect * 4) - totalIncorrect).clamp(
      0,
      totalQuestions * 4,
    );
    final maxScore = totalQuestions * 4;

    final sectionTotals = SectionPerformanceOverview(
      name: 'Overall',
      totalQuestions: totalQuestions,
      correct: totalCorrect,
      incorrect: totalIncorrect,
      score: totalScore,
      accuracy: totalAttempted == 0
          ? 0.0
          : (totalCorrect / totalAttempted * 100),
      timeSpent: Duration(minutes: totalAttempted * 2),
      totalTime: Duration(minutes: totalQuestions * 2),
    );

    return ReviewAnalyticsDataset(
      overview: AnalyticsOverview(
        totalScore: totalScore,
        maxScore: maxScore,
        attemptedQuestions: totalAttempted,
        totalQuestions: totalQuestions,
        percentile: 88.2, // mock
        accuracy: totalAttempted == 0
            ? 0.0
            : (totalCorrect / totalAttempted * 100),
        timeTaken: Duration(minutes: totalAttempted * 2),
        totalTime: Duration(minutes: totalQuestions * 2),
        overallRank: 124, // mock
        totalParticipants: 2000, // mock
        correct: totalCorrect,
        incorrect: totalIncorrect,
        unanswered: totalUnanswered,
        performanceLevel: _performanceLevel(totalScore, maxScore),
      ),
      sections: sections,
      sectionTotals: sectionTotals,
    );
  }

  static String _performanceLevel(int totalScore, int maxScore) {
    if (maxScore == 0) return 'Bad';
    final percent = totalScore / maxScore * 100;
    if (percent >= 80) return 'Excellent';
    if (percent >= 65) return 'Good';
    if (percent >= 45) return 'Average';
    return 'Bad';
  }
}
