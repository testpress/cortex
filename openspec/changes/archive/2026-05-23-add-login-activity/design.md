## Context

Users currently lack visibility into their active and past login sessions from within the mobile app. The web platform already exposes this data via an API. Introducing a Login Activity screen accessible from the app drawer enhances security and user awareness, allowing users to review the devices, browsers, and locations from which their account was accessed. The provided API endpoint returns paginated session details.

## Goals / Non-Goals

**Goals:**
- Implement a paginated list UI for login activities.
- Fetch data directly from `https://elearn.brilliantpala.org/api/v2.3/me/login_activity/` without local DB storage.
- Add an entry point to this feature within the App Drawer.
- Match the provided visual design, displaying OS/Device icon, Location, IP, Date/Time, and indicating the current device.

**Non-Goals:**
- Logging out of a *single, specific* device remotely. The API only supports an "all or nothing" remote logout for other mobile devices.
- Persisting login activity data offline.

## Decisions

- **Data Fetching:** Use a network-only repository/data source pattern to fetch from the `/api/v2.3/me/login_activity/` endpoint.
- **Remote Logout:** Implement a "Logout other devices" button that calls `POST /api/v2.4/auth/logout_devices/` via the core Auth architecture to terminate all other active mobile sessions.
- **Pagination:** Implement standard scrolling using `ScrollController` (instead of `infinite_scroll_pagination` package) to keep dependencies light and consistent.
- **UI Representation:** Create a dedicated stateless widget `LoginActivityListItem` that maps the JSON fields (`os`, `browser`, `location`, `ip_address`, `last_used`) into the required visual layout. Use appropriate icons based on device or OS type:
  - `MOBILE_APP` → `smartphone`
  - `MOBILE (web)` → `globe`
  - `PC` → `monitor`
  - `TABLET` → `tablet`
  - `OTHER` → `circleHelp`

## Risks / Trade-offs

- **Risk:** Network unavailability prevents viewing login activity. → Mitigation: Display a standard offline error state, as this is an online-only feature.
- **Risk:** Missing or null location data from the API. → Mitigation: Gracefully fallback to showing only IP address if location is unavailable.
