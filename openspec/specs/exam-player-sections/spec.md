# Exam Player Sections

## Purpose
Centralizes the active attempt state, orchestrates section-based logic, provides rollback recovery for user interactions, and fully localizes player visual content.
## Requirements
### Requirement: Stateful Section Navigation
The exam player SHALL dynamically parse and display a tab-switching header for each active exam section, respecting sectional lock enforcement.

#### Scenario: Switches sections on tab select
- **WHEN** the user selects a section tab in an exam without sectional locks
- **THEN** it switches the active question view to the selected section's questions and updates the section timer state.

#### Scenario: Locked tab select during sectional lock
- **WHEN** the attempt has active sectional locks (`hasSectionalLock == true`) and the user views the section tabs
- **THEN** inactive section tabs SHALL be disabled and unclickable, preventing manual switching until the active section timer ends.

#### Scenario: Last question navigation during sectional lock without preemptive ending
- **WHEN** the attempt has active sectional locks (`hasSectionalLock == true`), `allow_preemptive_section_ending == false`, and the user is on the last question of an active non-final section with remaining time
- **THEN** the exam player SHALL NOT display a manual "Next Section" button or allow early transition to the next section until the section timer reaches `00:00`.

#### Scenario: Final section submission during sectional lock without preemptive ending
- **WHEN** the attempt has active sectional locks (`hasSectionalLock == true`), `allow_preemptive_section_ending == false`, and the user is on the final section with remaining time
- **THEN** the exam player SHALL disable the "Finish" action and prevent manual early submission until the final section timer reaches `00:00`, whereupon the exam automatically completes and submits.

#### Scenario: Section navigation during sectional lock with preemptive ending enabled
- **WHEN** the attempt has active sectional locks (`hasSectionalLock == true`) and `allow_preemptive_section_ending == true`
- **THEN** the exam player SHALL enable the "Next Section" action on the last question of intermediate sections and the "Finish" action on the final section, allowing the learner to advance or submit early.

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

### Requirement: Clear Question Response
The exam player SHALL provide an explicit action to clear selected answers on an active question.

#### Scenario: User clears an active response
- **WHEN** the current question has one or more selected options
- **THEN** the exam player SHALL display a "Clear Response" action that, when tapped, unselects all options, updates local state, and syncs an empty response to the server.

