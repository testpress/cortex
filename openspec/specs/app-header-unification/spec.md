# app-header-unification Specification

## Purpose
TBD - created by archiving change refactor-app-header. Update Purpose after archive.
## Requirements
### Requirement: Unified Drawer Header Layout
The system SHALL provide a standardized `AppHeader` component exclusively for drawer and interior screens.

#### Scenario: Rendering AppHeader with bottom content
- **WHEN** an interior screen requires contextual filters or legends below the title
- **THEN** the screen passes a Widget to `AppHeader`'s `bottomContent` slot, and it renders seamlessly below the title and actions.

#### Scenario: Rendering AppHeader across drawer screens
- **WHEN** navigating to a screen accessed via the drawer (e.g., Downloads, Bookmarks)
- **THEN** the screen SHALL use `AppHeader` for its title bar, matching the standardized smaller title size and card background.

### Requirement: Decoupled Root Screen Headers
Root tab screens SHALL NOT use `AppHeader` and MUST define their own header structures.

#### Scenario: Viewing AI Screen
- **WHEN** the user views the AI Screen
- **THEN** the header SHALL mirror the static custom layout used by Study/Exam screens, and NOT utilize `AppHeader`.

