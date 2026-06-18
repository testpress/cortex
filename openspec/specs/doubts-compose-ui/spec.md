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

### Requirement: Hierarchical Topic Selection
The doubt composition form SHALL allow the student to select a category topic via an inline hierarchical drill-down menu.
- **API Fetching**: The picker SHALL fetch top-level topics from `/api/v2.5/helpdesk/topics/` by passing no `parent_id`. If a topic has `has_children: true`, tapping it SHALL dynamically replace the current list and load its subtopics by querying the topics endpoint with the selected topic's `parent_id`.
- **Navigation**: The picker SHALL provide a clickable breadcrumb navigation (e.g., `Topics > Math`) to allow users to navigate back up the hierarchy.
- **I don't know Fallback**: Every level SHALL include an "I don't know" option. Selecting "I don't know" SHALL finalize the selection using the parent ID of the current level (or null if at the root level).
- **Validation**: Any leaf topic (`has_children: false`) OR the "I don't know" option at any level SHALL be selectable as the final doubt's topic.

#### Scenario: Drilling down to a subtopic
- **GIVEN** the student is viewing the root topics
- **WHEN** they tap a topic that has `has_children: true`
- **THEN** the picker replaces the root chips with the subtopics of the tapped topic
- **AND** a breadcrumb is displayed to allow navigation back to root topics

#### Scenario: Using I don't know fallback
- **GIVEN** the student has drilled down into "Physics"
- **WHEN** they tap the "I don't know" chip
- **THEN** the topic selection is finalized
- **AND** the selected topic ID is set to the ID of "Physics"

