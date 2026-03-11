## Requirements

### Requirement: Logic-Feature Allocation
Repositories, State Providers, and domain-specific logic must reside within the same package as the UI they serve. 

#### Scenario: Relocate Logic
- **WHEN** a feature provider or repository is used
- **THEN** it is imported from its local domain package (e.g., `package:courses/`) instead of a central data package.

### Requirement: Unified Foundation in Core
The `core` package must serve as the single "lingua franca" providing shared Models (DTOs) and common infrastructure (Database, Auth).

#### Scenario: Shared Model Access
- **WHEN** multiple modules need a common model (e.g., `UserDto`)
- **THEN** they import it from `package:core/data/` to maintain a flat dependency graph.

### Requirement: Domain Isolation
Feature packages must remain independent of each other. 

#### Scenario: Preventing Circularity
- **WHEN** a feature needs a shared resource
- **THEN** it accesses it via `core`, ensuring that changing one feature does not necessitate rebuilding another.
