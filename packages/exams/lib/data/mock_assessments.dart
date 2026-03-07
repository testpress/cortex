import '../models/assessment_model.dart';

class MockAssessmentFactory {
  static Assessment createMockAssessment() {
    return const Assessment(
      id: 'a1',
      title: 'First Law of Thermodynamics',
      description:
          'Test your understanding of energy conservation and heat transfer.',
      questionIds: ['q1', 'q2', 'q3', 'q4', 'q5'],
    );
  }

  static List<AssessmentQuestion> createMockQuestions() {
    return [
      const AssessmentQuestion(
        id: 'q1',
        text:
            'The First Law of Thermodynamics is essentially a statement of which conservation law?',
        type: AssessmentQuestionType.mcq,
        options: [
          AssessmentOption(id: 'o1', text: 'Conservation of Momentum'),
          AssessmentOption(id: 'o2', text: 'Conservation of Energy'),
          AssessmentOption(id: 'o3', text: 'Conservation of Mass'),
          AssessmentOption(id: 'o4', text: 'Conservation of Charge'),
        ],
        correctOptionIds: ['o2'],
        explanation:
            'The First Law of Thermodynamics (Law of Conservation of Energy) states that energy can neither be created nor destroyed; it can only be converted from one form to another. ΔU = Q - W',
      ),
      const AssessmentQuestion(
        id: 'q2',
        text: 'Which of the following processes are reversible?',
        type: AssessmentQuestionType.multipleSelect,
        options: [
          AssessmentOption(
            id: 'o5',
            text: 'Isothermal expansion of an ideal gas',
          ),
          AssessmentOption(id: 'o6', text: 'Sudden compression of a gas'),
          AssessmentOption(
            id: 'o7',
            text: 'Infinitely slow adiabatic compression',
          ),
          AssessmentOption(
            id: 'o8',
            text: 'Free expansion of a gas into a vacuum',
          ),
        ],
        correctOptionIds: ['o5', 'o7'],
        explanation:
            'Reversible processes occur infinitely slowly in equilibrium. Isothermal expansion of an ideal gas and infinitely slow adiabatic compression are reversible. Free expansion and sudden compression are irreversible.',
      ),
      const AssessmentQuestion(
        id: 'q3',
        text: 'In an adiabatic process, what remains constant?',
        type: AssessmentQuestionType.mcq,
        options: [
          AssessmentOption(id: 'o9', text: 'Temperature'),
          AssessmentOption(id: 'o10', text: 'Pressure'),
          AssessmentOption(id: 'o11', text: 'Heat exchange (Q=0)'),
          AssessmentOption(id: 'o12', text: 'Internal Energy'),
        ],
        correctOptionIds: ['o11'],
        explanation:
            'An adiabatic process is one in which there is no heat exchange between the system and its surroundings (Q = 0).',
      ),
      const AssessmentQuestion(
        id: 'q4',
        text:
            'What is the change in internal energy (ΔU) for a cyclic process?',
        type: AssessmentQuestionType.mcq,
        options: [
          AssessmentOption(id: 'o13', text: 'Greater than zero'),
          AssessmentOption(id: 'o14', text: 'Less than zero'),
          AssessmentOption(id: 'o15', text: 'Zero'),
          AssessmentOption(id: 'o16', text: 'Depends on the work done'),
        ],
        correctOptionIds: ['o15'],
        explanation:
            'In a cyclic process, the system returns to its initial state, so the change in internal energy (a state function) is zero.',
      ),
      const AssessmentQuestion(
        id: 'q5',
        text: 'Which of the following is NOT a state function?',
        type: AssessmentQuestionType.mcq,
        options: [
          AssessmentOption(id: 'o17', text: 'Internal Energy'),
          AssessmentOption(id: 'o18', text: 'Enthalpy'),
          AssessmentOption(id: 'o19', text: 'Work'),
          AssessmentOption(id: 'o20', text: 'Entropy'),
        ],
        correctOptionIds: ['o19'],
        explanation:
            'Work and Heat are path functions, meaning their values depend on the path taken between states. Internal Energy, Enthalpy, and Entropy are state functions.',
      ),
    ];
  }
}
