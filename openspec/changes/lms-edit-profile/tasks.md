## 1. Data Layer Updates

- [x] 1.1 Add `phone` field to `UserDto` class in `packages/data/lib/models/user_dto.dart`.
- [x] 1.2 Update `mockCurrentUser` in `packages/data/lib/sources/mock_data.dart` to include a sample phone number.
- [x] 1.3 Add `updateProfile(UserDto newUser)` method to `Auth` provider in `packages/data/lib/providers/auth_provider.dart`.

## 2. Localization

- [x] 2.1 Add localization keys for Edit Profile (title, name label, email label, phone label, save button, required validation, success message) to `app_en.arb`.
- [x] 2.2 Re-run localization generation (if applicable) or ensure other `.arb` files are updated with placeholders.

## 3. UI Implementation

- [x] 3.1 Create `EditProfileScreen` widget in `packages/profile/lib/screens/edit_profile_screen.dart`.
- [x] 3.2 Implement a form containing text fields for Name, Email, and Phone, utilizing design tokens for styling.
- [x] 3.3 Add an avatar section with an "Edit" or camera affordance (UI only).
- [x] 3.4 Implement form validation (e.g., Name cannot be empty).
- [x] 3.5 Implement save logic connecting to `Auth.updateProfile` and showing a success Snackbar or dialog.

## 4. Navigation & Integration

- [x] 4.1 Update route configuration (e.g., `main.dart` or router) to handle `/profile/edit` navigation.
- [x] 4.2 Update `AccountPreferencesSection` in `packages/profile/lib/widgets/paid_active_account_preferences_section.dart` to navigate to `EditProfileScreen` on "Edit Profile" tap.
- [x] 4.3 Update `ProfileHeader` in `packages/profile/lib/widgets/paid_active_profile_header.dart` to trigger navigation to `EditProfileScreen` on avatar/edit icon tap.
