## MODIFIED Requirements

### Requirement: Login screen layout
The system SHALL provide a centered, card-style login layout supporting Password and OTP modes, with fields and buttons configured by the institute settings.

#### Scenario: Displaying multiple login options
- **WHEN** the `instituteSettings` configure two or more active login methods
- **THEN** the login options screen SHALL display only the buttons for the currently active methods
- **AND** it SHALL conditionally evaluate `googleLoginEnabled` alongside `socialLogin`.

#### Scenario: Auto-routing for a single login option
- **WHEN** the `instituteSettings` configure exactly one active login method
- **THEN** the system SHALL skip the login options screen
- **AND** automatically route the user directly to the respective authentication screen (e.g., `/password-login`).

#### Scenario: Disabling forgot password
- **WHEN** the institute settings have `disableForgotPassword` set to true
- **THEN** the login screen SHALL hide the forgot password link

#### Scenario: Controlling signup visibility
- **WHEN** the institute settings have `allowSignup` set to false
- **THEN** the login screen SHALL hide the sign up link/button

### Requirement: Localized UI copy
All user-facing text in the login flow SHALL be localized.

#### Scenario: Displaying default localized labels
- **WHEN** the app locale is set to English
- **THEN** the system SHALL display default labels from the localization bundle
