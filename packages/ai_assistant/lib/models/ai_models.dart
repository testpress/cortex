
class AIRecommendation {
  final String id;
  final String type;
  final String title;
  final String description;
  final String reason;

  const AIRecommendation({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.reason,
  });
}

class WeakTopic {
  final String id;
  final String subject;
  final String topic;
  final double accuracy;
  final int subjectColorIndex;

  const WeakTopic({
    required this.id,
    required this.subject,
    required this.topic,
    required this.accuracy,
    required this.subjectColorIndex,
  });
}

enum AIActivityType { doubt, exam, concept }

enum AIActivityStatus { answered, processing, revisit }

class AIActivity {
  final String id;
  final AIActivityType type;
  final String title;
  final String description;
  final String timeAgo;
  final AIActivityStatus? status;

  const AIActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timeAgo,
    this.status,
  });
}
