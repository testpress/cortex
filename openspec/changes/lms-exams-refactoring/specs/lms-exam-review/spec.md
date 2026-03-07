## ADDED Requirements

### Requirement: Package Boundary
The exam review and answer detail components MUST be implemented within the `exams` package to ensure proper code modularity.

#### Scenario: Implementation location
- **WHEN** the application is compiled
- **THEN** the exam review screen and related components are sourced from `package:exams` instead of `package:courses`
