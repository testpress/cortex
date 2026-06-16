# Session-related autoDispose provider lifecycle

Purpose: Specify the lifecycle behavior of list providers and sync metadata across sessions and logouts.

## Requirements

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

#### Scenario: Sync metadata lifecycle persistence

- **WHEN** `CourseList`, `ExamList`, or `InfoList` are unmounted and disposed during tab switching
- **THEN** their corresponding root-scoped sync metadata providers SHALL remain alive and preserve their last sync timestamps
- **AND** subsequent navigation back to the screens SHALL NOT trigger redundant network syncs if a sync has already occurred in the session

#### Scenario: Session-based synchronization guard

- **WHEN** `initialize()` is called on a list provider
- **THEN** it SHALL check if the corresponding sync metadata provider is non-null
- **AND** if the metadata indicates a sync has already occurred during the current session, it SHALL return immediately and skip the network sync
