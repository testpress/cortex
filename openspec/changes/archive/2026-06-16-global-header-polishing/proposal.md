## Why

Currently, several of the main screens (like the Profile page using `DashboardHeader` and the Study page using an inline header) visually cut off below the device's status bar. This makes them look like separated boxes rather than extending seamlessly into the status bar like the Notifications and Certificates screens. Additionally, the back buttons on the profile sub-tabs (Edit Profile, Notifications, Certificates) have minor alignment and color inconsistencies. Fixing these issues will provide a more unified, polished, and premium user experience.

## What Changes

- Update `DashboardHeader` and the inline headers found on main tab screens (like `StudyScreen`) to merge seamlessly with the device's status bar by correctly drawing their background color behind the status bar rather than applying a hard top padding boundary.
- Fix the internal alignment of the back arrow and its accompanying text on the Edit Profile, Notifications, and Certificates screens to be perfectly identical.
- Correct the color discrepancy of the back button on the Your Certificates screen so it precisely matches the Edit Profile and Notifications screens.

## Capabilities

### New Capabilities

### Modified Capabilities
- `dashboard-section-infrastructure`: Update header implementation to support seamless status bar merging.
- `lms-edit-profile`: Fix back button alignment to match other profile sub-screens.
- `lms-notifications`: Fix back button alignment to match other profile sub-screens.
- `lms-certificates`: Fix back button color and alignment to match other profile sub-screens.

## Impact

- **Affected Code**: 
  - `packages/core/lib/widgets/dashboard_header.dart`
  - `packages/profile/lib/screens/paid_active_profile_screen.dart`
  - `packages/courses/lib/screens/study_screen.dart` (and other similar top-level tab screens)
  - `packages/profile/lib/screens/edit_profile_screen.dart`
  - `packages/profile/lib/screens/notifications_screen.dart`
  - `packages/profile/lib/screens/certificates_screen.dart`
- **Dependencies**: No new dependencies. This involves adjusting layout padding, containers, and color tokens.
