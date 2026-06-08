## ADDED Requirements

### Requirement: GitHub Actions CI Workflow
The repository SHALL contain a GitHub Actions workflow configuration at `.github/workflows/test.yaml`. The workflow MUST trigger on pull requests and pushes to the `main` branch.

#### Scenario: Workflow trigger
- **WHEN** a pull request is created or a push is made to the main branch
- **THEN** the CI workflow is executed automatically

### Requirement: Specific Flutter Environment
The CI environment MUST be configured to use Flutter version `3.41.1`, on the `[user-branch]` channel, with Engine hash `cc8e596aa651` and Dart `3.11.0`.

#### Scenario: Environment setup
- **WHEN** the CI job initializes
- **THEN** it sets up the exact pinned version of Flutter

### Requirement: Execution of Quality Checks
The CI workflow MUST define separate, parallel jobs for `format`, `analyze`, `test`, and `build`. Each job MUST use standard bash loops to fetch dependencies (`flutter pub get`) and run their respective checks (`dart format`, `flutter analyze`, `flutter test`, `flutter build apk`) across the `app` and `packages/*` directories.

#### Scenario: Running checks
- **WHEN** the repository is checked out and Flutter is set up
- **THEN** all code formatting, static analysis, unit tests, and APK builds are executed in parallel and succeed or fail independently.
