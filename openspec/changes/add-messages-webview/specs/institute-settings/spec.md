## ADDED Requirements

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
