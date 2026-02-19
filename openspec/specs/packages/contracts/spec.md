# Capability: Package Contracts

## ADDED Requirements

### Requirement: Dependency Boundary Enforcement

The monorepo must maintain strict boundaries between SDK modules and the consumer application.

#### Scenario: App importing internal modules

- **WHEN** code is written in the `app/` directory
- **THEN** it must ONLY import `package:testpress`
- **AND** it must NOT import `package:core` or `package:courses` directly

### Requirement: SDK Aggregation

The `testpress` package must serve as the single public entry point for the SDK, aggregating and re-exporting internal module APIs.

#### Scenario: Exposing a new component to consumers

- **WHEN** a new component is added to `courses` or `core`
- **THEN** it must be explicitly re-exported in `package:testpress/`
- **AND** internal files must remain hidden from external consumers
