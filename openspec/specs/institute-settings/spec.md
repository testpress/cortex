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

### Requirement: Institute Messages Settings
The system SHALL parse `messages_enabled` and `messages_label` from the institute settings payload and expose them on `InstituteSettings`.

#### Scenario: Messages enabled in settings
- **WHEN** the `/api/v2.3/settings/` response contains `'messages_enabled': true` and `'messages_label': 'Support Desk'`
- **THEN** `InstituteSettings.messagesEnabled` evaluates to `true`
- **AND** `InstituteSettings.messagesLabel` evaluates to `'Support Desk'`

#### Scenario: Messages absent in settings
- **WHEN** the `/api/v2.3/settings/` response omits `messages_enabled`
- **THEN** `InstituteSettings.messagesEnabled` defaults to `false`
- **AND** `InstituteSettings.messagesLabel` defaults to `null`

