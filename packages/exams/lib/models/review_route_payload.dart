import 'package:core/data/data.dart';

class ReviewRoutePayload {
  const ReviewRoutePayload({
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
    this.attempt,
  });

  final String assessmentTitle;
  final List<QuestionDto> questions;
  final Map<String, AnswerDto> attemptStates;
  final AttemptDto? attempt;
}
