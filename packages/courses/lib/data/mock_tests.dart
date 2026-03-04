import '../models/test_model.dart';

class MockTestFactory {
  static Test createMockTest() {
    return const Test(
      id: 'test-1',
      title: 'Thermodynamics',
      subject: 'Physics',
      description: 'Test your understanding of thermodynamics concepts',
      totalQuestions: 30,
      timeLimitMinutes: 40,
    );
  }

  static List<TestQuestion> createMockQuestions() {
    return List.generate(30, (i) {
      if (i == 0) {
        return const TestQuestion(
          id: 'q-1',
          number: 1,
          text:
              'A gas in a closed container is heated from 27°C to 127°C. If the initial pressure was 2 atm, what will be the final pressure? (Assume constant volume)',
          type: QuestionType.mcq,
          options: [
            QuestionOption(id: 'a', text: '2.67 atm'),
            QuestionOption(id: 'b', text: '4 atm'),
            QuestionOption(id: 'c', text: '3 atm'),
            QuestionOption(id: 'd', text: '2 atm'),
          ],
        );
      } else {
        return TestQuestion(
          id: 'q-${i + 1}',
          number: i + 1,
          text:
              'Practice question ${i + 1} for Thermodynamics. This question helps evaluate core concepts of energy and heat transfer.',
          type: QuestionType.mcq,
          options: const [
            QuestionOption(id: 'a', text: 'Option A'),
            QuestionOption(id: 'b', text: 'Option B'),
            QuestionOption(id: 'c', text: 'Option C'),
            QuestionOption(id: 'd', text: 'Option D'),
          ],
        );
      }
    });
  }

  /// This simulates a server-side scoring key that is NEVER sent to the client
  /// during the active test phase.
  static Map<String, List<String>> createScoringKey() {
    return {
      'q-1': ['a'],
      for (int i = 1; i < 30; i++) 'q-${i + 1}': ['a'],
    };
  }
}
