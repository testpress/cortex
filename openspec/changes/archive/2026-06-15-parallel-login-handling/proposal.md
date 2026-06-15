## Why

Currently, the backend issues an authentication token during login without enforcing the maximum parallel login limit at the token generation stage. The enforcement only occurs on subsequent API requests (like fetching banners or the leaderboard), which immediately fail with a `403` and the `parallel_login_restriction` error. This places the user in a broken "zombie" state on the Home screen where all widgets fail to load. We need to handle this restriction proactively during the login flow to provide a seamless UX and direct users to manage their active sessions before entering the main app.

## What Changes

- Update the login authentication flow to proactively verify the newly obtained token by calling the `/me/` endpoint.
- If the `/me/` endpoint returns a `403` with `parallel_login_restriction`, the global authentication state remains unauthenticated, and the token is not saved to persistent storage.
- Users with restricted tokens will be immediately navigated to the `LoginActivityScreen` to log out of other devices.
- If the `/me/` verification succeeds (200 OK), the token is committed, the profile is cached to prevent redundant network calls, and the user navigates to the Home screen as normal.

## Capabilities

### New Capabilities
- `parallel-login-verification`: Proactively verifies new authentication tokens against parallel login restrictions and handles redirection to the Login Activity Screen when limits are exceeded.

### Modified Capabilities
- `login-ui`: Modifies the login submission logic to incorporate the verification step and routing to `LoginActivityScreen` instead of directly to Home.

## Impact

- **Login Flow**: Modifies the core login submission handling.
- **Routing**: Introduces a new conditional route parameter for `LoginActivityScreen` to accept the temporary restricted token.
- **State Management**: Updates how the initial `/me/` profile is fetched and cached during login to avoid redundant network calls on Home screen load.
