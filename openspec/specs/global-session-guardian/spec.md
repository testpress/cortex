# global-session-guardian Specification

## Purpose
TBD - created by archiving change dio-singleton-refactor. Update Purpose after archive.
## Requirements
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
The global interceptor SHALL trigger a complete session invalidation whenever the backend rejects an authenticated request with a `401 Unauthorized` status.

#### Scenario: Backend token invalidation
- **THEN** the system SHALL invoke the `AuthRepository.logout()` method.
- **AND** the repository SHALL clear all tokens from secure storage.
- **AND** the repository SHALL wipe all user-related data (via `AppDatabase.purgeAllData()`).
- **AND** the system SHALL transition to an `unauthenticated` state, forcing a redirect to the login screen.

