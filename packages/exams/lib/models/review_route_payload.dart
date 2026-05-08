import 'package:core/data/data.dart';

class ReviewRoutePayload {
  const ReviewRoutePayload({
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
  });

  final String assessmentTitle;
  final List<QuestionDto> questions;
  final Map<String, AnswerDto> attemptStates;
}
