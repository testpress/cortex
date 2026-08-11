# fcm-integration Specification

## Purpose
Provides a client-side Firebase Cloud Messaging (FCM) integration that handles notification permission requests, parses message payloads, routes deep links, and displays foreground alerts.
## Requirements
### Requirement: Request Notification Permissions
The system SHALL request runtime POST_NOTIFICATIONS permissions on Android and iOS platforms to send alerts to the user.

#### Scenario: Granting permission on startup
- **WHEN** the application starts up
- **THEN** the system MUST request push notification permissions from the OS.
- **AND** if permission is granted, FCM tokens can be initialized and retrieved.

### Requirement: Foreground Local Notification Display
The system SHALL display local notification alerts for incoming FCM payloads when the application is running in the foreground.

#### Scenario: Receiving a notification in foreground
- **WHEN** a message payload is received while the application is in the foreground
- **THEN** the system MUST render a local notification alert with the message's title and description.

### Requirement: Deep Link Navigation Routing
The system SHALL extract target URLs from the notification payload and route users to the corresponding screen within the application.

#### Scenario: Tapping on a notification
- **WHEN** a user taps on a notification containing a valid short URL deep link
- **THEN** the system MUST navigate to the target route using the application's GoRouter instance.

