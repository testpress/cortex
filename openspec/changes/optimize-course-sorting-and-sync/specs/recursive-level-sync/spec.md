## ADDED Requirements

### Requirement: Recursive one-level sync
The system SHALL proactively synchronize the contents of all immediate sub-chapters when a parent chapter is entered or a content filter is applied. This ensures that nested items (e.g., videos inside sub-folders) are visible to the user without requiring manual navigation into every sub-folder.

#### Scenario: Entering a parent chapter
- **WHEN** a user navigates to a `ChaptersListPage` with a non-null `parentId`
- **THEN** the system SHALL trigger a background sync for the immediate children of that parent ID

#### Scenario: Applying a content filter
- **WHEN** a user selects a filter (Videos, Assessments, Tests)
- **THEN** the system SHALL trigger a background sync for all immediate sub-chapters to ensure the filtered list is populated with nested content
