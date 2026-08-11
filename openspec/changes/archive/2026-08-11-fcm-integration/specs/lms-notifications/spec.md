## ADDED Requirements

### Requirement: Preference-based Notification Suppression
The system SHALL respect the user's notification settings and suppress local foreground notification alerts if the notification category is toggled off.

#### Scenario: Suppressing test alerts
- **WHEN** the user has disabled "Test and assessment alerts" in notification preferences
- **AND** an incoming notification is received targeting an exam or chapter URL route
- **THEN** the system MUST suppress local notification display and not show the alert.
