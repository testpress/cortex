## ADDED Requirements

### Requirement: Analytics Cleanup Refactoring Guidelines
The system SHALL adhere to the analytics cleanup refactoring guidelines to improve codebase clarity and consistency.

**Overview**
Refactor analytics codebase to improve clarity and consistency by:
1. Clarifying UI naming to use "Analytics" instead of generic "Subject" where analytics context is intended
2. Renaming table and DTO fields for clarity (`leaf` → `isLeaf`, `analyticsUrl` removal)
3. Standardizing button and text sizing across analytics screens

#### Scenario: Table & DTO Field Naming Conventions
- **THEN** Always use boolean flags prefixed with `is` (e.g., `isLeaf` instead of `leaf`).
- **AND** Avoid storing derived fields like `analyticsUrl` in the database; these should be constructed dynamically based on ID in the Data Source or Repository.
- **AND** Match DTO variable names with Database Column names.

#### Scenario: UI Screen/Component Naming
- **THEN** For Analytics screens, headers should clearly define the context (e.g., "Subject Analytics" instead of generic "Analytics" when looking at a specific subject).
- **AND** Section headers must be fully descriptive (e.g., "Subject Performance").
- **AND** Standard filter labels: "Correct", "Incorrect", "Unanswered".

#### Scenario: Text & Button Sizing Standardization
- **THEN** The global `ForumHeader` alignment standard must be applied to the Subject Analytics screen header:
  - Back arrows must use optical alignment: `Padding(top: 2)`
  - Titles must use `AppText.title` with `design.colors.textPrimary`.
- **AND** Filter icon buttons must be sized to `48x48` for accessibility tap targets, with an inner container of `36x36`.
- **AND** Tab buttons in views must use a `minHeight: 48.0` for accessibility standards.

**Affected Components**
- `packages/core/lib/data/db/tables/subject_analytics_table.dart`
- `packages/core/lib/data/models/review_models.dart`
- `packages/exams/lib/screens/subject_analytics/subject_analytics_screen.dart`
