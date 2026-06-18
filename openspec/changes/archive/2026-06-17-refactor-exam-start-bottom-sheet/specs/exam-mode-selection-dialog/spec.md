## MODIFIED Requirements

### Requirement: Quiz Mode Eligibility Detection
The system SHALL detect quiz-capable exams from the exam metadata and only present mode selection inline options when quiz mode is enabled.

#### Scenario: Quiz mode disabled
- **WHEN** the exam metadata does not enable quiz mode
- **THEN** the system SHALL show the exam start bottom sheet without mode selection options
- **AND** the start button SHALL be enabled by default to start in regular mode.

#### Scenario: Quiz mode enabled
- **WHEN** the exam metadata enables quiz mode
- **THEN** the system SHALL show the mode selection options inline inside the exam start bottom sheet.

### Requirement: Mode Selection Dialog
The system SHALL present exactly two inline choices for mode selection directly within the exam start bottom sheet: Regular Mode and Quiz Mode.

#### Scenario: No selection disables start
- **WHEN** the exam supports both modes and no option is selected
- **THEN** the start/resume exam button SHALL be disabled.

#### Scenario: Regular mode selection
- **WHEN** the user selects Regular Mode
- **THEN** the system SHALL enable the start/resume exam button to start the exam in regular mode.

#### Scenario: Quiz mode selection
- **WHEN** the user selects Quiz Mode
- **THEN** the system SHALL enable the start/resume exam button to start the exam in quiz mode.
