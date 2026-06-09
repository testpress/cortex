# doubt-thread-detail Specification

## Purpose
TBD - created by archiving change lms-doubt-detail. Update Purpose after archive.
## Requirements
### Requirement: Doubt Thread Header and Metadata
The system SHALL display the doubt's title and metadata (category, student name, and timestamp) in the detail screen header.

#### Scenario: Displaying doubt metadata
- **WHEN** the student opens a doubt from the list
- **THEN** the system shows the title, "Physics" category (or relevant), and "Asked 2h ago" metadata.

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
The doubt thread header or detail screen SHALL provide a button for the student to resolve their doubt.
- **Action**: Tapping "Mark Resolved" SHALL submit a POST request to `/api/v3/helpdesk/<pk>/followup/` with the body `{"should_resolve": true}` and update the status in the UI to "Resolved".

#### Scenario: Resolving a doubt
- **GIVEN** the student is viewing their active doubt details
- **WHEN** they tap "Mark Resolved"
- **THEN** the ticket is resolved on the backend and the status in the app transitions to "Resolved"

