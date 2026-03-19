# Session Management

## Overview
Session management is the SDK's persistence layer, responsible for keeping the user's session active across app restarts and ensuring that identity data is consistent and quickly accessible.

## Requirements

### R1: Token Persistence (`SessionStorage`)
- **Type**: `SharedPreferences` (or `flutter_secure_storage` if encryption is required later).
- **Keys**: 
  - `auth_token` (String): The JWT token for API requests.
  - `refresh_token` (String): The token for renewing sessions.
  - `is_authenticated` (Bool): A quickly-readable flag for routing.

### R2: Profile Persistence (`AppDatabase`)
- **Type**: `drift` (Native SQLite).
- **Table**: `UsersTable`.
- **Key**: `id` (Primary Key).
- **Logic**: The `AppDatabase` is the source of truth for the local user profile. When a login is successful, the current user must be upserted into this table.

### R3: Initialization Flow
- **Bootup**: On startup, the `initializationProvider` checks `SessionStorage` for an `auth_token`.
- **Hydration**: If authenticated, it fetches the user from the `AppDatabase` based on the stored identity and updates the `authProvider` state BEFORE the first frame is rendered.

### R4: Session Termination (Logout)
- **Action**: Must clear both `SessionStorage` (tokens) and `AppDatabase` (user profile).
- **Scope**: Must correctly reset the `authProvider` to an unauthenticated state.

## Enhancements (Post v1)

### R5: Secure Secret Storage
- Auth tokens MUST be stored in `flutter_secure_storage`.
- Non-sensitive session metadata MAY remain in `shared_preferences`.

### R6: Session Manager
- Session hydration and profile refresh TTL logic SHOULD live in a dedicated `SessionManager`.
- `authProvider` SHOULD consume hydration results from `SessionManager` rather than own hydration internals directly.

## Enhancements (v2)

### R7: Repository-Orchestrated Session Lifecycle
- Session hydration and logout flows MUST be triggered through `AuthRepository`.
- Session decisions exposed to UI routing SHOULD come from provider-backed auth state.

### R8: Local Profile Persistence Boundary
- Profile cache read/write for auth lifecycle MUST be coordinated by profile repository implementations using local persistence.
- Auth session management MUST NOT depend on generic cross-domain `DataSource` contracts.

### R9: Current User Read Semantics
- Profile-side repositories SHOULD expose a `getCurrentUser()` style API that:
  - returns cached user immediately when available, and
  - refreshes profile from API asynchronously to keep cache up to date.

### R10: Cross-Package Contract
- Auth flow in `packages/core` SHOULD depend on a minimal profile-facing
  contract (current-user sync/read abstraction), not on concrete profile
  implementation details.

### R11: Fresh Install Session Reset
- On first launch after a fresh install, secure token storage MUST be cleared before hydration checks.
- This behavior MUST prevent stale iOS keychain tokens from auto-restoring logged-in state after uninstall/reinstall.
