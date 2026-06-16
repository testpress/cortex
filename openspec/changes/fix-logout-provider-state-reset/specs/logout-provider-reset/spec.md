## ADDED Requirements

### Requirement: Session-related autoDispose provider lifecycle

The system SHALL use `autoDispose` for session-related list providers (`CourseList`, `ExamList`, `InfoList`), ensuring they are disposed when their views are unmounted.

#### Scenario: Teardown on logout

- **WHEN** the user logs out and the router redirects to an unauthenticated route
- **THEN** the authenticated screens SHALL be unmounted
- **AND** Riverpod SHALL automatically dispose `CourseList`, `ExamList`, and `InfoList` providers
- **AND** no in-memory feed or cache state for these list providers SHALL survive across sessions

#### Scenario: Resetting sync metadata on auth change

- **WHEN** the user logs out or the authentication state changes
- **THEN** the root-scoped sync metadata providers SHALL automatically reset to `null` by watching `authProvider`
- **AND** on subsequent login, they SHALL begin with their default uninitialized states
- **AND** the screen initialization SHALL trigger fresh network syncs since the sync metadata is empty
