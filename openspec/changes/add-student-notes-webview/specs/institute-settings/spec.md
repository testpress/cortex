## ADDED Requirements

### Requirement: Institute Student Notes Settings
The system SHALL parse `student_notes_enabled` and `student_notes_label` from the institute settings payload and expose them on `InstituteSettings`.

#### Scenario: Student notes enabled in settings
- **WHEN** the `/api/v2.3/settings/` response contains `'student_notes_enabled': true` and `'student_notes_label': 'My Notebook'`
- **THEN** `InstituteSettings.studentNotesEnabled` evaluates to `true`
- **AND** `InstituteSettings.studentNotesLabel` evaluates to `'My Notebook'`

#### Scenario: Student notes absent in settings
- **WHEN** the `/api/v2.3/settings/` response omits `student_notes_enabled`
- **THEN** `InstituteSettings.studentNotesEnabled` defaults to `false`
- **AND** `InstituteSettings.studentNotesLabel` defaults to `null`
