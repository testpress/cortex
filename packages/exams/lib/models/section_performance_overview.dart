class SectionPerformanceOverview {
  const SectionPerformanceOverview({
    required this.name,
    required this.totalQuestions,
    required this.correct,
    required this.incorrect,
    required this.score,
    required this.accuracy,
    required this.timeSpent,
    required this.totalTime,
  });

  final String name;
  final int totalQuestions;
  final int correct;
  final int incorrect;
  final int score;
  final double accuracy;
  final Duration timeSpent;
  final Duration totalTime;

  int get unanswered =>
      (totalQuestions - correct - incorrect).clamp(0, totalQuestions);
}
