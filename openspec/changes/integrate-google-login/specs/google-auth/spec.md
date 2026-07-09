## ADDED Requirements

### Requirement: Google Sign-In Flow
The system SHALL use the `google_sign_in` plugin to authenticate users natively and obtain an ID Token, then exchange it with the backend for a Testpress JWT.

#### Scenario: Successful Google Sign-In
- **WHEN** the user initiates a Google Sign-In
- **AND** successfully authenticates with Google
- **THEN** the system SHALL send the ID token to `POST /api/v2.3/social-auth/` with provider "GOOGLE"
- **AND** save the returned JWT token to establish a session

#### Scenario: Google Sign-In Cancellation
- **WHEN** the user initiates a Google Sign-In
- **AND** cancels the native flow
- **THEN** the system SHALL NOT send any network requests
- **AND** SHALL return to the initial login state without error.

#### Scenario: Backend Rejection (Audience Mismatch or invalid token)
- **WHEN** the backend rejects the Google token
- **THEN** the system SHALL throw an `AuthException` with the appropriate error message.
