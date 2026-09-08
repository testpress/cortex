# dark-mode-support Specification

## Purpose
TBD - created by archiving change dark-mode-support. Update Purpose after archive.
## Requirements
### Requirement: Automatic System Theme Detection

The `DesignProvider` MUST automatically select the appropriate color palette based on the host operating system's brightness preference when in `system` mode.

#### Scenario: Switching to dark mode

- **WHEN** the system brightness changes to dark
- **AND** the `DesignProvider` is in `DesignMode.system`
- **THEN** it MUST provide the `darkConfig` to the widget tree
- **AND** all child widgets using `Design.of(context)` MUST update their colors immediately

### Requirement: Explicit Theme Override

The developer MUST be able to force the design system into a specific mode regardless of the system settings.

#### Scenario: Forcing light mode

- **WHEN** the `DesignProvider` is configured with `mode: DesignMode.light`
- **THEN** it MUST always provide the light configuration
- **AND** it MUST ignore platform brightness changes

### Requirement: Curated Dark Palette

Dark mode MUST not merely be an inversion of light mode; it MUST use curated tokens optimized for legibility and eye comfort.

#### Scenario: Accessing dark tokens

- **WHEN** the system is in dark mode
- **THEN** `design.colors.surface` MUST resolve to the curated dark surface color
- **AND** `design.colors.textPrimary` MUST resolve to white or high-contrast silver

### Requirement: Synchronous Theme Preference Persistence
The system SHALL persist display theme preferences (`appearance_mode`) to native key-value storage (`SharedPreferences` / `NSUserDefaults`) and pre-load them before rendering `runApp()` to guarantee zero asynchronous loading fallback on app start.

#### Scenario: Cold start theme restoration
- **WHEN** the application cold starts after being completely closed
- **THEN** the initial frame MUST mount with the user's saved `DesignMode` from native key-value storage
- **AND** it MUST NOT fall back to system default theme during initial database load

