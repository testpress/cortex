class AnalyticsOverview {
  const AnalyticsOverview({
    required this.totalScore,
    required this.maxScore,
    required this.attemptedQuestions,
    required this.totalQuestions,
    required this.percentile,
    required this.accuracy,
    required this.timeTaken,
    required this.totalTime,
    required this.overallRank,
    required this.totalParticipants,
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    required this.performanceLevel,
  });

  final int totalScore;
  final int maxScore;
  final int attemptedQuestions;
  final int totalQuestions;
  final double percentile;
  final double accuracy;
  final Duration timeTaken;
  final Duration totalTime;
  final int overallRank;
  final int totalParticipants;
  final int correct;
  final int incorrect;
  final int unanswered;
  final String performanceLevel;

  double get scorePercentage => maxScore == 0
      ? 0
      : (totalScore / maxScore * 100).clamp(0, 100).toDouble();
}
