## ADDED Requirements

### Requirement: Resume Paused Exam Attempt
The system SHALL check for a paused attempt using the `paused_attempts_count` field from the Exam API. If an attempt is paused, the CTA SHALL be updated to allow resuming, and the system SHALL fetch the running attempt and start the exam from where it left off instead of creating a new attempt. The `AttemptDto` SHALL map the attempt's `state` field correctly to ensure running attempts (state == "Running") are identified.

#### Scenario: Existing paused attempt
- **WHEN** an exam has `paused_attempts_count > 0`
- **THEN** the Prescreen CTA displays "Resume Exam Online"
- **THEN** tapping the CTA triggers the attempt's start URL and restores the session
- **THEN** the fetched attempt object MUST contain a valid non-null `state` string corresponding to its progress state

#### Scenario: Paused attempts count is non-zero but attempts list is empty
- **WHEN** `paused_attempts_count > 0` but fetching attempts returns an empty list
- **THEN** the system SHALL fall back to creating a new attempt instead of throwing a StateError



### Requirement: Pause Confirmation Dialog
The system SHALL intercept exit navigation during an active exam to prevent accidental loss of context. A confirmation dialog MUST be presented before safely exiting and pausing the exam.

#### Scenario: Accidental back navigation
- **WHEN** the user presses the system back button or exit icon during an exam
- **THEN** a dialog appears asking if they want to pause the exam
- **THEN** clicking "Cancel" keeps them in the exam
- **THEN** clicking "Pause" exits the exam screen and pauses the attempt

### Requirement: Option Selection Indicator Rendering
The system SHALL ensure that custom HTML option selection indicators (radio buttons and checkboxes) in the active question card WebView are rendered correctly and not stripped out during HTML post-processing / clean-up.

#### Scenario: Rendering Exam Question Options
- **WHEN** a question card is rendered in the WebView (AppHtml)
- **THEN** the radio buttons and checkboxes MUST be fully visible and functional in the options list.

### Requirement: Subject Mapping Preservation
The system SHALL request attempt questions by substituting `v2.3` with `v2.2.1` in the questions endpoint URL. This ensures correct subject name groupings are returned for all questions, enabling proper subject/section tab bar rendering, matching the legacy Android SDK behavior.

#### Scenario: Fetching Questions in Exam Attempt
- **WHEN** a questions endpoint containing `v2.3` is invoked to load questions for an active attempt
- **THEN** the request SHALL instead be translated to `v2.2.1` before execution
- **THEN** the response questions MUST map correct subject names (e.g. "PHYSICS", "CHEMISTRY", "BIOLOGY") instead of "Uncategorized", unlocking the subject tabs

### Requirement: Exam Settings Preservation
The temporary `ExamDto` instantiated for course-linked attempts MUST preserve settings such as `disableAttemptResume`, `allowRetake`, and `maxRetakes` from the active lesson and cached exam metadata.

### Requirement: Option Selection Indicator Parent Preservation
The system SHALL protect parent wrapper elements (like empty divs or paragraphs) of `.indicator` elements from being stripped out during HTML cleanup by querying if they contain any `.indicator` descendants.


