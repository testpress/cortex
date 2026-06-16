## 1. DashboardHeader Status Bar Fix

- [ ] 1.1 Analyze `DashboardHeader` in `packages/core/lib/widgets/dashboard_header.dart` and modify its padding logic. Ensure the `Container` background color spans to the top edge while content respects safe area padding.
- [ ] 1.2 Verify `ProfilePage` (`packages/profile/lib/screens/paid_active_profile_screen.dart`) and ensure no outer `SafeArea` prevents the header from drawing into the status bar area.

## 2. Inline Tab Headers Status Bar Fix

- [x] 2.1 Update `StudyScreen`'s inline header to extend its background color to the top edge while properly pushing content down below the status bar.
- [x] 2.2 Scan other main tab screens (e.g., `ExamsScreen`) for similar inline headers and apply the exact same status bar merging fix where necessary.

## 3. Profile Sub-Screen Back Buttons Polish

- [x] 3.1 Update the `EditProfileScreen` header layout to vertically center the back icon and text with identical spacing constraints.
- [x] 3.2 Update the `NotificationsScreen` header layout to vertically center the back icon and text with the same identical constraints.
- [x] 3.3 Update the `CertificatesScreen` header layout to vertically center the back icon and text, and update its icon color to explicitly match the standard text primary token used by the other screens.
,