## MODIFIED Requirements

### Requirement: Fetch user profile on session restore
The system SHALL fetch the authenticated user's profile from `GET /api/v2.5/me/` EXACTLY ONCE during session initialization (startup or login) and prevent duplicate parallel requests.

#### Scenario: Successful profile fetch after login
- **WHEN** the user successfully logs in (password or OTP)
- **THEN** the system MUST orchestrate a single call to `GET /api/v2.5/me/` via the centralized initialization provider
-   **AND** parse the response into a `UserDto` and persist it to the local database via `UserRepository`
-   **AND** ensure the `userProvider` (Stream) emits the updated profile data from the database without triggering additional network requests

#### Scenario: Successful profile fetch on app startup
-   **WHEN** the app starts and a stored auth token is found
-   **THEN** the system MUST orchestrate a single call to `GET /api/v2.5/me/` via the centralized initialization provider
-   **AND** the `authProvider` state MUST transition to `data(true)`
-   **AND** the `userProvider` MUST emit the fetched `UserDto` from the local database without triggering additional network requests

#### Scenario: Profile fetch fails with invalid token
-   **WHEN** the `GET /api/v2.5/me/` call returns 401
-   **THEN** the system MUST clear the stored token
-   **AND** the `authProvider` state MUST transition to `data(false)` (unauthenticated)
-   **AND** the `userProvider` MUST emit `null`

#### Scenario: Profile fetch fails with network error
-   **WHEN** the `GET /api/v2.5/me/` call fails due to a network error
-   **THEN** the system MUST set `authProvider` state to `error`
-   **AND** the app MUST show a retry option

#### Scenario: Parallel fetch deduplication
-   **WHEN** multiple components attempt to fetch the profile concurrently
-   **THEN** the system MUST deduplicate the requests at the repository layer
-   **AND** execute only one network call to `GET /api/v2.5/me/`
-   **AND** return the result of that single call to all awaiting callers
