# registration-api Specification

## Purpose
TBD - created by archiving change registration-api. Update Purpose after archive.
## Requirements
### Requirement: User Registration
The system SHALL allow users to create a new account using the Registration API.

#### Scenario: Submitting registration form
- **WHEN** the user provides valid registration details (Username, Email, Password, Phone, Country Code)
- **THEN** the system SHALL send a `POST` request to `/api/v2.3/register/` with the provided payload
- **AND** the `country_code` SHALL be sent as an ISO Alpha-2 string (e.g., "IN")

### Requirement: Auto-login after registration
The system SHALL automatically log the user in following a successful registration.

#### Scenario: Handling successful registration
- **WHEN** the registration API returns a `201 Created` status
- **THEN** the system SHALL immediately execute a password login using the provided credentials
- **AND** upon successful login, navigate the user to the home screen

