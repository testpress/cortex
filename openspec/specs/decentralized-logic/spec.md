# Decentralized Architectural Logic

## Purpose
Define the rules and standards for allocating DTOs, repositories, providers and mock data across the mono-repo, ensuring clear ownership and maintaining clean dependency flow (features -> core).

## Requirements

### Requirement: Feature Data Ownership
Feature-specific DTOs, repositories, providers, and mock data MUST reside within their respective feature packages (e.g., `packages/courses`).

#### Scenario: Relocating feature DTOs
- **WHEN** a DTO is used only by a specific feature (e.g., `TestDto` for exams)
- **THEN** it resides in that feature's `models/` folder and is exported by the package barrel file.

### Requirement: Shared Infrastructure in Core
The `core` package MUST provide only shared infrastructure (Auth, Database, cross-feature DTOs like `UserDto`).

#### Scenario: Shared Model Access
- **WHEN** a model is used across multiple independent features (e.g., identity/auth models)
- **THEN** it stays in `core` to prevent cross-feature dependencies.

### Requirement: Dependency Direction
Dependencies MUST flow from features to core. Feature packages SHOULD NOT depend on each other unless strictly necessary (e.g., a dashboard consuming data from multiple domains).

#### Scenario: Consuming feature data
- **WHEN** a feature needs data from another domain (e.g., dashboard showing tests)
- **THEN** it depends on that feature package directly, adhering to the standard package dependency mechanism.
