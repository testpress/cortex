import 'test_model.dart';

class ReviewRoutePayload {
  const ReviewRoutePayload({
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
  });

  final String assessmentTitle;
  final List<TestQuestion> questions;
  final Map<String, TestAttemptAnswer> attemptStates;
}
