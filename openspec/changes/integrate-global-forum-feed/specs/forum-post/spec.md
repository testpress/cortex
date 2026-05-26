## MODIFIED Requirements

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
