import 'package:flutter/foundation.dart';

@immutable
class QuestionnaireBlock {
  static const int minQuestions = 1;

  final List<int> subjects;
  final String subjectName; // For UI display on the summary card
  final int noOfQuestions;
  final List<String> difficultyLevels;
  final List<String> questionTypes;

  final List<String> difficultyLabels; // For UI display
  final List<String> questionTypeLabels; // For UI display

  const QuestionnaireBlock({
    required this.subjects,
    required this.subjectName,
    required this.noOfQuestions,
    this.difficultyLevels = const [],
    this.questionTypes = const [],
    this.difficultyLabels = const [],
    this.questionTypeLabels = const [],
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'no_of_questions': noOfQuestions};

    if (subjects.isNotEmpty) {
      json['subjects'] = subjects;
    }

    if (difficultyLevels.isNotEmpty) {
      json['difficulty_levels'] = difficultyLevels;
    }

    if (questionTypes.isNotEmpty) {
      json['question_types'] = questionTypes;
    }

    return json;
  }

  QuestionnaireBlock copyWith({
    List<int>? subjects,
    String? subjectName,
    int? noOfQuestions,
    List<String>? difficultyLevels,
    List<String>? questionTypes,
    List<String>? difficultyLabels,
    List<String>? questionTypeLabels,
  }) {
    return QuestionnaireBlock(
      subjects: subjects ?? this.subjects,
      subjectName: subjectName ?? this.subjectName,
      noOfQuestions: noOfQuestions ?? this.noOfQuestions,
      difficultyLevels: difficultyLevels ?? this.difficultyLevels,
      questionTypes: questionTypes ?? this.questionTypes,
      difficultyLabels: difficultyLabels ?? this.difficultyLabels,
      questionTypeLabels: questionTypeLabels ?? this.questionTypeLabels,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionnaireBlock &&
        listEquals(other.subjects, subjects) &&
        other.subjectName == subjectName &&
        other.noOfQuestions == noOfQuestions &&
        listEquals(other.difficultyLevels, difficultyLevels) &&
        listEquals(other.questionTypes, questionTypes) &&
        listEquals(other.difficultyLabels, difficultyLabels) &&
        listEquals(other.questionTypeLabels, questionTypeLabels);
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(subjects),
      subjectName,
      noOfQuestions,
      Object.hashAll(difficultyLevels),
      Object.hashAll(questionTypes),
      Object.hashAll(difficultyLabels),
      Object.hashAll(questionTypeLabels),
    );
  }
}
