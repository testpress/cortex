import '../models/ai_models.dart';

class AIMockData {
  static const String userName = 'Arjun';
  static const String studyInsight = 'You studied 45 minutes yesterday. Let\'s continue improving today.';

  static final List<WeakTopic> weakTopics = [
    const WeakTopic(
      id: '1',
      subject: 'Physics',
      topic: 'Electromagnetic Induction',
      accuracy: 62,
      subjectColorIndex: 0,
    ),
    const WeakTopic(
      id: '2',
      subject: 'Chemistry',
      topic: 'Chemical Kinetics',
      accuracy: 58,
      subjectColorIndex: 2,
    ),
    const WeakTopic(
      id: '3',
      subject: 'Mathematics',
      topic: '3D Geometry',
      accuracy: 65,
      subjectColorIndex: 1,
    ),
  ];

  static final List<AIActivity> recentActivities = [
    const AIActivity(
      id: '1',
      type: AIActivityType.doubt,
      title: 'Thermodynamics - Entropy Doubt',
      description: 'Explanation on why entropy increases in isolated systems',
      timeAgo: '2 hours ago',
      status: AIActivityStatus.answered,
    ),
    const AIActivity(
      id: '2',
      type: AIActivityType.exam,
      title: 'Organic Chemistry Practice',
      description: '15 questions • Reaction Mechanisms, Isomerism',
      timeAgo: 'Yesterday',
      status: AIActivityStatus.processing,
    ),
    const AIActivity(
      id: '3',
      type: AIActivityType.concept,
      title: 'Integration by Substitution',
      description: 'Step-by-step explanation with examples',
      timeAgo: '2 days ago',
      status: AIActivityStatus.revisit,
    ),
  ];
}
