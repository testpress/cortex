## ADDED Requirements

### Requirement: Centralized Initialization State
The system MUST orchestrate the initialization of required app settings and authentication state into a single global bootstrap state before allowing deep linking or app navigation.

#### Scenario: App is initializing
- **WHEN** the app first starts up and `instituteSettingsProvider` or `authProvider` has not yet emitted a non-loading value
- **THEN** the overall bootstrap state is `loading`

#### Scenario: App finishes initializing for unauthenticated user
- **WHEN** both `instituteSettingsProvider` and `authProvider` have emitted non-loading values, and the user is not logged in
- **THEN** the overall bootstrap state becomes `unauthenticated`

#### Scenario: App finishes initializing for authenticated user
- **WHEN** both `instituteSettingsProvider` and `authProvider` have emitted non-loading values, and the user is logged in
- **THEN** the overall bootstrap state becomes `authenticated`
