## ADDED Requirements

### Requirement: Parallel login proactive verification
The system SHALL proactively verify the newly obtained authentication token by calling the `/me/` endpoint inside the `AuthNotifier` before setting the authenticated state to `true`.

#### Scenario: Verification success — password login
- **WHEN** a user submits correct credentials on the password login screen
- **AND** the `/me/` endpoint returns `200 OK` using the newly saved token
- **THEN** the system SHALL set `authProvider` state to `authenticated`
- **AND** the router SHALL navigate the user to `/home`

#### Scenario: Verification success — OTP login
- **WHEN** a user submits a valid OTP on the OTP screen
- **AND** the `/me/` endpoint returns `200 OK` using the newly saved token
- **THEN** the system SHALL set `authProvider` state to `authenticated`
- **AND** the router SHALL navigate the user to `/home`

#### Scenario: Verification failure — parallel login restriction (password login)
- **WHEN** a user submits correct credentials on the password login screen
- **AND** the `/me/` endpoint returns `403 Forbidden` with `error_code: "parallel_login_restriction"`
- **THEN** the system SHALL NOT set `authProvider` state to `authenticated`
- **AND** the system SHALL clear the token from secure storage
- **AND** the `AuthNotifier` SHALL throw a `ParallelLoginException`
- **AND** the password login screen SHALL navigate the user to `LoginActivityScreen`

#### Scenario: Verification failure — parallel login restriction (OTP login)
- **WHEN** a user submits a valid OTP on the OTP screen
- **AND** the `/me/` endpoint returns `403 Forbidden` with `error_code: "parallel_login_restriction"`
- **THEN** the system SHALL NOT set `authProvider` state to `authenticated`
- **AND** the system SHALL clear the token from secure storage
- **AND** the `AuthNotifier` SHALL throw a `ParallelLoginException`
- **AND** the OTP screen SHALL navigate the user to `LoginActivityScreen`

### Requirement: Recovery via LoginActivityScreen
After resolving the parallel login restriction from `LoginActivityScreen`, the system SHALL transition the user to the authenticated Home state without requiring a re-login.

#### Scenario: Successful logout of other devices
- **WHEN** the user presses "Logout Other Devices" on the `LoginActivityScreen`
- **AND** the `logoutOtherDevices()` API call succeeds
- **THEN** the system SHALL call `authProvider.notifier.markAuthenticated()`
- **AND** the router SHALL navigate the user to `/home`
