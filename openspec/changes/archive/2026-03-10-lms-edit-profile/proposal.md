## Why
Currently, users can view their profile data but have no way to modify it. Providing an "Edit Profile" screen is essential for personalizing the user experience and ensuring identity information remains accurate.

## What Changes
- **New `EditProfileScreen`**: A dedicated form-based screen in the `profile` package to allow users to update their identity data.
- **Form Fields**: Support for editing `name`, `email`, and `phone` (will require extending the data model).
- **Avatar Affordance**: Simple UI for initiating an avatar change (image picker placeholder).
- **Update Logic**: New `updateProfile` method in the `Auth` provider (`data` package) to persist changes.
- **Form Validation**: Immediate feedback on invalid inputs and confirmation on successful save.
- **Navigation Integration**: Hook up the "Edit Profile" menu item in the `AccountPreferencesSection` to navigate to this new screen.

## Capabilities

### New Capabilities
- `lms-edit-profile`: A standalone screen for user profile modification using standardized form components.

### Modified Capabilities
- `lms-profile`: Requirements update to include active navigation to the edit profile screen.

## Impact
- `packages/profile`: New screen (`EditProfileScreen`) and related routing logic.
- `packages/data`: Enhancement of `UserDto` (adding `phone`) and `Auth` provider (adding `updateProfile`).
- `packages/core`: Potential addition of `AppTextField` if not already present in basic form, ensuring consistent styling.
