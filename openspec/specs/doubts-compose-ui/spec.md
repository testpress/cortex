# doubts-compose-ui Specification

## Purpose
TBD - created by archiving change lms-ask-doubt-form. Update Purpose after archive.
## Requirements
### Requirement: Doubt Composition Form
The system SHALL provide a screen for users to compose and submit new academic doubts.
- **Fields**: Title (Plain Text), Category (Chip selection), and Question Content (Rich Text).
- **Validation**: Title and Content SHALL NOT be empty before submission is enabled.

#### Scenario: Submitting a valid doubt
- **GIVEN** the user has entered a title, selected a category, and provided content
- **WHEN** the user taps the "Post" button
- **THEN** the system SHALL validate the input and trigger the submission flow

### Requirement: Rich Text Editor
The system SHALL provide a rich-text editor for the doubt content to support structured questions.
- **Formatting**: The editor SHALL support bold, italic, bulleted lists, and code blocks.
- **Media**: The editor SHALL NOT be required to support inline media for this scope (attachments are handled separately).

#### Scenario: Applying formatting
- **WHEN** the user selects text and taps the "Bold" toolbar action
- **THEN** the selected text SHALL be rendered in bold weight

### Requirement: Attachment Preview Strip
The system SHALL display a horizontal scrollable strip of attached files (images/PDFs) before submission.
- **Interaction**: Users SHALL be able to remove an attachment by tapping a "Delete" icon on the preview card.

#### Scenario: Removing an attachment
- **GIVEN** the user has attached 3 images
- **WHEN** the user taps the "Delete" icon on the second image
- **THEN** that image SHALL be removed from the attachment list and the preview strip SHALL update

