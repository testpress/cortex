## ADDED Requirements

### Requirement: Learner can drill down into nested subjects
The system SHALL display subjects hierarchically and allow the learner to drill down into sub-subjects or select an "All" option at any level.

#### Scenario: Learner taps a parent subject with children
- **WHEN** the learner taps a subject that has children
- **THEN** the system immediately replaces the current chip list with the children of that subject along with an "All of [Parent]" option at the top

#### Scenario: Learner selects "All" at the root level
- **WHEN** the learner taps "All" at the root subject level
- **THEN** the system SHALL record an empty subjects array `[]` for this block, meaning no subject filter is applied

#### Scenario: Learner selects "All" inside a parent subject
- **WHEN** the learner has drilled into a parent subject and taps "All" at that level
- **THEN** the system SHALL record only the parent subject's ID in the subjects array for this block

#### Scenario: Learner selects a specific sub-subject or leaf subject
- **WHEN** the learner taps a leaf node or specific sub-subject that has no further children
- **THEN** the system SHALL record that subject's ID in the subjects array for this block

### Requirement: Learner can configure parameters for a selected subject
The system SHALL allow the learner to set the number of questions, difficulty levels, and question types for the currently selected subject before saving it as a block.

#### Scenario: Learner sets number of questions
- **WHEN** the learner interacts with the number of questions input
- **THEN** the system displays an input for the learner to enter a quantity

#### Scenario: Learner selects difficulty levels
- **WHEN** the learner interacts with the difficulty filter
- **THEN** the system displays multi-select chips for available difficulty options (Easy, Medium, Hard)

#### Scenario: Learner selects question types
- **WHEN** the learner interacts with the question type filter
- **THEN** the system displays multi-select chips for available question type options

#### Scenario: Learner leaves filters unselected
- **WHEN** the learner saves a block without selecting difficulty levels or question types
- **THEN** the system SHALL record empty arrays for those fields, meaning no restriction is applied

### Requirement: Learner can review and manage configured blocks
The system SHALL display a review section on the Builder screen showing all currently configured subject blocks, allowing the learner to remove blocks or add new ones.

#### Scenario: Learner views configured blocks
- **WHEN** the learner has saved at least one block
- **THEN** the screen displays a summary card for each block showing the subject name, question count, difficulty levels, and question types

#### Scenario: Learner adds another subject block
- **WHEN** the learner taps the "+ Add more subjects" button
- **THEN** the subject drill-down flow restarts from the root level

#### Scenario: Learner removes a block
- **WHEN** the learner taps the remove action on a block's summary card
- **THEN** the block is removed from the configuration list

### Requirement: Learner can select the exam mode before starting
The system SHALL present the learner with a mode selection step after all blocks are configured, allowing them to choose between Practice Quiz and Regular Exam before the test is created.

#### Scenario: Learner selects Practice Quiz mode
- **WHEN** the learner selects "Practice Quiz"
- **THEN** the system SHALL set `test_mode: "quiz"` in the POST payload

#### Scenario: Learner selects Regular Exam mode
- **WHEN** the learner selects "Regular Exam"
- **THEN** the system SHALL set `test_mode: "regular"` in the POST payload

## MODIFIED Requirements

### Requirement: Learner can open the Custom Exam Options screen
The system SHALL provide an entry point after course selection that opens the Custom Exam Builder screen when activated.

#### Scenario: Opening the Builder screen
- **WHEN** the learner selects a course for custom practice
- **THEN** the Custom Exam Builder screen opens showing an empty state with a prominent "+ Add Subject" call-to-action
