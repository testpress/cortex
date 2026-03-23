## Why

The app uses a hardcoded `mockCurrentUser` after login. `AuthProvider` stores the token but never fetches real user details from the backend. Profile screens display stale mock data, and edits are local-only. We need to integrate `/api/v2.5/me/` to fetch and update real user profiles.

## What Changes

- Add `getProfile()` and `updateProfile()` to `DataSource` / `HttpDataSource` for `GET` and `PATCH` on `/api/v2.5/me/`.
- Expand `UserDto` with fields the app uses from the API response, plus `fromJson` for parsing.
- Extend `UserRepository` to orchestrate profile fetch and update via `DataSource`.
- Update `AuthProvider.build()` to fetch real user from `UserRepository` instead of returning `mockCurrentUser`.
- Replace `AuthProvider.updateProfile(UserDto)` with an async method that delegates to `UserRepository`.
- Wire Edit Profile screen to handle async save with loading and error feedback.
- Decouple `courses` domain from `profile` by moving `UserProgressRepository` to the `core` package.

## Capabilities

### New Capabilities
- `user-profile-api`: Network integration for fetching and updating user profile via `/api/v2.5/me/`, flowing through `DataSource` → `UserRepository` → `AuthProvider`.

### Modified Capabilities
- `domain-isolation`: The `courses` package now relies exclusively on `core` for identity state and progress data, preventing boundary violations.

## Impact

- Affected code: `DataSource`, `HttpDataSource`, `MockDataSource`, `UserDto`, `UserRepository`, `UserProgressRepository`, `AuthProvider`.
- Dependencies: `dio` (already present).
- Behavior: After login or session restore, the app displays real user data. Profile edits are persisted server-side.
