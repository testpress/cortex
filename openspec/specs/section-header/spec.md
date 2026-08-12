# section-header Specification

## Purpose
TBD - created by archiving change standardize-root-headers. Update Purpose after archive.
## Requirements
### Requirement: Unified Section Header Layout
The system SHALL provide a `SectionHeader` widget in the core package that unifies layout and safe-area padding for all major screens.

#### Scenario: Rendering standard title
- **WHEN** the header is rendered with a string title
- **THEN** it displays the text title using the `AppText.headline` style

#### Scenario: Rendering leading and trailing actions
- **WHEN** `leadingIcon` and/or `trailingAction` widgets are provided
- **THEN** they are displayed on the left and right sides of the title row respectively

#### Scenario: Rendering secondary content
- **WHEN** a `secondaryContent` widget is provided
- **THEN** it is displayed below the main title row with appropriate vertical spacing

#### Scenario: Automatic safe area handling
- **WHEN** the header is rendered on a device with a notch or status bar
- **THEN** it automatically applies top, left, and right padding using `MediaQuery.paddingOf(context)` combined with design spacing to ensure content is not obscured

