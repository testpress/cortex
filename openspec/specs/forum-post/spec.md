# forum-post Specification

## Purpose
TBD - created by archiving change lms-forum-main. Update Purpose after archive.
## Requirements
### Requirement: Thread Browsing Context
The system SHALL default to global thread browsing instead of course-isolated thread browsing.

#### Scenario: User opens forum from main menu
- **WHEN** a user navigates to Discussion Forum
- **THEN** the system SHALL show global threads from all contexts
- **AND** the list SHALL be rendered in a unified feed

### Requirement: Detail and Comments Identity
The system SHALL use slug for thread route identity and numeric thread id for comments retrieval.

#### Scenario: User opens thread and views comments
- **WHEN** user opens `/home/discussions/forum/posts/:slug`
- **THEN** thread detail SHALL resolve by slug from available list/cache context
- **AND** comments SHALL be fetched using numeric `threadId`

### Requirement: Social Metadata
The system SHALL display social metadata and authorship as per the design reference.

#### Scenario: Displaying thread summary
- **WHEN** the thread list is rendered
- **THEN** each item SHALL display metadata (voting scores, reply counts, and author details) following the design reference.

### Requirement: Resolution Indicators
The system SHALL indicate thread resolution states as per the design reference.

#### Scenario: Identifying thread status
- **WHEN** a thread has an 'answered' or 'unanswered' status
- **THEN** the UI SHALL render the appropriate status indicator as defined in the design reference.

### Requirement: Thread Sorting and Filtering UI
The system SHALL provide horizontal tabs for sorting and a Bottom Sheet for advanced filtering.

#### Scenario: User navigates sorting tabs
- **WHEN** the user views the forum feed
- **THEN** the system SHALL display sorting tabs (Recent, Most Liked, Most Viewed) above the category chips
- **AND** tapping a tab SHALL update the feed order accordingly

#### Scenario: User opens filter bottom sheet
- **WHEN** user taps the filter icon on the thread list
- **THEN** the system SHALL open a Bottom Sheet containing Activity filters

