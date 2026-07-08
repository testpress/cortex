## ADDED Requirements

### Requirement: Dynamic Branding Integration
The system SHALL display the organization's dynamic branding (e.g., logo or text-based institute name) at the top of the authentication screens, utilizing `instituteSettingsProvider`, while removing the legacy carousel UI.

#### Scenario: App loads login screen
- **WHEN** the user navigates to any authentication screen
- **THEN** they see the correctly formatted logo or institute name at the top center of the screen, styled according to the new design system.

### Requirement: Email and Password Input
The system SHALL provide input fields for the user's email address and password on the Login screen, matching the Figma design system.

#### Scenario: User enters credentials
- **WHEN** the user navigates to the Login screen
- **THEN** they see standard text fields for "Email" and "Password" with appropriate typography and styling.

### Requirement: 4-Digit OTP Verification
The system SHALL provide an OTP verification screen with exactly 4 input boxes for code entry, overriding the Figma's 6-digit design.

#### Scenario: User enters OTP
- **WHEN** the user is prompted to verify their mobile number or email
- **THEN** they see a screen with exactly 4 boxed inputs for the code, a "Resend" countdown, and a primary "Verify" button.

### Requirement: Dynamic Login Options
The system SHALL dynamically render the allowed login options (e.g., Email, Mobile, Google) using the new button styles.

#### Scenario: User sees login options
- **WHEN** the user lands on the primary authentication screen
- **THEN** the system displays only the options enabled in `instituteSettingsProvider` styled as per the new Figma design.
