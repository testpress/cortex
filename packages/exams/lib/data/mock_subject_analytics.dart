import 'package:core/data/models/review_models.dart';

class MockSubjectAnalyticsRepository {
  static const List<SubjectAnalyticsDto> allSubjects = [
    // Root subjects
    SubjectAnalyticsDto(
      id: 1,
      name: 'Biology',
      correct: 4,
      incorrect: 12,
      unanswered: 994,
      total: 1010,
      correctPercentage: 4 / 1010 * 100,
      leaf: false,
    ),
    SubjectAnalyticsDto(
      id: 2,
      name: 'Botany',
      correct: 13,
      incorrect: 35,
      unanswered: 421,
      total: 469,
      correctPercentage: 13 / 469 * 100,
      leaf: true,
    ),
    SubjectAnalyticsDto(
      id: 3,
      name: 'Chemistry',
      correct: 124,
      incorrect: 154,
      unanswered: 1699,
      total: 1977,
      correctPercentage: 124 / 1977 * 100,
      leaf: false,
    ),
    SubjectAnalyticsDto(
      id: 4,
      name: 'Class 10 - Mathematics',
      correct: 12,
      incorrect: 4,
      unanswered: 332,
      total: 348,
      correctPercentage: 12 / 348 * 100,
      leaf: true,
    ),
    SubjectAnalyticsDto(
      id: 5,
      name: 'Class 6 - Physics',
      correct: 58,
      incorrect: 105,
      unanswered: 1113,
      total: 1276,
      correctPercentage: 58 / 1276 * 100,
      leaf: false,
    ),
    SubjectAnalyticsDto(
      id: 6,
      name: 'Zoology',
      correct: 2,
      incorrect: 1,
      unanswered: 237,
      total: 240,
      correctPercentage: 2 / 240 * 100,
      leaf: true,
    ),

    // Chemistry child subjects (parent is Chemistry id: 3)
    SubjectAnalyticsDto(
      id: 7,
      name: 'Jee Chemistry',
      correct: 17,
      incorrect: 8,
      unanswered: 9,
      total: 34,
      correctPercentage: 17 / 34 * 100,
      parent: 3,
      leaf: true,
    ),
    SubjectAnalyticsDto(
      id: 8,
      name: 'Jee Adv. Chemistry',
      correct: 0,
      incorrect: 0,
      unanswered: 25,
      total: 25,
      correctPercentage: 0.0,
      parent: 3,
      leaf: true,
    ),
    SubjectAnalyticsDto(
      id: 9,
      name: 'Neet Chemistry',
      correct: 15,
      incorrect: 39,
      unanswered: 271,
      total: 325,
      correctPercentage: 15 / 325 * 100,
      parent: 3,
      leaf: true,
    ),

    // Physics child subjects (parent is Physics id: 5)
    SubjectAnalyticsDto(
      id: 10,
      name: 'Class 6 Physics',
      correct: 213,
      incorrect: 107,
      unanswered: 680,
      total: 1000,
      correctPercentage: 213 / 1000 * 100,
      parent: 5,
      leaf: true,
    ),
    SubjectAnalyticsDto(
      id: 11,
      name: 'Class 6 Chemistry',
      correct: 100,
      incorrect: 67,
      unanswered: 833,
      total: 1000,
      correctPercentage: 100 / 1000 * 100,
      parent: 5,
      leaf: true,
    ),
  ];

  static List<SubjectAnalyticsDto> getSubjects({int? parentId}) {
    return allSubjects.where((s) => s.parent == parentId).toList();
  }

  static List<SubjectAnalyticsDto> getDonutCards({int? parentId}) {
    if (parentId == null) {
      // For root level, show the Chemistry sub-subjects in the donut cards section
      return allSubjects.where((s) => s.parent == 3).toList();
    }
    final children = allSubjects.where((s) => s.parent == parentId).toList();
    if (children.isEmpty) {
      return allSubjects.where((s) => s.id == parentId).toList();
    }
    return children;
  }
}
