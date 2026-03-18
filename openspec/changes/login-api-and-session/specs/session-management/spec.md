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
