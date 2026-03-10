# Capability: lms-profile

## MODIFIED Requirements

### Requirement: Centered Profile Header
The system SHALL display a centered profile header providing a clear identity overview.

#### Scenario: Displaying profile identity
- **WHEN** the `ProfilePage` is rendered in the `profile` package
- **THEN** it MUST show a centered circular avatar (80×80)
- **AND** the user's name MUST be displayed in bold (20px semibold) below the avatar
- **AND** a membership subtext SHALL be visible.
- **AND** a neutral edit affordance SHALL appear in the top-right corner of the identity card.
- **AND** tapping the edit affordance MUST navigate to the `EditProfileScreen`.

### Requirement: Account & Preferences Menu
The system SHALL provide access to account settings and application preferences as a list of actions.

#### Scenario: Navigating account settings
- **WHEN** viewing the `ProfilePage` in the `profile` package
- **THEN** the system MUST display a list card containing: Edit Profile, Notifications, Certificates, App Settings, and Logout.
- **AND** each item MUST have its specific icon, label, and a chevron-right transition indicator.
- **AND** tapping "Edit Profile" MUST navigate to the `EditProfileScreen`.
