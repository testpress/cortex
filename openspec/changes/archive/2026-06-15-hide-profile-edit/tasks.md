## 1. UI Updates

- [x] 1.1 Locate the profile header widget in the `profile` package and conditionally render the "Edit Profile" affordance/button based on `InstituteSettings.current?.allowProfileEdit ?? false`.
- [x] 1.2 Locate the Account & Preferences menu list in the `profile` package and conditionally render the "Edit Profile" list item based on `InstituteSettings.current?.allowProfileEdit ?? false`.

## 2. Verification

- [x] 2.1 Verify that when `allowProfileEdit` is false, the edit button in the profile header is hidden.
- [x] 2.2 Verify that when `allowProfileEdit` is false, the Edit Profile menu option in the Account & Preferences list is hidden.
