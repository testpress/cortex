import 'package:flutter/foundation.dart';
import 'package:core/data/data.dart';

enum ReviewFilter { all, correct, incorrect, unanswered }

mixin ReviewStateLogic {
  Map<String, AnswerDto> get attemptStates;
  List<QuestionDto> get allQuestions;

  bool isAnswerCorrect(QuestionDto q) {
    final state = attemptStates[q.id];
    if (state != null && state.result != null) {
      final res = state.result!.toLowerCase();
      return res == 'correct' || res == '1';
    }
    if (state == null || state.selectedOptions.isEmpty) return false;
    final selected = List<String>.from(state.selectedOptions.map((e) => e.toString()))..sort();
    final correct = List<String>.from(
      (q.correctOptionIds.isNotEmpty
              ? q.correctOptionIds
              : q.options.where((option) => option.isCorrect).map((option) => option.id))
          .map((e) => e.toString()),
    )..sort();
    return listEquals(selected, correct);
  }

  bool isUnanswered(QuestionDto q) {
    final state = attemptStates[q.id];
    if (state != null && state.result != null) {
      final res = state.result!.toLowerCase();
      return res == 'unanswered' ||
          res == 'unvisited' ||
          res == '0' ||
          res == '3';
    }
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

  List<QuestionDto> getFilteredQuestions(ReviewFilter activeFilter) {
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
