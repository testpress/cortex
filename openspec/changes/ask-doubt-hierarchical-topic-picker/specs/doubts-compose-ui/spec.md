## MODIFIED Requirements

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

## REMOVED Requirements

### Requirement: Attachment Preview Strip
**Reason**: To simplify the Ask Doubt form and reduce storage overhead.
**Migration**: Attachments are no longer supported.

### Requirement: Attachment File Upload
**Reason**: To simplify the Ask Doubt form.
**Migration**: Attachments are no longer uploaded or embedded in the doubt.
