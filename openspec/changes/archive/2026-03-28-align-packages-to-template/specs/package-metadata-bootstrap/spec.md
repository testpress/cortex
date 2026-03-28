## ADDED Requirements

### Requirement: Pubspec Metadata Parity
The `pubspec.yaml` in `profile` and `explore` SHALL follow the project-standard formatting, including boilerplate comments and standard descriptions.

#### Scenario: Metadata merge
- **WHEN** the `pubspec.yaml` is migrated
- **THEN** the `dependencies` / `dev_dependencies` MUST be grafted into the new template-generated `pubspec.yaml`
- **AND** the standard project comments (e.g., `# For information on the generic Dart part...`) MUST be preserved
