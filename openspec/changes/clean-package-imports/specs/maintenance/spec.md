## ADDED Requirements

### Requirement: Import Block Hygiene
The codebase SHALL not contain unused or redundant import directives.

#### Scenario: Clean Analysis
- **WHEN** running `dart analyze`
- **THEN** no `unused_import`, `unnecessary_import`, or `unused_shown_name` warnings SHALL be reported for the cleaned files.
