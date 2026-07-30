## ADDED Requirements

### Requirement: MCQ Tab Visibility
The system SHALL display an MCQ subtab in the video player only if the lesson is AI-enabled.

#### Scenario: AI-enabled lesson
- **WHEN** a user loads a video with `is_ai_enabled: true` and `learnlens_asset_status: "Completed"`
- **THEN** the system displays the MCQ subtab alongside the AI Chat tab.

### Requirement: AI MCQ Generation
The system SHALL generate multiple-choice questions for the video using the LearnLens Quiz API.

#### Scenario: Generating questions successfully
- **WHEN** the user navigates to the MCQ tab for the first time
- **THEN** the system calls the LearnLens Quiz API using the cached session token and renders the returned questions as an interactive quiz.

#### Scenario: Handling empty quiz results
- **WHEN** the Quiz API returns an empty list of questions
- **THEN** the system displays a placeholder message indicating no questions could be generated.
