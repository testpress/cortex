## 1. Logout UI Components

- [x] 1.1 Create `LogoutConfirmationSheet` in `packages/profile/lib/widgets/logout_confirmation_sheet.dart`.
- [x] 1.2 Implement centered layout with `LucideIcons.alertTriangle` in a themed container (56x56, error background with low opacity).
- [x] 1.3 Add title "Log out?" and message "You'll need to log in again to access your account".
- [x] 1.4 Implement stacked buttons: "Log out" (error theme, with `LucideIcons.logOut`) and "Cancel" (standard styling).

## 2. Integration and Navigation

- [x] 2.1 Update `AccountPreferencesSection` to show `LogoutConfirmationSheet` on logout tap.
- [x] 2.2 Define navigation to `/home` upon confirmation.
- [x] 2.3 Verify the interaction flow matches the defined design specifications.
