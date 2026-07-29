# custom-exam-options-screen Specification

## Purpose
TBD - created by archiving change custom-exam-support. Update Purpose after archive.
## Requirements
### Requirement: Learner can open the Custom Exam Options screen
The system SHALL provide an entry point after course selection that opens the Custom Exam Builder screen when activated.

#### Scenario: Opening the Builder screen
- **WHEN** the learner selects a course for custom practice
- **THEN** the Custom Exam Builder screen opens showing an empty state with a prominent "+ Add Subject" call-to-action

### Requirement: Learner can set the practice scope
The system SHALL allow the learner to choose between practising the full course or selecting a specific course.

#### Scenario: Full course selected
- **WHEN** the learner selects "Full course practice" as the practice scope
- **THEN** no additional course selection is required

#### Scenario: Select course chosen
- **WHEN** the learner selects "Select course" as the practice scope
- **THEN** a floating bottom sheet appears allowing them to search and select from all enrolled courses

---

### Requirement: Learner can select a course
The system SHALL allow the learner to select which course the custom practice exam is based on.

#### Scenario: Course selection
- **WHEN** the course selection bottom sheet is visible
- **THEN** the learner can search for and tap a course to select it

#### Scenario: Course is required for specific course scope
- **WHEN** the learner attempts to proceed with "Select course" scope without actually picking a course
- **THEN** the primary action remains inactive or the learner is prevented from proceeding

---

### Requirement: Learner can choose the question source
The system SHALL allow the learner to specify where questions are drawn from.

#### Scenario: Question source selection
- **WHEN** the Custom Exam Options screen is displayed
- **THEN** the learner can choose a question source from the options shown

---

### Requirement: Learner can set the number of questions
The system SHALL allow the learner to specify how many questions the practice exam will contain.

#### Scenario: Number of questions input
- **WHEN** the learner interacts with the number of questions option
- **THEN** the learner can specify the number of questions for the exam

---

### Requirement: Learner can set the difficulty level
The system SHALL allow the learner to choose the difficulty level of questions.

#### Scenario: Difficulty level selection
- **WHEN** the learner taps the difficulty level option
- **THEN** available difficulty levels are presented for selection

---

### Requirement: Learner can choose the attempt mode
The system SHALL allow the learner to choose between Test mode and Quiz mode before starting.

#### Scenario: Test mode selected
- **WHEN** the learner selects Test mode
- **THEN** the exam session will be configured as a test

#### Scenario: Quiz mode selected
- **WHEN** the learner selects Quiz mode
- **THEN** the exam session will be configured as a quiz

---

### Requirement: Learner can start the exam after configuring options
The system SHALL provide a primary action that confirms the configuration and initiates the custom practice exam session.

#### Scenario: Starting the exam
- **WHEN** the learner activates the primary action with all required options set
- **THEN** the custom practice exam session begins

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

