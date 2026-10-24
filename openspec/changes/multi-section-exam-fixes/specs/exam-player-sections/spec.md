## MODIFIED Requirements

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


### Requirement: Clear Question Response
The exam player SHALL provide an explicit action to clear selected answers on an active question.

#### Scenario: User clears an active response
- **WHEN** the current question has one or more selected options
- **THEN** the exam player SHALL display a "Clear Response" action that, when tapped, unselects all options, updates local state, and syncs an empty response to the server.
