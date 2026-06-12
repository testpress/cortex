## MODIFIED Requirements

### Requirement: Dynamic Video Subtabs Display
The system SHALL dynamically determine and render the subtabs in `VideoLessonDetailScreen` and `VideoLessonViewer` based on API-provided flags for the video lesson. The "Ask Doubt" tab SHALL ALWAYS be rendered as a supported subtab.

#### Scenario: All features enabled
- **WHEN** `is_ai_enabled` is true, `enable_transcript` is true, and `ai_notes_url` is not empty
- **THEN** the system MUST display all 4 tabs: "Notes", "Transcript", "Ask Doubt", and "AI Support"

#### Scenario: Transcript and AI disabled
- **WHEN** `is_ai_enabled` is false and `enable_transcript` is false
- **THEN** the system MUST display only the "Ask Doubt" tab

#### Scenario: Only AI enabled without notes url
- **WHEN** `is_ai_enabled` is true, `ai_notes_url` is empty, and `enable_transcript` is false
- **THEN** the system MUST display "Ask Doubt" and "AI Support" tabs, but NOT "Notes" or "Transcript"

#### Scenario: Only Transcript enabled
- **WHEN** `is_ai_enabled` is false and `enable_transcript` is true
- **THEN** the system MUST display "Transcript" and "Ask Doubt" tabs
