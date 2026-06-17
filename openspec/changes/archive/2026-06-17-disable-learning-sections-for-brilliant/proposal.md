## Why

For the Brilliant Pala client specifically, certain learning statistics and sections should not be visible. We need to disable the "Learning Performance" section in the Home tab, and the "Your recent learning", "Your active courses", and "Your learning at a glance" sections in the Profile tab.

## What Changes

- Home tab: Conditionally disable and hide the `StudyMomentumGrid` ("Learning Performance") widget when the active tenant is Brilliant Pala (identified by `AppConfig.apiBaseUrl` containing `brilliant`).
- Profile tab: Conditionally disable and hide the `ProfileLearningSnapshot` ("Your learning at a glance"), `EnrolledCoursesSection` ("Your active courses"), and `RecentActivitySection` ("Your recent learning") widgets when the active tenant is Brilliant Pala (identified by `AppConfig.apiBaseUrl` containing `brilliant`).

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- lms-home-paid-active: Conditionally hide the Learning Performance section for Brilliant Pala.
- lms-profile: Conditionally hide learning snapshot, enrolled courses, and recent activity sections for Brilliant Pala.

## Impact

- `packages/testpress/lib/screens/dashboard/paid_active_home_screen.dart`
- `packages/profile/lib/screens/paid_active_profile_screen.dart`
