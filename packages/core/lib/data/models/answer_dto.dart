class AnswerDto {
  final String questionId;
  final List<int> selectedAnswers;
  final bool review;
  final String? result;
  final String? shortText;
  final String? essayText;

  bool get isMarked => review;
  List<String> get selectedOptions =>
      selectedAnswers.map((e) => e.toString()).toList();

  AnswerDto({
    required this.questionId,
    required List<dynamic> selectedOptions,
    bool? isMarked,
    bool review = false,
    this.result,
    this.shortText,
    this.essayText,
  }) : review = review || (isMarked ?? false),
       selectedAnswers = selectedOptions
           .map((e) => int.tryParse(e.toString()) ?? 0)
           .where((id) => id != 0)
           .toList();

  Map<String, dynamic> toJson() {
    return {
      'selected_answers': selectedAnswers,
      'review': review,
      'result': result,
      if (shortText != null) 'short_text': shortText,
      if (essayText != null) 'essay_text': essayText,
    };
  }
}
