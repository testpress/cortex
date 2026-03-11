# decentralized-logic Specification

## Purpose
TBD - created by archiving change decentralize-feature-logic. Update Purpose after archive.
## Requirements
### Requirement: Logic-Feature Allocation
The system SHALL ensure that Repositories, State Providers, and domain-specific logic reside within the same package as the UI they serve. 

#### Scenario: Relocate Logic
- **WHEN** a feature provider or repository is used
- **THEN** it is imported from its local domain package (e.g., `package:courses/`) instead of a central data package.

### Requirement: Unified Foundation in Core
The system SHALL use the `core` package as the single "lingua franca" providing shared Models (DTOs) and common infrastructure (Database, Auth).

#### Scenario: Shared Model Access
- **WHEN** multiple modules need a common model (e.g., `UserDto`)
- **THEN** they import it from `package:core/data/` to maintain a flat dependency graph.

### Requirement: Domain Isolation
Feature packages SHALL remain independent of each other without cross-feature imports.

#### Scenario: Preventing Circularity
- **WHEN** a feature needs a shared resource
- **THEN** it accesses it via `core`, ensuring that changing one feature does not necessitate rebuilding another.

#### Scenario: Local DTO Ownership
- **WHEN** a feature needs a domain DTO (e.g., `RecentActivityDto` for the profile feed)
- **THEN** it MUST access its own types; no feature should reach into another feature package for internal types.

#### Scenario: Upcoming Test Feed
- **WHEN** the dashboard needs upcoming tests
- **THEN** the data MUST come from course-owned DTOs/mock data or `core` (never from `package:exams`), so the home surface stays self-contained.

### Requirement: Robust Exam Mocks
The `exams` package SHALL provide a fully populated thermodynamics mock exam to keep the shell’s practice surface realistic.

#### Scenario: Thermodynamics Practice
- **WHEN** the thermodynamics mock test is used
- **THEN** the dataset MUST include at least 30 illustrated questions (MCQ/multiple-select/true-false) covering laws of thermodynamics, engines, entropy, and phase change.

