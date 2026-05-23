## Why

Users need visibility into their active and past login sessions for security and account management purposes. Implementing a Login Activity screen accessible from the app drawer allows users to review the devices, locations, and browsers accessing their accounts.

## What Changes

- Add a new "Login Activity" entry to the app drawer navigation.
- Implement a screen to fetch and display login activity from the `https://elearn.brilliantpala.org/api/v2.3/me/login_activity/` endpoint.
- Display each session as a list item with details: OS, browser, location, IP address, and last used timestamp.
- Indicate the "current device" if applicable.
- Add a "Logout other devices" action to allow users to securely terminate active mobile sessions remotely.
- The data will be fetched on demand, properly paginated, and not persisted in the local database.

## Capabilities

### New Capabilities
- `login-activity`: Display a paginated list of login activity sessions, showing device, browser, IP, location, and timestamp for each session, fetched directly from the API without local persistence.

### Modified Capabilities
- `lms-navigation-shell`: Add a navigation item for "Login Activity" to the app drawer.

## Impact

- **UI**: App drawer menu update, new Login Activity screen with list layout (matching the provided design with icons for OS/Device).
- **Network**: Integration with the `/api/v2.3/me/login_activity/` endpoint.
- **State**: Ephemeral state management for the paginated list of sessions.
