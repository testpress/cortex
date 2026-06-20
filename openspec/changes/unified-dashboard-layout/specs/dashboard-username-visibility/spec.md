## ADDED Requirements

### Requirement: Username Visibility Based on Profile Tab
The system SHALL conditionally show or hide the user's name across dashboard surfaces based on whether the Profile tab is enabled in the client configuration.

#### Scenario: Profile tab enabled — name hidden in banner
- **WHEN** `AppConfig.showProfileTab` is `true`
- **AND** `InstituteBanner` is rendered
- **THEN** the user's name and enrollment ID block MUST NOT be visible in the top-right of the banner

#### Scenario: Profile tab disabled — name shown in banner
- **WHEN** `AppConfig.showProfileTab` is `false`
- **AND** `InstituteBanner` is rendered
- **THEN** the user's name and enrollment ID MUST be visible in the top-right of the banner

#### Scenario: Profile tab disabled — greeting shows no name
- **WHEN** `AppConfig.showProfileTab` is `false`
- **AND** `HomeGreetingSection` is rendered (standard layout, no banner)
- **THEN** the greeting MUST show only "Good Morning" (or equivalent) WITHOUT the user's name

#### Scenario: Profile tab enabled — name shown in greeting
- **WHEN** `AppConfig.showProfileTab` is `true`
- **AND** `HomeGreetingSection` is rendered
- **THEN** the greeting MUST include the user's name (e.g., "Good Morning, Ibrahim")
