## ADDED Requirements

### Requirement: API-backed login screen actions
The login UI SHALL execute auth actions via auth provider/repository instead of direct mock client calls.

#### Scenario: Password flow wiring
- **WHEN** user submits valid username and password in password login screen
- **THEN** the screen SHALL call auth provider password login action
- **AND** on success it SHALL navigate to home

#### Scenario: Mobile OTP flow wiring
- **WHEN** user submits phone details in mobile login screen
- **THEN** the screen SHALL call auth provider OTP generation action
- **AND** on success it SHALL navigate to OTP screen

#### Scenario: OTP verification wiring
- **WHEN** user submits OTP in OTP screen
- **THEN** the screen SHALL call auth provider OTP verification action
- **AND** on success it SHALL navigate to home

#### Scenario: Error and loading behavior
- **WHEN** auth action fails or is running
- **THEN** existing loading indicators and error message surfaces SHALL remain functional
