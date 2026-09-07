import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

part 'qotd_quiz_controller.g.dart';

/// Holds all mutable quiz state for a QOTD session.
class QotdQuizState {
  final int currentIndex;
  final Map<int, Set<int>> selectedOptionIds;
  final Map<int, bool> isSubmittedMap;
  final Map<int, QotdSubmitResponseDto> submitResponses;
  final bool isSubmitting;

  const QotdQuizState({
    this.currentIndex = 0,
    this.selectedOptionIds = const {},
    this.isSubmittedMap = const {},
    this.submitResponses = const {},
    this.isSubmitting = false,
  });

  QotdQuizState copyWith({
    int? currentIndex,
    Map<int, Set<int>>? selectedOptionIds,
    Map<int, bool>? isSubmittedMap,
    Map<int, QotdSubmitResponseDto>? submitResponses,
    bool? isSubmitting,
  }) {
    return QotdQuizState(
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionIds: selectedOptionIds ?? this.selectedOptionIds,
      isSubmittedMap: isSubmittedMap ?? this.isSubmittedMap,
      submitResponses: submitResponses ?? this.submitResponses,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

@riverpod
class QotdQuizController extends _$QotdQuizController {
  @override
  QotdQuizState build({
    required List<QotdDto> questions,
    required int initialIndex,
  }) {
    final selectedOptions = <int, Set<int>>{};
    final submittedMap = <int, bool>{};
    final responses = <int, QotdSubmitResponseDto>{};

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      if (q.pastAttempt != null) {
        submittedMap[i] = true;
        responses[i] = q.pastAttempt!;
        if (q.pastAttempt!.selectedAnswerIds.isNotEmpty) {
          selectedOptions[i] = q.pastAttempt!.selectedAnswerIds.toSet();
        }
      }
    }

    return QotdQuizState(
      currentIndex: initialIndex,
      selectedOptionIds: selectedOptions,
      isSubmittedMap: submittedMap,
      submitResponses: responses,
    );
  }

  void selectOption(
    int questionIndex,
    int optionId, {
    bool isMultiple = false,
  }) {
    if (state.isSubmittedMap[questionIndex] == true || state.isSubmitting) {
      return;
    }

    final currentSelected =
        state.selectedOptionIds[questionIndex] ?? const <int>{};
    final Set<int> updated;

    if (isMultiple) {
      if (currentSelected.contains(optionId)) {
        updated = Set<int>.from(currentSelected)..remove(optionId);
      } else {
        updated = {...currentSelected, optionId};
      }
    } else {
      updated = {optionId};
    }

    state = state.copyWith(
      selectedOptionIds: {...state.selectedOptionIds, questionIndex: updated},
    );
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  Future<void> submitCurrentAnswer(BuildContext context) async {
    final index = state.currentIndex;
    final currentQ = questions[index];
    final selectedOptionIds = state.selectedOptionIds[index];
    if (selectedOptionIds == null || selectedOptionIds.isEmpty) return;

    state = state.copyWith(isSubmitting: true);

    try {
      final repository = ref.read(qotdRepositoryProvider);
      final result = await repository.submitAttempt(
        questionId: currentQ.id,
        optionIds: selectedOptionIds.toList(),
      );

      state = state.copyWith(
        submitResponses: {...state.submitResponses, index: result},
        isSubmittedMap: {...state.isSubmittedMap, index: true},
        isSubmitting: false,
      );
    } catch (e) {
      state = state.copyWith(isSubmitting: false);
      if (context.mounted) {
        AppToast.show(
          context,
          message: 'Failed to submit answer: $e',
          isError: true,
        );
      }
    }
  }
}
