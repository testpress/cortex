# user-profile-api Specification

## Purpose
TBD - created by archiving change integrate-user-api. Update Purpose after archive.
## Requirements
### Requirement: Fetch user profile on session restore
The system SHALL fetch the authenticated user's profile from `GET /api/v2.5/me/` whenever a valid token is present.

#### Scenario: Successful profile fetch after login
- **WHEN** the user successfully logs in (password or OTP)
- **THEN** the system MUST call `GET /api/v2.5/me/` with the stored auth token
-   **AND** parse the response into a `UserDto` and persist it to the local database via `UserRepository`
-   **AND** ensure the `userProvider` (Stream) emits the updated profile data

#### Scenario: Successful profile fetch on app startup
-   **WHEN** the app starts and a stored auth token is found
-   **THEN** the system MUST call `GET /api/v2.5/me/` to restore the user session
-   **AND** the `authProvider` state MUST transition to `data(true)`
-   **AND** the `userProvider` MUST emit the fetched `UserDto` (from cache or network)

#### Scenario: Profile fetch fails with invalid token
-   **WHEN** the `GET /api/v2.5/me/` call returns 401
-   **THEN** the system MUST clear the stored token
-   **AND** the `authProvider` state MUST transition to `data(false)` (unauthenticated)
-   **AND** the `userProvider` MUST emit `null`

#### Scenario: Profile fetch fails with network error
-   **WHEN** the `GET /api/v2.5/me/` call fails due to a network error
-   **THEN** the system MUST set `authProvider` state to `error`
-   **AND** the app MUST show a retry option

---

### Requirement: Update user profile via API
The system SHALL persist profile edits to the backend via `PATCH /api/v2.5/me/`.

#### Scenario: Successful profile update
-   **WHEN** the user submits valid edits on the Edit Profile screen
-   **THEN** the system MUST send a `PATCH /api/v2.5/me/` request with the changed fields
-   **AND** the local database MUST be updated with the `UserDto` parsed from the server response
-   **AND** the `userProvider` MUST automatically emit the new profile data
-   **AND** the system MUST navigate back to the Profile screen

#### Scenario: Profile update fails
-   **WHEN** the `PATCH /api/v2.5/me/` request fails
-   **THEN** the system MUST display the error message to the user on the Edit Profile screen
-   **AND** the form data MUST be preserved so the user can retry

#### Scenario: Loading state during save
-   **WHEN** the profile update request is in progress
-   **THEN** the Save button MUST show a loading indicator
-   **AND** form inputs MUST be disabled to prevent duplicate submissions

---

### Requirement: UserDto field mapping
The system SHALL parse the `/me/` API response into a `UserDto` using only the fields the app needs.

#### Scenario: Field mapping from API response
-   **WHEN** the `/me/` response JSON is received
-   **THEN** the system MUST map the following fields:
    -   `id` → `UserDto.id`
    -   `display_name` → `UserDto.name`
    -   `first_name` → `UserDto.firstName`
    -   `last_name` → `UserDto.lastName`
    -   `email` → `UserDto.email`
    -   `phone` → `UserDto.phone`
    -   `username` → `UserDto.username`
    -   `medium_image` → `UserDto.avatar`
-   **AND** all other fields from the API response MUST be ignored

---

### Requirement: Profile data flows through DataSource and UserRepository
The system SHALL route profile operations through the existing `DataSource` → `UserRepository` pipeline.

#### Scenario: DataSource interface contract
- **WHEN** a profile operation is requested
- **THEN** `DataSource` MUST expose `getProfile(String token)` returning `UserDto`
- **AND** `DataSource` MUST expose `updateProfile(String token, Map<String, dynamic> data)` returning `UserDto`

#### Scenario: HttpDataSource implementation
- **WHEN** `HttpDataSource.getProfile()` is called
- **THEN** it MUST send `GET /api/v2.5/me/` with `Authorization: JWT <token>` header
- **AND** parse the response using `UserDto.fromJson`

#### Scenario: MockDataSource implementation
- **WHEN** `MockDataSource.getProfile()` is called
- **THEN** it MUST return `mockCurrentUser` after a simulated delay

#### Scenario: UserRepository orchestration
- **WHEN** `UserRepository.fetchProfile(token)` is called
- **THEN** it MUST delegate to `DataSource.getProfile(token)` and return the result
- **WHEN** `UserRepository.updateProfile(token, data)` is called
- **THEN** it MUST delegate to `DataSource.updateProfile(token, data)` and return the updated `UserDto`

