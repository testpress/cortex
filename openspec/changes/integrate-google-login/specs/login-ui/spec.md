## ADDED Requirements

### Requirement: Google login flow wiring
The login UI SHALL execute Google auth actions via auth provider when the Google button is tapped. After obtaining an auth token, the login flow MUST wait for parallel login verification before navigating to Home.

#### Scenario: Google flow wiring — success
- **WHEN** user taps the "Continue with Google" button
- **THEN** the screen SHALL call `authProvider.notifier.loginWithGoogle()`
- **AND** on success it SHALL navigate to `/home`

#### Scenario: Google flow wiring — parallel login restriction
- **WHEN** user taps the "Continue with Google" button
- **AND** a `ParallelLoginException` is thrown
- **THEN** the screen SHALL navigate to `LoginActivityScreen`
- **AND** SHALL display the message "Parallel login is restricted. Logout of other devices to continue."

#### Scenario: Google flow error behavior
- **WHEN** Google auth action fails
- **THEN** the screen SHALL display the error message using the existing `_errorMessage` surface.
