# exam-engine Specification

## Purpose
TBD - created by archiving change offline-exam-support. Update Purpose after archive.
## Requirements
### Requirement: Global offline exam availability
The system SHALL assume all exams support offline mode natively without checking a specific backend flag.

#### Scenario: Viewing exam details
- **WHEN** the user navigates to the Exam Prescreen
- **THEN** the "Download Exam" workflow is always available.

### Requirement: Vertically stacked offline button on prescreen
The system SHALL display a vertically stacked button above the primary online action buttons on the Exam Prescreen.

#### Scenario: Exam is not downloaded yet
- **WHEN** the user views the prescreen of a non-downloaded exam
- **THEN** they see a [Download Exam] button above the Start/Resume/Retake buttons.

#### Scenario: Exam is downloaded
- **WHEN** the user views the prescreen of a downloaded exam
- **THEN** the button reads [Start offline exam].

### Requirement: Unified Exam Engine Architecture
The system SHALL abstract exam state management into a unified `ExamRepository` interface that handles state updates and interactions.

#### Scenario: Running an offline exam
- **WHEN** the UI requests to start, submit an answer, or switch a section
- **THEN** it communicates identically with the `ExamRepository`, which routes to an `OfflineExamRepository` (SQLite-backed, no heartbeats) instead of an `OnlineExamRepository` (API-backed, strict heartbeats) without the UI knowing the difference.

### Requirement: Decoupled Exam Downloading
The system SHALL NOT leak raw JSON parsing or dummy attempt creation logic into the UI widget.

#### Scenario: Downloading an exam
- **WHEN** the user clicks [Download Exam]
- **THEN** the UI simply invokes `downloadService.downloadExam(exam)`, and the service handles backend requests, data formatting, and caching securely.

