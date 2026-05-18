# Exam Player Sections

Centralizes the active attempt state, orchestrates section-based logic, provides rollback recovery for user interactions, and fully localizes player visual content.

## Requirements

### Requirement: Stateful Section Navigation
The exam player SHALL dynamically parse and display a tab-switching header for each active exam section.

#### Scenario: Switches sections on tab select
- **WHEN** the user selects a section tab
- **THEN** it switches the active question view to the selected section's questions and updates the section timer state.

### Requirement: Heartbeat Server-Time Synchronization
The exam repository SHALL perform periodic background heartbeats to synchronize the countdown timer and persist user attempt state.

#### Scenario: Syncs remaining time correctly on heartbeat
- **WHEN** a background heartbeat response is received
- **THEN** it updates the repository's remaining time dynamically, shielding against client timer drift.

### Requirement: Optimistic Update Rollback
The exam repository SHALL rollback local answer state changes if a backend submission attempt fails.

#### Scenario: Rollback on network failure
- **WHEN** an answer submission API call fails
- **THEN** it SHALL revert the local attempt state to its prior valid configuration.

### Requirement: Visual String Localization
All user-facing UI strings in the exam player SHALL be resolved via localized resource lookups.

#### Scenario: Displays translated content
- **WHEN** rendering static buttons or labels
- **THEN** they SHALL pull values from context localizations, not raw literals.

### Requirement: Parallelized Question Loading
The network data source SHALL fetch paginated questions concurrently in parallel to minimize initial load time.

#### Scenario: Concurrent page retrieval
- **WHEN** the first page of questions is successfully retrieved and indicates multiple pages exist
- **THEN** the remaining pages SHALL be requested concurrently in parallel.

### Requirement: Debounced Answer Submissions
The exam repository SHALL debounce answer submission network calls per question while updating the local state optimistically.

#### Scenario: Option selected within debounce window
- **WHEN** user selects an option for a question
- **THEN** it SHALL update the local state immediately but delay the API request by a debounce duration.

#### Scenario: Multiple selections on the same question
- **WHEN** user changes options multiple times within the debounce window
- **THEN** only the final answer state SHALL be sent to the server.

#### Scenario: Flushing pending submissions
- **WHEN** the exam is ended or session is reset
- **THEN** any pending debounced answers SHALL be flushed and sent to the server immediately.
