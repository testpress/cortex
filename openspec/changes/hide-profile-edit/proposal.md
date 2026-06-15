## Why

The `InstituteSettings` model contains an `allowProfileEdit` property that is currently not being respected in the UI. If an institute has this set to false, users should not be able to see the option to edit their profile. This change ensures we respect the backend configuration for profile editing capability.

## What Changes

- Hide the "Edit Profile" option/button in the Profile screen when `InstituteSettings.current?.allowProfileEdit` is false.

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- `profile`: Adding conditional visibility for the edit profile feature based on institute settings.

## Impact

- `packages/profile`: The UI components displaying the edit profile option will need to check `InstituteSettings.current?.allowProfileEdit`.
