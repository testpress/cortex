## ADDED Requirements

### Requirement: Daily Questions Overview and Interactive Quiz
The system SHALL provide dedicated native screens to display the Question of the Day overview and interactive quiz stepper.

#### Scenario: Overview Screen
- **WHEN** the user navigates to `/qotd`
- **THEN** the system MUST display the daily questions overview screen with the completion gauge, date, and CTA to start/resume or view solutions.

#### Scenario: Interactive Quiz Stepper
- **WHEN** the user starts the quiz
- **THEN** the system MUST render questions using `AppHtmlV2` with MathJax SVG decoding.
- **AND** it MUST show a unified question metadata pill (`[Subject • Difficulty • Type]`) above the question text.
- **AND** it MUST display the single question progress in `AppHeader` with a top-aligned back button.

#### Scenario: Dynamic Data Model Parsing
- **WHEN** `QotdDto` parses question payloads from the API
- **THEN** it MUST dynamically extract subject, difficulty, and question type without hardcoding defaults.
- **AND** `InstituteSettings` MUST correctly parse the `qotd_enabled` boolean field.

### Requirement: Online-Only Repository Operations
The system SHALL query daily questions and submit answers directly against the network API without local Drift caching, ensuring daily reset states and answer evaluations are strictly governed by the backend.

#### Scenario: Real-Time Network State
- **WHEN** the user opens the overview or submits an answer
- **THEN** `QotdRepository` MUST communicate directly with `DataSource` without persisting attempts to local database tables.

#### Scenario: Solution Review Navigation
- **WHEN** the user closes the quiz after reviewing solutions without submitting new answers
- **THEN** the system MUST return immediately to the overview without invalidating provider cache or making network calls.
