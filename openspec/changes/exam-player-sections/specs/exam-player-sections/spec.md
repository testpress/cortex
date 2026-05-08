## ADDED Requirements

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
