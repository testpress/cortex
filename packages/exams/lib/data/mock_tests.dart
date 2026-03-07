import '../models/test_model.dart';

class MockTestFactory {
  static Test createMockTest() {
    return const Test(
      id: 'test-1',
      title: 'Thermodynamics',
      subject: 'Physics',
      description: 'Test your understanding of thermodynamics concepts',
      totalQuestions: 30,
      timeLimitMinutes: 1,
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
          subject: 'Physics',
          type: QuestionType.mcq,
          options: [
            QuestionOption(id: 'a', text: '2.67 atm'),
            QuestionOption(id: 'b', text: '4 atm'),
            QuestionOption(id: 'c', text: '3 atm'),
            QuestionOption(id: 'd', text: '2 atm'),
          ],
          correctOptionIds: ['a'],
          explanation:
              'According to Gay-Lussac\'s Law, P1/T1 = P2/T2. Given P1 = 2 atm, T1 = 27°C = 300K, T2 = 127°C = 400K. \nP2 = P1 * (T2/T1) = 2 * (400/300) = 2.67 atm.',
        );
      } else {
        return TestQuestion(
          id: 'q-${i + 1}',
          number: i + 1,
          text:
              'Practice question ${i + 1} for Thermodynamics. This question helps evaluate core concepts of energy and heat transfer.',
          subject: 'Thermodynamics',
          type: QuestionType.mcq,
          options: const [
            QuestionOption(id: 'a', text: 'Option A'),
            QuestionOption(id: 'b', text: 'Option B'),
            QuestionOption(id: 'c', text: 'Option C'),
            QuestionOption(id: 'd', text: 'Option D'),
          ],
          correctOptionIds: const ['a'],
          explanation:
              'This is a sample explanation for practice question ${i + 1}. Energy is conserved in an isolated system.',
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
