## ADDED Requirements

### Requirement: Username Visibility Based on Profile Tab
The system SHALL conditionally show or hide the user's name across dashboard surfaces based on whether the Profile tab is enabled in the client configuration.

#### Scenario: Profile tab disabled — greeting shows no name
- **WHEN** `AppConfig.showProfileTab` is `false`
- **AND** `HomeGreetingSection` is rendered (standard layout, no banner)
- **THEN** the greeting MUST show only "Good Morning" (or equivalent) WITHOUT the user's name

#### Scenario: Profile tab enabled — name shown in greeting
- **WHEN** `AppConfig.showProfileTab` is `true`
- **AND** `HomeGreetingSection` is rendered
- **THEN** the greeting MUST include the user's name (e.g., "Good Morning, Ibrahim")
