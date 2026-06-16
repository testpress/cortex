## MODIFIED Requirements

### Requirement: Filtering Courses for Exams

The system SHALL filter the list of courses specifically for the Exams tab based on backend tags and device permissions, and SHALL trigger a fresh sync whenever a new authenticated session starts.

#### Scenario: Exams sync triggered on session creation

- **WHEN** a new authenticated session starts and the `ExamsScreen` mounts
- **THEN** the newly instantiated `ExamList` notifier's `initialize()` method SHALL be called
- **AND** since `examSyncMetadataProvider` is reset to `null` for the new session, a real network sync for exam-tagged courses SHALL be triggered

#### Scenario: Guard reset on logout

- **WHEN** the user logs out
- **THEN** the `ExamList` notifier instance SHALL be fully disposed
- **AND** the `examSyncMetadataProvider` state SHALL be reset to `null`
- **AND** on subsequent login, the new `ExamList` instance's pagination tracking and the sync metadata SHALL start completely clean
- **AND** the subsequent navigate/sync sequence SHALL load fresh exam data
