import '../models/test_dto.dart';
import '../models/test_model.dart';

/// Mock tests.
const mockTests = [
  TestDto(
    id: '1',
    title: 'Weekly Mock Test - Physics',
    time: 'Tomorrow, 9:00 AM',
    duration: '3 hours',
    type: TestType.mock,
    isImportant: true,
  ),
  TestDto(
    id: '2',
    title: 'Chapter Test - Organic Chemistry',
    time: 'Jan 5, 2:00 PM',
    duration: '1.5 hours',
    type: TestType.chapter,
  ),
  TestDto(
    id: '3',
    title: 'Calculus Practice Test',
    time: 'Jan 6, 10:00 AM',
    duration: '2 hours',
    type: TestType.practice,
  ),
];

class MockTestFactory {
  static Test createMockTest() {
    return const Test(
      id: 'mock-test-1',
      title: 'Weekly Mock Test - Physics',
      subject: 'Physics',
      description: 'Comprehensive mock test covering Thermodynamics and Mechanics.',
      totalQuestions: 5,
      timeLimitMinutes: 180,
    );
  }

  static List<TestQuestion> createMockQuestions() {
    return [
      const TestQuestion(
        id: 'q1',
        number: 1,
        text: 'What is the SI unit of thermodynamic temperature?',
        subject: 'Physics',
        type: QuestionType.mcq,
        options: [
          QuestionOption(id: 'o1', text: 'Celsius'),
          QuestionOption(id: 'o2', text: 'Fahrenheit'),
          QuestionOption(id: 'o3', text: 'Kelvin'),
          QuestionOption(id: 'o4', text: 'Rankine'),
        ],
        correctOptionIds: ['o3'],
        explanation: 'Kelvin is the primary unit of temperature in the International System of Units (SI).',
      ),
      const TestQuestion(
        id: 'q2',
        number: 2,
        text: 'Newton\'s Second Law of Motion relates force, mass, and what?',
        subject: 'Physics',
        type: QuestionType.mcq,
        options: [
          QuestionOption(id: 'o5', text: 'Velocity'),
          QuestionOption(id: 'o6', text: 'Acceleration'),
          QuestionOption(id: 'o7', text: 'Displacement'),
          QuestionOption(id: 'o8', text: 'Time'),
        ],
        correctOptionIds: ['o6'],
        explanation: 'F = ma, where F is force, m is mass, and a is acceleration.',
      ),
    ];
  }
}
