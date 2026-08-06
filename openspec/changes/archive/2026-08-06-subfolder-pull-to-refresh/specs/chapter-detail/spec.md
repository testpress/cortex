## MODIFIED Requirements

### Requirement: Chapter Content List
The system SHALL display a vertical list of all learning items (lessons, assessments, tests) belonging to a specific chapter. The screen SHALL support pull-to-refresh, allowing users to manually re-sync the chapter's content and status data at any time.
- For exam and assessment items (`LessonType.test`, `LessonType.assessment`), the system SHALL render a green circular completion badge on the card's trailing side when the item's `hasAttempts` field is `true`.

#### Scenario: Chapter detail displays items
- **WHEN** the user opens the chapter detail page
- **THEN** the system displays a list of lesson titles, their types, and secondary information (e.g., duration)

#### Scenario: Completed exam shows badge
- **WHEN** the user opens the chapter detail page and an exam item has `hasAttempts == true`
- **THEN** the system renders a green tick badge on that exam card, positioned on the top-right corner of the left-hand thumbnail image, overlapping its boundary

#### Scenario: Pulling to refresh chapter content
- **WHEN** the user pulls down from the top of the chapter detail lesson list
- **THEN** the system SHALL show the standard refresh indicator
- **AND** the system SHALL re-run `syncChapterContents` and `refreshContentStatuses` for the current chapter
- **AND** the lesson list SHALL update to reflect the latest data once the sync completes

#### Scenario: Pulling to refresh shows existing content while syncing
- **WHEN** the user triggers a pull-to-refresh on the chapter detail page
- **THEN** the existing lesson list SHALL remain visible during the sync
- **AND** no skeleton loading state SHALL be shown (unlike the initial load)
