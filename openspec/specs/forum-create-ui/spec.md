# forum-create-ui Specification

## Purpose
TBD - created by archiving change lms-forum-create. Update Purpose after archive.
## Requirements
### Requirement: Render Composition Screen
The system SHALL provide a dedicated screen for composing new forum posts, as defined in the design reference. The screen MUST include:
- A single-line text input for the post title/topic.
- A multi-line rich text editor for the post description.
- A way to attach and preview images.
- "Cancel" and "Submit" actions.

#### Scenario: Navigating to creation screen
- **WHEN** user clicks "Create New Post" on the Forum list screen
- **THEN** the system SHALL navigate to the Forum Post Composition screen

### Requirement: Rich Text Formatting
The post description field SHALL support rich text formatting via a custom toolbar. Supported formats MUST include:
- Bold and Italics
- Unordered and Ordered lists
- Code blocks

#### Scenario: Applying formatting
- **WHEN** user selects text and clicks "Bold" in the toolbar
- **THEN** the system SHALL apply bold styling to the selected text

### Requirement: Image Attachment UI
The system SHALL allow users to attach up to 3 images to the post.
- Each attachment MUST display a preview chip or pill with a remove action.
- The attachment action MUST be disabled once the limit of 3 images is reached.

#### Scenario: Attaching an image
- **WHEN** user picks an image from the gallery
- **THEN** the image SHALL appear in the attachment preview section with a remove (X) button

### Requirement: Field Validation
The system SHALL validate the post content before allowing submission.
- The "Submit" button MUST be disabled if the Title or Description is empty.

#### Scenario: Disabled submit button
- **WHEN** the Title field is empty
- **THEN** the "Submit" button SHALL be disabled

### Requirement: Backend-Ready Category Selection
The system SHALL model categories with stable identifiers and payload labels.
- The selected category state MUST store only the category ID.
- The displayed category label MUST come from category payload data (mocked now, backend-provided later).
- Category data for the UI MUST be accessed through DataSource → Repository → Provider, not directly from mock constants in the screen.

#### Scenario: Selecting a category
- **WHEN** the user selects a category from the picker
- **THEN** the system SHALL update selected state using the category ID and display the matching payload label

#### Scenario: Switching mock to backend source
- **WHEN** category loading is switched from mock to HTTP source
- **THEN** the screen SHALL continue to work via the same provider contract without direct screen-level data source changes

### Requirement: Submission Feedback (UI Only)
Since backend integration is out of scope, the system SHALL simulate a successful submission by providing immediate UI feedback.

#### Scenario: Clicking Submit
- **WHEN** the user clicks "Submit" with valid fields
- **THEN** the system SHALL pop the current screen and return to the Forum list screen

