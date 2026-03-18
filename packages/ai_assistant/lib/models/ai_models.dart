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

enum AIMessageRole { user, assistant }

class AIMessage {
  final String id;
  final String content;
  final AIMessageRole role;
  final DateTime timestamp;
  final String? imageUrl;

  const AIMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.imageUrl,
  });
}

class AIChatSession {
  final String id;
  final String title;
  final List<AIMessage> messages;
  final DateTime createdAt;
  final bool isPinned;

  const AIChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    this.isPinned = false,
  });

  AIChatSession copyWith({
    String? title,
    List<AIMessage>? messages,
    bool? isPinned,
  }) {
    return AIChatSession(
      id: id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
