## 1. Data Layer

- [x] 1.1 Create `LoginActivityDto` to parse API response JSON and a domain model `LoginActivity` with mapping logic
- [x] 1.2 Implement network data source method for fetching login activities

## 2. Domain & State Layer

- [x] 2.1 Implement repository layer method to fetch login activities
- [x] 2.2 Setup pagination state management (e.g., `PagingController` or Riverpod equivalent)

## 3. UI Implementation

- [x] 3.1 Create `LoginActivityListItem` widget displaying OS/Browser, Location, IP, and timestamp
- [x] 3.2 Add conditional logic in the list item to highlight the "current device"
- [x] 3.3 Create `LoginActivityScreen` containing a paginated list view of sessions
- [x] 3.4 Add appropriate empty, loading (shimmer), and error states for the screen

## 4. Navigation & Integration

- [x] 4.1 Register `LoginActivityScreen` route in the application router
- [x] 4.2 Add "Login Activity" navigation entry to the App Drawer

## 5. Logout Devices

- [x] 5.1 Add `logoutOtherDevices` method to the Auth architecture (`AuthApiService`, `AuthRepository`, `AuthProvider`) targeting `POST /api/v2.4/auth/logout_devices/`.
- [x] 5.2 Add a static "Logout other devices" button at the bottom of `LoginActivityScreen`.
- [x] 5.3 Connect the button to the auth provider, displaying appropriate loading states and success toasts, then refreshing the list.
