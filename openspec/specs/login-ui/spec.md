# login-ui

## Requirements

### Requirement: Login screen architectural location
The Login Screen SHALL be implemented within the `profile` package as part of the unified user identity and session management domain.

#### Scenario: Verification of package structure
- **WHEN** the login screen is implemented
- **THEN** its source file SHALL reside in `packages/profile/lib/screens/login_screen.dart`
- **AND** it SHALL be exported from the `profile` package library.

### Requirement: Login screen layout
The system SHALL provide a centered, card-style login layout with branding and support for two authentication modes: Password and OTP.

#### Scenario: Rendering the default login screen
- **WHEN** the user navigates to `/login`
- **THEN** the system SHALL display the Password login form by default
- **AND** it SHALL show fields for Username/Email and Password.

### Requirement: Authentication mode switching
The system SHALL allow users to toggle between "Password" and "OTP" login methods.

#### Scenario: Switching to OTP mode
- **WHEN** the user selects the "OTP" tab/button
- **THEN** the system SHALL replace the credential fields with Country Code, Phone Number, and an optional Email field.

### Requirement: Interactive form feedback
The system SHALL display visual feedback for user interactions, including loading indicators and error messages.

#### Scenario: Displaying busy state
- **WHEN** a login or OTP intent is triggered
- **THEN** the system SHALL disable input fields and show a loading indicator on the primary button.

### Requirement: Localized UI copy
All user-facing text in the login flow SHALL be localized.

#### Scenario: Displaying labels in English
- **WHEN** the app locale is set to English
- **THEN** the system SHALL display labels like "Username", "Password", and "Sign In" from the localization bundle.
