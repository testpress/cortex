## ADDED Requirements

### Requirement: Immersive Video Player
The system SHALL display a custom video player overlay with playback controls, volume, full-screen toggle, speed adjustments, and offline download capabilities.

#### Scenario: User adjusting playback speed
- **WHEN** the user accesses the speed menu
- **THEN** they SHALL be able to select from 0.5x to 2.0x playback speeds

#### Scenario: Fullscreen playback
- **WHEN** the user taps the full-screen button
- **THEN** the video player SHALL resize to fill the device screen horizontally, hiding the tab navigation until returning

### Requirement: Tab Navigation
The system SHALL provide a swipeable tabbed interface beneath the video player featuring: Notes, Transcripts, Ask Doubt, and AI Support.

#### Scenario: Switching to Transcripts
- **WHEN** the user selects the Transcripts tab
- **THEN** the system SHALL display a list of timestamped captions from the video

#### Scenario: Downloading Notes
- **WHEN** the user navigates to the Notes tab and taps "Download PDF"
- **THEN** the system SHALL download the lecture notes onto the device

### Requirement: Ask Doubt Forum
The system SHALL provide an interactive space within the video interface for students to post doubts and view replies from instructors or peers.

#### Scenario: Submitting a doubt
- **WHEN** the user types a message in the doubt text area and submits
- **THEN** their doubt SHALL be added to the top of the "Recent Doubts" list with a pending status

### Requirement: AI Study Assistant
The system SHALL feature an AI chat assistant within a dedicated tab.

#### Scenario: Chatting with AI
- **WHEN** the user asks a question in the AI Support tab
- **THEN** they SHALL receive an instant, contextually relevant response related to the video lesson

### Requirement: Lesson Sequential Navigation
The system SHALL allow continuous learning through lesson progression.

#### Scenario: Continuing to next lesson
- **WHEN** the user taps the "Continue to Next Lesson" button at the bottom
- **THEN** the system SHALL navigate to the next sequence item within the same chapter

### Requirement: Dynamic Lesson Metadata
The system SHALL display current lesson progress and optional metadata dynamically from the lesson model.

#### Scenario: Displaying lesson progress
- **WHEN** the user views a video lesson
- **THEN** the system SHALL display "Lesson X of Y" based on the lesson's sequence data
- **AND** it SHALL show "?" if the data is missing

#### Scenario: Conditional subtitle rendering
- **WHEN** a lesson has a subtitle defined
- **THEN** the system SHALL display it below the title
- **ELSE** it SHALL hide the subtitle area to maximize screen space

### Requirement: Interactive Input Feedback
The system SHALL provide real-time feedback for user text input in learning support tabs.

#### Scenario: Real-time character counting
- **WHEN** the user types in the "Ask Doubt" text area
- **THEN** the system SHALL update the character count display (e.g., "12/500") instantly

### Requirement: Resilient Data Migrations (Technical)
The system SHALL ensure database stability during upgrades by using idempotent migration strategies.

#### Scenario: Safe column addition
- **WHEN** a database migration attempts to add a column that already exists
- **THEN** the system SHALL skip the addition gracefully instead of failing with an exception
