## Context

The app currently uses default settings for login. We need to integrate with `/api/v2.3/settings/` to get the institute's custom login constraints (allowSignup, login labels, parallel logins). The backend API is unauthenticated. We want to fetch these early in the app lifecycle so the login screens render correctly without delay.

## Goals / Non-Goals

**Goals:**
- Fetch `InstituteSettings` on app startup.
- Cache settings locally to ensure immediate availability on subsequent launches.
- Apply only the login-related settings (`allowSignup`, `disableForgotPassword`, `enableParallelLoginRestriction`, `maxParallelLogins`, `googleLoginEnabled`) to the auth flow UI.

**Non-Goals:**
- Applying other sections of `InstituteSettings` (UI features, learnings, store, etc.) is out of scope for this change.
- Storing these settings in a complex database (like Drift).

## Decisions

1. **Persistence - Key-Value Store (`flutter_secure_storage`)**
   - **Rationale:** `InstituteSettings` is a singleton with 30+ properties. Mapping this to a SQLite table via Drift would require excessive boilerplate and migrations every time the backend adds a property. Serializing the object to a JSON string and storing it in the existing `flutter_secure_storage` is vastly simpler and robust.

2. **API Call - Unauthenticated Dio Request**
   - **Rationale:** The endpoint `/api/v2.3/settings/` does not require auth. We will create a `SettingsApiService` that uses the default `Dio` instance to fetch and parse the settings.

3. **App Startup Flow**
   - **Rationale:** We will create a `settings_repository.dart` that manages the local cache and remote API. On app launch, we will synchronously load the cached settings to render the UI immediately, and fire off a background refresh to keep the cache updated.

4. **Login Auto-Routing Strategy**
   - **Rationale:** The backend returns an array of `allowedLoginMethods` (Form, Social, OTP). To optimize the UX, if `InstituteSettings` indicates exactly one active login method, the main `LoginScreen` will automatically redirect the user directly to the respective flow, bypassing the options screen entirely. If 2 or more options are active, the options screen renders only the buttons corresponding to the enabled methods.

## Risks / Trade-offs

- **Risk:** Cache staleness. The settings might change on the backend while the user is using the app.
  - **Mitigation:** We refresh the settings in the background on every app startup. The settings don't change frequently enough to warrant real-time sockets or polling.

- **Risk:** First-time launch delay.
  - **Mitigation:** The first launch will have no cache, so the app might show a loader briefly while fetching settings before rendering the login screen.
