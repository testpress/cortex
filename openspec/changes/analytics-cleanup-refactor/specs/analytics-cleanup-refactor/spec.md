# Analytics Cleanup Refactoring

## Overview
Refactor analytics codebase to improve clarity and consistency by:
1. Clarifying UI naming to use "Analytics" instead of generic "Subject" where analytics context is intended
2. Renaming table and DTO fields for clarity (`leaf` → `isLeaf`, `analyticsUrl` removal)
3. Standardizing button and text sizing across analytics screens

## Guidelines Established

### 1. Table & DTO Field Naming Conventions
- Always use boolean flags prefixed with `is` (e.g., `isLeaf` instead of `leaf`).
- Avoid storing derived fields like `analyticsUrl` in the database; these should be constructed dynamically based on ID in the Data Source or Repository.
- Match DTO variable names with Database Column names.

### 2. UI Screen/Component Naming
- For Analytics screens, headers should clearly define the context (e.g., "Subject Analytics" instead of generic "Analytics" when looking at a specific subject).
- Section headers must be fully descriptive (e.g., "Subject Performance").
- Standard filter labels: "Correct", "Incorrect", "Unanswered".

### 3. Text & Button Sizing Standardization
- The global `ForumHeader` alignment standard must be applied to the Subject Analytics screen header:
  - Back arrows must use optical alignment: `Padding(top: 2)`
  - Titles must use `AppText.title` with `design.colors.textPrimary`.
- Filter icon buttons must be sized to `48x48` for accessibility tap targets, with an inner container of `36x36`.
- Tab buttons in views must use a `minHeight: 48.0` for accessibility standards.

## Affected Components
- `packages/core/lib/data/db/tables/subject_analytics_table.dart`
- `packages/core/lib/data/models/review_models.dart`
- `packages/exams/lib/screens/subject_analytics/subject_analytics_screen.dart`
