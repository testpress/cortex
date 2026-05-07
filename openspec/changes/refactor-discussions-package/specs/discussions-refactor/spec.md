## ADDED Requirements

### Requirement: Package Renaming
The system SHALL use the `discussions` package for all asynchronous communication logic, ensuring a unified namespace for both Forum and Doubts.

#### Scenario: Verify Namespace
- **WHEN** searching for discussion-related logic
- **THEN** it SHALL be found within the `packages/discussions` directory

### Requirement: Import Consistency
All internal and external references to the discussion features SHALL use the updated `package:discussions/` namespace.

#### Scenario: Cross-Package Import
- **WHEN** the `testpress` package imports a discussion screen
- **THEN** it SHALL use `import 'package:discussions/discussions.dart';`
