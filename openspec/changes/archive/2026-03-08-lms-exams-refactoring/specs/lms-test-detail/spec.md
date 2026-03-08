## ADDED Requirements

### Requirement: Package Boundary
The test detail component MUST be implemented within the `exams` package to ensure proper code modularity.

#### Scenario: Implementation location
- **WHEN** the application is compiled
- **THEN** the test detail screen and related components are sourced from `package:exams` instead of `package:courses`
