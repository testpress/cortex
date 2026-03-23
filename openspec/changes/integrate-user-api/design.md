## Context

The `AuthProvider` now uniquely manages the session state as a **Boolean** (`isLoggedIn`). All user metadata (profile, display name, avatar) must be resolved through a separate, reactive pipeline using `UserRepository` and `UserProvider`, which stream raw **`UsersTableData`** from the Drift database.

## Goals

- **Decoupled Auth**: `AuthProvider` (in `core`) only provides the login status (`bool`).
- **Reactive Profile**: Create `UserProvider` (in `profile`) to stream `UsersTableData?`.
- **Database-First**: Cache fetched profile in the `UsersTable` via `UserRepository`.
- **API Integration**: Fetch from `/api/v2.5/me/` and persist to Drift.

## Decisions

1. **AuthProvider is Boolean Only**
   - Holds `AsyncData<bool>` representing whether an auth token exists and is valid.
   - All router and guard logic depends on this boolean.

2. **UserProvider streams UsersTableData?**
   - Monitors the session status.
   - Watches the specific user row in `UsersTable` for reactive UI updates.

3. **Drift Caching**
   - Profile data is persisted to the local database to support offline viewing and consistent data flow across domain packages.
