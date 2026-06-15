# login-ui

## Purpose
Define requirements for the login user interface, supporting password and OTP authentication modes with interactive feedback and localization.
## Requirements
### Requirement: Login screen architectural location
The Login Screen SHALL be implemented within the `profile` package as part of the unified user identity and session management domain.

#### Scenario: Verification of package structure
- **WHEN** the login screen is implemented
- **THEN** its source file SHALL reside in `packages/profile/lib/screens/login_screen.dart`
- **AND** it SHALL be exported from the `profile` package library.

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

#### Scenario: Displaying default localized labels
- **WHEN** the app locale is set to English
- **THEN** the system SHALL display default labels from the localization bundle

### Requirement: API-backed login screen actions
The login UI SHALL execute auth actions via auth provider/repository instead of direct mock client calls. After obtaining an auth token, the login flow MUST wait for parallel login verification before navigating to Home.

#### Scenario: Password flow wiring — success
- **WHEN** user submits valid username and password in the password login screen
- **THEN** the screen SHALL call `authProvider.notifier.loginWithPassword(...)`
- **AND** on success it SHALL navigate to `/home`

#### Scenario: Password flow wiring — parallel login restriction
- **WHEN** user submits valid username and password in the password login screen
- **AND** a `ParallelLoginException` is thrown
- **THEN** the screen SHALL navigate to `LoginActivityScreen`
- **AND** SHALL display the message "Parallel login is restricted. Logout of other devices to continue."

#### Scenario: Mobile OTP flow wiring
- **WHEN** user submits phone details in the mobile login screen
- **THEN** the screen SHALL call the auth provider OTP generation action
- **AND** on success it SHALL navigate to the OTP screen

#### Scenario: OTP verification wiring — success
- **WHEN** user submits OTP in the OTP screen
- **THEN** the screen SHALL call `authProvider.notifier.verifyOtp(...)`
- **AND** on success it SHALL navigate to `/home`

#### Scenario: OTP verification wiring — parallel login restriction
- **WHEN** user submits OTP in the OTP screen
- **AND** a `ParallelLoginException` is thrown
- **THEN** the screen SHALL navigate to `LoginActivityScreen`
- **AND** SHALL display the message "Parallel login is restricted. Logout of other devices to continue."

#### Scenario: Error and loading behavior
- **WHEN** auth action fails or is running
- **THEN** existing loading indicators and error message surfaces SHALL remain functional

