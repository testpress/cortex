## Why

Currently, both `appInitialization` and `userProvider` react to `authProvider` state changes and independently trigger `userRepository.refreshProfile()`. This results in duplicate `/api/v2.5/me/` network requests immediately after a successful login or during cold starts with an existing session. This change eliminates the redundant request to improve performance, save bandwidth, and centralize orchestration.

## What Changes

- Make `appInitialization` the single owner of profile refresh orchestration.
- Remove the background `refreshProfile().ignore()` call from `packages/profile/lib/providers/user_provider.dart`.
- Keep `userProvider` as a pure reactive local-db stream provider.

## Capabilities

### New Capabilities

### Modified Capabilities
- `user-profile-api`: The underlying data freshness behavior is being refined to prevent duplicate requests while ensuring the cache is populated.

## Impact

- `packages/profile/lib/providers/user_provider.dart` (Modified)
- Network performance during application startup and login flows.
