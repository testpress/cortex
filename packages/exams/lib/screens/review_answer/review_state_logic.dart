import 'package:flutter/foundation.dart';
import '../../models/test_model.dart';

enum ReviewFilter { all, correct, incorrect, unanswered }

mixin ReviewStateLogic {
  Map<String, TestAttemptAnswer> get attemptStates;
  List<TestQuestion> get allQuestions;

  bool isAnswerCorrect(TestQuestion q) {
    final state = attemptStates[q.id];
    if (state == null || state.selectedOptions.isEmpty) return false;
    final selected = List<String>.from(state.selectedOptions)..sort();
    final correct = List<String>.from(q.correctOptionIds)..sort();
    return listEquals(selected, correct);
  }

  bool isUnanswered(TestQuestion q) {
    final state = attemptStates[q.id];
    return state == null || state.selectedOptions.isEmpty;
  }

  int countFor(ReviewFilter f) {
    if (f == ReviewFilter.all) return allQuestions.length;
    return allQuestions.where((q) {
      if (f == ReviewFilter.correct) return isAnswerCorrect(q);
      if (f == ReviewFilter.incorrect) {
        return !isAnswerCorrect(q) && !isUnanswered(q);
      }
      if (f == ReviewFilter.unanswered) return isUnanswered(q);
      return false;
    }).length;
  }

  List<TestQuestion> getFilteredQuestions(ReviewFilter activeFilter) {
    return allQuestions.where((q) {
      if (activeFilter == ReviewFilter.all) return true;
      if (activeFilter == ReviewFilter.correct) return isAnswerCorrect(q);
      if (activeFilter == ReviewFilter.incorrect) {
        return !isAnswerCorrect(q) && !isUnanswered(q);
      }
      if (activeFilter == ReviewFilter.unanswered) return isUnanswered(q);
      return true;
    }).toList();
  }
}
