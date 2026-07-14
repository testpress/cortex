# custom-exam Specification

## Purpose
TBD - created by archiving change integrate-custom-exam. Update Purpose after archive.
## Requirements
### Requirement: Course Selection for Custom Exam
The system SHALL display a list of eligible courses (where `allow_custom_test=true`) when the user initiates the custom exam flow.

#### Scenario: User opens custom exam feature
- **WHEN** user taps the Custom Exam FAB in the Exam tab or the App Drawer
- **THEN** system fetches eligible courses and displays them in a selection list

#### Scenario: Fetched courses are not persisted
- **WHEN** the system fetches eligible courses
- **THEN** it SHALL NOT store these courses in the local database

### Requirement: Custom Exam Configuration Retrieval
The system SHALL retrieve the custom exam configuration parameters for a specifically selected course.

#### Scenario: User selects an eligible course
- **WHEN** user selects a course from the eligible courses list
- **THEN** system fetches the configuration from `/api/v3/courses/<course_id>/custom-test-config/` and proceeds to the configuration screen

### Requirement: Custom Exam Parameter Selection
The system SHALL allow the user to select filters such as subjects, difficulty levels, and question types based on the retrieved course configuration.

#### Scenario: User configures exam parameters
- **WHEN** user is on the configuration screen
- **THEN** system displays dropdowns or selection chips for available subjects, difficulties, and question types

### Requirement: Question Count Restriction
The system SHALL restrict the user from requesting more questions than the `max_questions_per_test` defined in the configuration.

#### Scenario: User sets question count
- **WHEN** user adjusts the number of questions slider/input
- **THEN** the maximum value is strictly capped at `max_questions_per_test`

### Requirement: Attempt Limit Enforcement
The system SHALL display the remaining daily and monthly attempts and prevent generation if either limit is exhausted.

#### Scenario: Limits are exhausted
- **WHEN** user reaches the configuration screen and `daily_attempts_available` or `monthly_attempts_available` is 0
- **THEN** system displays a locked state with a descriptive error message explaining why they cannot generate a test

#### Scenario: Limits are available
- **WHEN** user reaches the configuration screen and has attempts > 0
- **THEN** system allows them to configure and press the Generate button

### Requirement: Custom Exam Generation
The system SHALL submit the user's selected configuration to generate the custom exam and handle the backend response appropriately.

#### Scenario: User submits generation request
- **WHEN** user presses the Generate button with valid selections
- **THEN** system sends the configuration payload to the backend and navigates to the resulting exam state based on the response

