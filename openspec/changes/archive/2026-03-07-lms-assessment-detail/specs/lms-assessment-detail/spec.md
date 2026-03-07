## ADDED Requirements

### Requirement: 3-State Navigation Bar
The Assessment screen SHALL transition between three navigation states based on user interaction.
- State 1 (Idle): "Previous" and "Next" buttons are visible.
- State 2 (Active Selection): "Previous" and "Next" ARE NOT visible; a single "Check Answer" button is shown.
- State 3 (Check Complete): "Previous" and "Next" are visible; for incorrect answers, "Try Again" is also shown.

#### Scenario: User selects an option
- **WHEN** the user selects an answer option for the first time
- **THEN** the "Previous" and "Next" buttons SHALL disappear
- **AND** a "Check Answer" button SHALL appear at the bottom of the screen

#### Scenario: User checks answer
- **WHEN** the user clicks "Check Answer"
- **THEN** "Previous" and "Next" buttons SHALL reappear
- **AND** feedback for the current answer SHALL be displayed

### Requirement: Amber Feedback for Incorrect Answers
Incorrect answers SHALL be highlighted using an amber-based color scheme (`design.subjectPalette[6]`) to denote "Not quite right" rather than a critical error.

#### Scenario: User provides incorrect answer
- **WHEN** an incorrect answer is checked
- **THEN** a feedback block SHALL appear with amber background, brown text, and an amber border
- **AND** a "Try Again" button SHALL be present within the feedback block

### Requirement: Question Palette Visuals
The question palette SHALL display a summary of question states using rounded square tiles and a comparative legend.

#### Scenario: Open Palette
- **WHEN** the palette is triggered
- **THEN** a vertical legend SHALL show "Correct" (green check), "Incorrect" (red X), and "Unanswered" (gray outline)
- **AND** the grid items SHALL use rounded square shapes
- **AND** the currently selected question SHALL be highlighted with a green success ring
