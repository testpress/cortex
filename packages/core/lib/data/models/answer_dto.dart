/// Answer DTO — plain object for submitting answers to the backend.
class AnswerDto {
  final String questionId;
  final List<String> selectedOptions;
  final bool isMarked;

  const AnswerDto({
    required this.questionId,
    required this.selectedOptions,
    this.isMarked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'selected_options': selectedOptions,
      'is_marked': isMarked,
    };
  }
}
