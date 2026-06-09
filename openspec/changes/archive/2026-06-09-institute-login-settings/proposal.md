## Why

The app currently uses default settings for login and signup flows. We need to integrate with the backend's `/api/v2.3/settings/` endpoint to fetch the institute-specific configuration so that the app's login experience respects the institute's rules (e.g., enabling/disabling signup, custom labels, parallel login restrictions). For this initial phase, we are only focusing on the Login settings block.

## What Changes

- Fetch the institute settings from `/api/v2.3/settings/` on app startup.
- Cache the settings locally using `flutter_secure_storage` or `shared_preferences`.
- Make the `InstituteSettings` available globally.
- Apply the login-specific flags (allowSignup, loginIdLabel, etc.) to the login/auth screens.

## Capabilities

### New Capabilities
- `institute-settings`: Fetching, caching, and providing the global institute configuration, with an initial focus on login constraints.

### Modified Capabilities
- `auth`: Update login screen UI to hide forgot password if `disableForgotPassword` is true, and disable signup if `allowSignup` is false.

## Impact

- `core` package: New API service, local store, and provider for settings.
- `auth` feature / login screens: Will now depend on `InstituteSettings` to control UI rendering and flows.
