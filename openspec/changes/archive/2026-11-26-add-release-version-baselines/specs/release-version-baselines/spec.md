## ADDED Requirements

### Requirement: Allocate release versions above supplied baselines

Cortex SHALL accept optional app version, Android version code, and iOS build number baselines for the selected app. Testpress SHALL apply the bump to the greater of each supplied baseline and its stored value.

#### Scenario: Migrated app uses a store baseline

- **WHEN** the workflow is dispatched with store values above the stored values
- **THEN** the build uses the app version and build counters allocated above those baselines

#### Scenario: A baseline is omitted or lower

- **WHEN** a baseline is omitted or lower than the stored value
- **THEN** Testpress applies the bump using the stored value

#### Scenario: A baseline is invalid

- **WHEN** a supplied baseline is invalid or the next version cannot fit its allowed range
- **THEN** the workflow rejects invalid inputs before calling Testpress
- **AND** Testpress rejects an allocation outside its supported range before persisting it

#### Scenario: The version response cannot be verified

- **WHEN** the version endpoint succeeds but returns invalid version fields or values below the required bump
- **THEN** the workflow stops before building
- **AND** it tells the operator to check the saved Cortex config before retrying
