## ADDED Requirements

### Requirement: Logout Confirmation
The system SHALL display an `AppBottomSheet` confirmation prompt before proceeding with the logout action.

#### Scenario: User triggers logout
- **WHEN** the user taps the Logout item in the Account Preferences section
- **THEN** a bottom sheet appears with:
  - An `alertTriangle` icon (error color)
  - Title: "Log out?"
  - Message: "You'll need to log in again to access your account"
  - Primary button: "Log out" (error theme with `logOut` icon)
  - Secondary button: "Cancel" (standard theme)

### Requirement: Logout UI Aesthetics
The confirmation prompt SHALL align with the application's design system, utilizing standard design tokens for typography, spacing, and colors. The layout SHALL be centered.

#### Scenario: Logout prompt visuals
- **WHEN** the logout confirmation prompt is displayed
- **THEN** it features a centered alignment for all text and icons, with buttons stacked vertically.

### Requirement: Post-Logout Navigation
The system SHALL navigate the user to the application's home or entry screen in a "guest" state immediately after the logout action is confirmed.

#### Scenario: Successful logout navigation
- **WHEN** the user confirms the logout in the confirmation prompt
- **THEN** the prompt closes and the user is redirected to the home screen (`/home`) with unauthenticated access.
