# custom-exam-options-screen Specification

## Purpose
TBD - created by archiving change custom-exam-support. Update Purpose after archive.
## Requirements
### Requirement: Learner can open the Custom Exam Options screen
The system SHALL provide an entry point on the Exams screen that opens the Custom Exam Options screen when activated.

#### Scenario: Opening the screen
- **WHEN** the learner uses the entry point on the Exams screen
- **THEN** the Custom Exam Options screen opens as a full-page route

---

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

