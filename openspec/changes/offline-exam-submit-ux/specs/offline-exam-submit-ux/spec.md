## ADDED Requirements

### Requirement: Offline submission toast
The system SHALL display an ephemeral, context-neutral `AppToast` immediately when a user submits an offline exam without an active internet connection. The toast SHALL NOT convey success or failure — only confirmation that the exam was saved locally and will sync automatically.

#### Scenario: Submit with no internet
- **WHEN** the user confirms exam submission via the submit confirmation dialog in offline mode
- **AND** the device has no active internet connection at the moment of submission
- **THEN** `endExam()` completes (status → `PENDING_SYNC`)
- **AND** an `AppToast` is shown with a localised message (key: `offlineExamSavedToast`) before the result view appears

#### Scenario: Submit with internet present
- **WHEN** the user confirms exam submission in offline mode
- **AND** the device has an active internet connection
- **THEN** no additional toast is shown (the sync will proceed automatically via `SyncManager`; the result view appears normally)

---

### Requirement: Reactive status badge in downloads list
The exam card badge in `OfflineExamsListScreen` SHALL reactively reflect the current download status for each exam, updating without a page reload.

#### Scenario: Exam is downloaded and not started
- **WHEN** an exam card is rendered with status `DOWNLOADED`
- **THEN** the badge shows a green "Downloaded" indicator (existing behaviour, unchanged)

#### Scenario: Exam is in progress
- **WHEN** an exam card is rendered with status `IN_PROGRESS`
- **THEN** the badge shows a blue/accent "In Progress" indicator

#### Scenario: Exam is pending sync
- **WHEN** an exam card is rendered with status `PENDING_SYNC`
- **THEN** the badge shows an amber/warning "Syncing…" indicator with a circular progress spinner

#### Scenario: Exam has been synced
- **WHEN** an exam card is rendered with status `SYNCED`
- **THEN** the badge shows a green "Submitted ✓" indicator

---

### Requirement: Retain download record after successful sync
After a successful API submission, the system SHALL update the download row's status to `SYNCED` and record `syncedAt` timestamp. The row SHALL NOT be deleted.

#### Scenario: Sync succeeds
- **WHEN** `OfflineExamSyncService.syncPendingExams()` successfully calls the API for a `PENDING_SYNC` exam
- **THEN** the row status is updated to `SYNCED`
- **AND** `syncedAt` is set to the current UTC time
- **AND** the row remains in the `OfflineExamDownloadsTable`
- **AND** the exam card in `OfflineExamsListScreen` updates to show the "Submitted ✓" badge

#### Scenario: Sync fails with permanent 4xx error
- **WHEN** `OfflineExamSyncService` receives a 4xx response (excluding 401, 408, 429)
- **THEN** the row is deleted (existing permanent-failure behaviour, unchanged)

#### Scenario: Sync fails with transient error
- **WHEN** `OfflineExamSyncService` receives a 5xx or network error
- **THEN** the row remains `PENDING_SYNC` for retry on next connectivity change (existing retry behaviour, unchanged)

---

### Requirement: SYNCED database status and syncedAt column
The `OfflineExamDownloadsTable` SHALL support a `SYNCED` status value and a nullable `syncedAt` datetime column. The database schema version SHALL be bumped to accommodate the migration.

#### Scenario: New install
- **WHEN** the app is installed fresh
- **THEN** the table is created with `syncedAt` column and supports `SYNCED` status from the start

#### Scenario: Upgrade from schema version 1
- **WHEN** the app is upgraded from a version with schema version 1
- **THEN** the `onUpgrade` migration adds the `syncedAt` column to `OfflineExamDownloadsTable` without data loss
- **AND** existing rows have `syncedAt = null` after migration

---

### Requirement: New l10n key for submission toast
The system SHALL provide a localised string `offlineExamSavedToast` for the submission toast message in all supported locales (English, Tamil, Malayalam, Arabic).

#### Scenario: English locale
- **WHEN** the toast is shown in an English locale
- **THEN** the message reads: `"Exam saved. It will be submitted automatically when you're back online."`

#### Scenario: Other locales
- **WHEN** the toast is shown in a non-English locale
- **THEN** the message is displayed in the device locale using the translated ARB string
