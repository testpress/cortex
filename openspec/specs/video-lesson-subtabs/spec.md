# video-lesson-subtabs Specification

## Purpose
Specifies the behavior of dynamic subtabs (Notes, Transcript, Ask Doubt, AI Support) in the video lesson details.

## Requirements

### Requirement: Dynamic Video Subtabs Display
The system SHALL dynamically determine and render the subtabs in `VideoLessonDetailScreen` based on API-provided flags for the video lesson.

#### Scenario: All features enabled
- **WHEN** `is_ai_enabled` is true, `enable_transcript` is true, and `ai_notes_url` is not empty
- **THEN** the system MUST display all 4 tabs: "Notes", "Transcript", "Ask Doubt", and "AI Support"

#### Scenario: Transcript and AI disabled
- **WHEN** `is_ai_enabled` is false and `enable_transcript` is false
- **THEN** the system MUST display only "Ask Doubt" tab

#### Scenario: Only AI enabled without notes url
- **WHEN** `is_ai_enabled` is true, `ai_notes_url` is empty, and `enable_transcript` is false
- **THEN** the system MUST display "Ask Doubt" and "AI Support" tabs, but NOT "Notes" or "Transcript"

#### Scenario: Only Transcript enabled
- **WHEN** `is_ai_enabled` is false and `enable_transcript` is true
- **THEN** the system MUST display "Transcript" and "Ask Doubt" tabs

---

### Requirement: Transcript Rendering States
The system SHALL display the transcription status in the Transcript tab.

#### Scenario: Transcription in progress
- **WHEN** `enable_transcript` is true but `job_status` in `video_subtitle` is NOT "COMPLETED" (e.g. "IN_PROGRESS" or null)
- **THEN** the system MUST display a localized message "Transcription in progress" in the Transcript tab

#### Scenario: Transcription completed
- **WHEN** `enable_transcript` is true and `job_status` in `video_subtitle` is "COMPLETED"
- **THEN** the system MUST fetch the VTT file from `url` in `video_subtitle` and display the parsed subtitles

---

### Requirement: AI Notes Rendering
The system SHALL render Markdown content fetched from `ai_notes_url` in the Notes tab.

#### Scenario: Load and render markdown notes
- **WHEN** the Notes tab is active and `ai_notes_url` is valid
- **THEN** the system MUST fetch the `.md` content via HTTP GET
- **AND** render it properly in the UI with a scrollable view

---

### Requirement: Video Subtabs Performance and Scrolling
The system SHALL ensure that tab switching and scrolling are buttery smooth and do not cause rebuild lag or nested scrolling conflicts.

#### Scenario: Switching tabs does not rebuild or reload states
- **WHEN** the user switches between any of the subtabs ("Notes", "Transcript", "Ask Doubt", "AI Support")
- **THEN** the active tab's scroll position, fetched data, and widget state MUST be preserved (using keep-alive)
- **AND** the transition between tabs MUST be instantaneous without showing shimmers or triggering new network calls.

#### Scenario: Scrolling notes and transcripts is highly responsive
- **WHEN** the user scrolls the "Notes" or "Transcript" content
- **THEN** the scrolling MUST be smooth without any lag or frame drops
- **AND** the inner scroll view MUST support proper physics coordinating smoothly with the parent NestedScrollView.

---

### Requirement: Prevent Tab Insertion Flickering
The system SHALL NOT render the video viewer and tabs until the full lesson details are fetched, preventing a layout jump where only one tab is shown initially before the others appear.

#### Scenario: Waiting for detailed metadata
- **WHEN** the video lesson is first loaded from the database without detailed metadata (`isDetailFetched` is false)
- **THEN** the lesson's `isComplete` check MUST return false
- **AND** the orchestrator MUST show a loading indicator instead of rendering the viewer
- **WHEN** the lesson detail is fetched from the API and `isDetailFetched` becomes true
- **THEN** the orchestrator SHALL render the viewer, displaying all dynamic tabs immediately at once.
