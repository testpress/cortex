# doubt-thread-detail Specification

## Purpose
TBD - created by archiving change lms-doubt-detail. Update Purpose after archive.
## Requirements
### Requirement: Doubt Thread Header and Metadata
The system SHALL display the doubt's title and metadata (category, student name, and timestamp) in the detail screen header.
- **Lesson Context**: If the doubt is associated with a `lessonId`, the system SHALL fetch and display the corresponding lesson title to provide contextual information about where the doubt originated.

#### Scenario: Displaying doubt metadata
- **WHEN** the student opens a doubt from the list
- **THEN** the system shows the title, "Physics" category (or relevant), and "Asked 2h ago" metadata.

#### Scenario: Displaying lesson context
- **GIVEN** a doubt has an associated `lessonId`
- **WHEN** the student views the doubt details
- **THEN** the system SHALL display the lesson title in the header section

### Requirement: Plain-Text Content Rendering
The system SHALL render the doubt's description and its replies using an HTML/Rich-text rendering widget to support structural formatting, LaTeX mathematical equations, and embedded inline images.

#### Scenario: Viewing rich-text doubt body
- **WHEN** the doubt details screen is rendered
- **THEN** the system displays the content with rich formatting, LaTeX equations, and embedded inline images correctly formatted

### Requirement: Chronological Reply Thread
The system SHALL display all replies in chronological order, clearly distinguishing mentor replies with a "Mentor" badge and the mentor's avatar. 
- **AI Bot Identification**: If a reply has a `source` of "Bot" (or equivalent AI source), the system SHALL override the author's display name to "AI Bot Response".
- **Bot Mentor Badge**: If a reply has a `source` of "Bot" AND `isMentor` is true, the system SHALL display a "Bot" badge instead of the standard "Mentor" badge.

#### Scenario: Viewing AI Bot replies
- **WHEN** an AI Bot has responded to the doubt and `isMentor` is true
- **THEN** the reply appears in the thread with the display name "AI Bot Response" and a "Bot" badge instead of the usual author name and "Mentor" badge.

#### Scenario: Viewing mentor replies
- **WHEN** a human mentor has responded to the doubt
- **THEN** the reply appears in the thread with a "Mentor" badge and the author's actual name.

### Requirement: Multi-Format Attachment Display
The system SHALL display a list of attachments (Images/PDFs) associated with a doubt or a reply. PDFs SHALL be represented by a distinct icon and tappable to open.

#### Scenario: Opening a PDF attachment
- **WHEN** the student taps on a PDF attachment icon in the thread
- **THEN** the system opens the PDF using the `AppPdfViewer` or system handler.

### Requirement: High-Fidelity Loading States
The system SHALL implement `Skeletonizer` to display a shimmering placeholder of the thread structure while data is being fetched.

#### Scenario: Loading the doubt detail thread
- **WHEN** the screen is first opened and data is fetching
- **THEN** the system displays a skeleton layout of the title, body, and 2-3 mock replies.

### Requirement: Mark Resolved Action
The doubt thread detail screen SHALL provide an action for the student to resolve/close their doubt ONLY when the doubt has received at least one reply from a mentor (`isMentor == true`).
- **Eligibility**: If no reply with `isMentor == true` exists in the reply thread, the close/resolve action SHALL NOT be accessible to the student.
- **Action**: When eligible and active (not already closed), selecting the close doubt action and confirming SHALL submit the close request and update the status in the UI to closed.

#### Scenario: Attempting to close doubt without mentor reply
- **GIVEN** a student is viewing their active doubt details
- **AND** there are no replies with `isMentor == true` in the thread
- **WHEN** the student views the header actions
- **THEN** the close doubt action is not accessible

#### Scenario: Resolving a doubt after mentor reply
- **GIVEN** a student is viewing their active doubt details
- **AND** there is at least one reply with `isMentor == true` in the thread
- **WHEN** the student triggers the close action and confirms
- **THEN** the doubt close request is submitted and the status transitions to closed

