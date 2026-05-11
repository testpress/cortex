## ADDED Requirements

### Requirement: Doubt Thread Header and Metadata
The system SHALL display the doubt's title and metadata (category, student name, and timestamp) in the detail screen header.

#### Scenario: Displaying doubt metadata
- **WHEN** the student opens a doubt from the list
- **THEN** the system shows the title, "Physics" category (or relevant), and "Asked 2h ago" metadata.

### Requirement: Plain-Text Content Rendering
The system SHALL render the original doubt content and all mentor replies using a plain-text component (`AppText.bodySmall`) to simplify the view.

#### Scenario: Viewing plain-text doubt body
- **WHEN** the doubt contains text content
- **THEN** the system displays the text cleanly as plain text without complex formatting.

### Requirement: Chronological Reply Thread
The system SHALL display all replies in chronological order, clearly distinguishing mentor replies with a "Mentor" badge and the mentor's avatar.

#### Scenario: Viewing mentor replies
- **WHEN** a mentor has responded to the doubt
- **THEN** the reply appears in the thread with a "Mentor" badge and the author's name.

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
