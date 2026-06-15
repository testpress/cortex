## MODIFIED Requirements

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
