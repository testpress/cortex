## ADDED Requirements

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

## MODIFIED Requirements

### Requirement: Doubt Composition Form
The system SHALL provide a screen for users to compose and submit new academic doubts.
- **Fields**: Title (Plain Text), Category (Hierarchical Topic selection), and Question Content (Rich Text).
- **Validation**: Title, Category, and Content SHALL NOT be empty before submission is enabled.

#### Scenario: Submitting a valid doubt
- **GIVEN** the user has entered a title, selected a category, and provided content
- **WHEN** the user taps the "Post" button
- **THEN** the system SHALL validate the input and trigger the submission flow
