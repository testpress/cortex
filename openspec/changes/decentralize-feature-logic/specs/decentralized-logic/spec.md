## ADDED Requirements

### Requirement: Logic-Feature Allocation
Repositories, State Providers, and domain-specific logic must reside within the same package as the UI they serve. This ensures a clean, modular structure where the feature package is self-sufficient.

#### Scenario: Relocate Course Providers
- **WHEN** a provider like `courseListProvider` is being used in the app
- **THEN** it is imported from `package:courses/providers/` instead of `package:data/providers/`

#### Scenario: Relocate Profile Logic
- **WHEN** a repository like `SettingsRepository` is being used in the app
- **THEN** it is accessed from within the `profile` package, not the central `data` package

### Requirement: Shared Schema Layer
The `data` package must serve as the shared "lingua franca" providing only Models (DTOs) and common infrastructure tools. This prevents circular dependencies.

#### Scenario: Multi-module Model Access
- **WHEN** both the `courses` and `exams` modules need to understand a common `User` model
- **THEN** they both import it from `package:data/models/` without depending on each other directly.

### Requirement: Dependency Decoupling
Changes made within the logic of one feature package must not necessitate the recompilation of unrelated feature packages.

#### Scenario: Independent Rebuild
- **WHEN** modifying the implementation of a repository in the `exams` package
- **THEN** the `courses` package remains unaffected and does not trigger a dirty build.
