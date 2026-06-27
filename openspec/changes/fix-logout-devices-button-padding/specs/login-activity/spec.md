## ADDED Requirements

### Requirement: Log out other devices button visual spacing
The "Log out other devices" button SHALL have sufficient bottom padding to remain fully visible above the device's system UI (home indicator or gesture bar), using the same spacing convention as other bottom-anchored primary action buttons in the app.

#### Scenario: Button visible above home indicator
- **WHEN** the Login Activity screen is displayed on a device with a bottom gesture bar or home indicator
- **THEN** the "Log out other devices" button SHALL be positioned fully above the system UI area with consistent bottom spacing

#### Scenario: Button spacing on devices without a gesture bar
- **WHEN** the Login Activity screen is displayed on a device without a bottom gesture bar
- **THEN** the "Log out other devices" button SHALL retain its standard bottom spacing, identical to other primary action buttons
