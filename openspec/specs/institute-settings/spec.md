# institute-settings Specification

## Purpose
TBD - created by archiving change institute-login-settings. Update Purpose after archive.
## Requirements
### Requirement: Global Institute Settings
The system SHALL fetch and provide institute settings globally on app startup.

#### Scenario: First launch fetch
- **WHEN** the app starts up without cached settings
- **THEN** the system fetches settings from `/api/v2.3/settings/` before showing the app UI
- **AND** caches them locally

#### Scenario: Subsequent launch load
- **WHEN** the app starts up with cached settings
- **THEN** the system loads settings synchronously from cache to show the UI
- **AND** refreshes the cache in the background

