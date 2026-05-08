class AnswerDto {
  final String questionId;
  final List<int> selectedAnswers;
  final bool review;

  bool get isMarked => review;
  List<String> get selectedOptions => selectedAnswers.map((e) => e.toString()).toList();

  AnswerDto({
    required this.questionId,
    required List<dynamic> selectedOptions,
    bool? isMarked,
    bool review = false,
  }) : review = review || (isMarked ?? false),
       selectedAnswers = selectedOptions
            .map((e) => int.tryParse(e.toString()) ?? 0)
            .where((id) => id != 0)
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'selected_answers': selectedAnswers,
      'review': review,
    };
  }
}
