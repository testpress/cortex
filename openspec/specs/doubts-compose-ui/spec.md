# doubts-compose-ui Specification

## Purpose
TBD - created by archiving change lms-ask-doubt-form. Update Purpose after archive.
## Requirements
### Requirement: Doubt Composition Form
The system SHALL provide a screen for users to compose and submit new academic doubts.
- **Fields**: Title (Plain Text), Category (Hierarchical Topic selection), and Question Content (Rich Text).
- **Validation**: Title, Category, and Content SHALL NOT be empty before submission is enabled.
- **Navigation (Success)**: Upon successful submission, the system SHALL dismiss the form and navigate the user to the newly created doubt's detail screen.
- **Navigation (Failure)**: Upon a submission error, the system SHALL dismiss the form and display an error toast message on the underlying screen.

#### Scenario: Submitting a valid doubt successfully
- **GIVEN** the user has entered a title, selected a category, and provided content
- **WHEN** the user submits the doubt and the API responds successfully
- **THEN** the system SHALL dismiss the doubt composition form and navigate to the newly created doubt detail screen

#### Scenario: Submitting a doubt fails
- **GIVEN** the user submits the doubt
- **WHEN** the API responds with an error
- **THEN** the system SHALL dismiss the doubt composition form and show an error toast message

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

### Requirement: Hierarchical Topic Selection
The doubt composition form SHALL allow the student to select a category topic via a hierarchical drill-down menu picker.
- **API Fetching**: The picker SHALL fetch top-level topics from `/api/v2.5/helpdesk/topics/?parent_id=null`. If a topic has `has_children: true`, tapping it SHALL dynamically load and display its subtopics by querying the topics endpoint with the selected topic's `parent_id`.
- **Validation**: Only a leaf topic (one with `has_children: false`) SHALL be selectable as the doubt's topic.

#### Scenario: Selecting a subtopic
- **GIVEN** the student is on the topic selection sheet
- **WHEN** they tap a topic that has subtopics
- **THEN** the picker fetches and displays the subtopics recursively

### Requirement: Attachment File Upload
The system SHALL support uploading attached image files individually to the `/api/v3/upload-image/` endpoint before submitting the doubt form.
- **Parameters**: The upload request SHALL be `multipart/form-data` with `image` containing the file and `uploaded_for` set to `"doubts"`.
- **HTML Embedding**: On successful upload, the returned URL SHALL be formatted as an HTML `<img>` tag and appended to the description/content body.

#### Scenario: Uploading and embedding image
- **GIVEN** the student attaches an image file
- **WHEN** the image is successfully uploaded
- **THEN** an `<img src="<url>" />` tag is inserted into the rich text editor

