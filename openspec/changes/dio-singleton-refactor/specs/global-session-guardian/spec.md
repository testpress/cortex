## ADDED Requirements

### Requirement: Path-aware authentication injection
The global interceptor SHALL selectively attach a Bearer (JWT) token to requests based ON the request path.

#### Scenario: Public endpoint skip
- **WHEN** a request is made to an authentication endpoint (e.g., `/auth/login`, `/auth/otp/generate`)
- **THEN** the system SHALL NOT attach the `Authorization` header to the request

#### Scenario: Private endpoint inclusion
- **WHEN** a request is made to a regular LMS endpoint (e.g., `/api/v2/courses/`, `/user/profile/`) 
- **AND** a valid access token exists in secure storage
- **THEN** the system SHALL attach the `Authorization: JWT <token>` header to the request

### Requirement: Global session invalidation
The global interceptor SHALL handle `401 Unauthorized` responses and trigger an app-wide session invalidation.

#### Scenario: Session Expired Redirect
- **WHEN** a network request (other than login) returns a `401` status code
- **THEN** the system SHALL clear the locally stored access token
- **AND** it SHALL transition the app's overall authentication state to `unauthenticated`, triggering a navigation to the login screen
