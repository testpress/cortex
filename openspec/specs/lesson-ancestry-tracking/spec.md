# lesson-ancestry-tracking Specification

## Purpose
TBD - created by archiving change scalable-hierarchical-filtering. Update Purpose after archive.
## Requirements
### Requirement: Automatic Ancestry Tagging
The system SHALL automatically populate a lesson's `ancestorChapterIds` list with the IDs of all parent chapters in its hierarchy branch.

#### Scenario: Navigating to a leaf chapter
- **WHEN** a user navigates from Course -> A -> B -> C -> D (Leaf)
- **THEN** the lessons inside D SHALL be persisted with `ancestorChapterIds = ",A,B,C,D,"` (comma-padded string for efficient LIKE queries).

### Requirement: Progressive Metadata Enrichment
The system SHALL update existing `ancestorChapterIds` for a lesson if new ancestor relationships are discovered through further navigation or synchronization.

#### Scenario: Discovering an intermediate chapter
- **WHEN** a lesson is initially saved with `ancestorChapterIds = ",A,D,"`
- **AND** the relationship `B is parent of C is parent of D` is discovered later
- **THEN** the lesson's `ancestorChapterIds` SHALL be updated to `",A,B,C,D,"`

### Requirement: Chapter Title Enrichment via Local Join
The system SHALL resolve missing chapter title metadata using a local `LEFT OUTER JOIN` with the `ChaptersTable` when displaying filter results.

#### Scenario: Displaying filter result cards
- **WHEN** the `/contents?type=video` endpoint returns lessons without `chapterTitle`
- **THEN** the system SHALL query the local `chaptersTable` for the title using the lesson's `chapterId`
- **AND** each lesson card SHALL display the correct chapter title instantly from local cache

