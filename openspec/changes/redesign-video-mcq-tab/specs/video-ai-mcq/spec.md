# Spec Delta

## ADDED Requirements

### Requirement: Redesigned MCQ Tab Background and Layout
The system SHALL display flat white card backgrounds (`card`) across the initial card, loading state, and active quiz stepper, while framing the bottom action bar with the subtle surface background (`surface`).

#### Scenario: Viewing the initial or generating state
- **WHEN** the user views the MCQ tab in its ungenerated or loading state
- **THEN** the initial card or loading animation renders on a flat white background (`card`), while the docked action button is enclosed in the surface container (`surface`).

#### Scenario: Displaying header and progress bar
- **WHEN** the user views the active MCQ quiz
- **THEN** the system displays the header `"Practice Test"`, a pill badge with the question count, `"Question X of Y"`, `"N answered"`, and a linear progress bar reflecting overall answered progress.

### Requirement: Staged Option Selection and Check Answer Flow
The system SHALL allow learners to select an option without immediate validation, enabling evaluation only when the Check Answer button is tapped.

#### Scenario: Selecting an option without checking
- **WHEN** the user selects an option on an unanswered question
- **THEN** the option is highlighted with a radio selection indicator, no correctness status is revealed, and the Check Answer button becomes active.

#### Scenario: Tapping Check Answer
- **WHEN** the user taps the Check Answer button with an option selected
- **THEN** the system evaluates the selected option, highlights the answer as correct or incorrect, displays the explanation box, and disables option changes.

### Requirement: MCQ Stepper Navigation Buttons
The system SHALL provide prominent side-by-side Previous and Next action buttons for navigating between quiz questions.

#### Scenario: Navigating between questions
- **WHEN** the user taps Previous or Next
- **THEN** the system moves to the respective question and updates the progress indicator.

#### Scenario: Disabling previous on the first question
- **WHEN** the user is on the first question
- **THEN** the Previous button is disabled.

### Requirement: View All Questions Question Palette
The system SHALL provide a "View All Questions" trigger button and bottom sheet modal to view all questions and jump directly to any question.

#### Scenario: Opening question palette
- **WHEN** the user taps "View All Questions"
- **THEN** a bottom sheet displays a grid of question numbers with indicators for answered, current, and unanswered questions.

#### Scenario: Jumping to a question from palette
- **WHEN** the user taps a question number in the palette
- **THEN** the bottom sheet closes and the quiz navigates directly to that question.
