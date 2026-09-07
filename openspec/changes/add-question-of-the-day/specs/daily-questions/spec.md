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
