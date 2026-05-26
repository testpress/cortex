## Why

When the home page renders the `InstituteBanner` at the top (which already contains the primary drawer menu / hamburger icon), the `DashboardHeader` below it also renders a duplicate hamburger menu icon next to the greeting. This redundancy is visually incorrect; the drawer menu should only be in the top bar when the banner is present.

## What Changes

- Update `PaidActiveHomeScreen` to conditionally pass `onMenuPressed` to `DashboardHeader`. If `isBannerPresent` is true, `onMenuPressed` will be set to `null` to hide the duplicate hamburger menu next to the greeting.

## Capabilities

### New Capabilities

### Modified Capabilities
- `lms-navigation-shell`: Ensure the home screen does not display duplicate hamburger menu buttons when the InstituteBanner is visible.

## Impact

- **Affected Code**: `packages/testpress/lib/screens/dashboard/paid_active_home_screen.dart`
- **APIs**: No API changes.
