# Capability: LMS Assessment Detail

## Purpose
The LMS Assessment Detail capability defines the practice-driven assessment experience, where users receive immediate feedback on their answers and can attempt questions multiple times within a single session.

## Requirements

### Requirement: 3-State Navigation Bar
The Assessment screen SHALL transition between three navigation states based on user interaction to guide the "Check and Learn" flow.

#### Scenario: Selection leads to check
- **WHEN** the user selects an answer option for the first time
- **THEN** the system SHALL hide the "Previous" and "Next" navigation buttons.
- **AND** it SHALL show a high-visibility "Check Answer" action button.

#### Scenario: Feedback restores navigation
- **WHEN** the user clicks "Check Answer"
- **THEN** the system SHALL restore the "Previous" and "Next" buttons.
- **AND** it SHALL display the correct/incorrect feedback for the selection.

### Requirement: Amber Feedback for Incorrect Answers
Incorrect answers SHALL be presented using a non-punitive amber color scheme to encourage further attempts.

#### Scenario: Incorrect feedback style
- **WHEN** an incorrect answer is checked
- **THEN** the system SHALL display a feedback block with amber background, brown text, and an amber border.
- **AND** it SHALL provide a "Try Again" action within that feedback block.

### Requirement: Question Palette Visuals
The question palette in Assessment mode SHALL provide clear visual confirmation of correct and incorrect attempts across the entire question set.

#### Scenario: Palette indicators
- **WHEN** viewing the palette legend
- **THEN** it SHALL show "Correct" (green check), "Incorrect" (red X), and "Unanswered" (gray outline).
- **AND** grid items representing questions SHALL be rendered as rounded squares.
- **AND** the currently viewed question SHALL be highlighted with a green success ring.
