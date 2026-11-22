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
The system SHALL display local notification alerts for incoming FCM payloads when the application is running in the foreground, including rich image attachments when provided.

#### Scenario: Receiving a notification in foreground with plain text
- **WHEN** a message payload without an image is received while the application is in the foreground
- **THEN** the system MUST render a standard local notification alert with the message's title and body/description.

#### Scenario: Receiving a notification in foreground with an image
- **WHEN** a message payload with a valid image URL is received while the application is in the foreground
- **THEN** the system MUST download the image and display it as a rich big-picture notification in the notification panel.

#### Scenario: Graceful fallback when image download fails
- **WHEN** an image URL in the notification payload fails to download or times out
- **THEN** the system MUST gracefully fall back to rendering the notification with title and body without suppressing or dropping the notification.

### Requirement: Deep Link Navigation Routing
The system SHALL extract target URLs from the notification payload and route users to the corresponding internal screen or external website destination.

#### Scenario: Tapping on a notification with an internal deep link
- **WHEN** a user taps on a notification containing a recognized internal route or short URL
- **THEN** the system MUST navigate to the target screen using the application's GoRouter instance.

#### Scenario: Tapping on a notification with an external website URL
- **WHEN** a user taps on a notification containing an external http or https URL not mapped to an internal route
- **THEN** the system MUST launch the URL in the system browser using external application mode.

#### Scenario: Tapping on an external URL while unauthenticated
- **WHEN** a user taps on a notification containing an external website URL while unauthenticated
- **THEN** the system MUST intentionally launch the external URL directly in the system browser without gating behind user login or queuing for post-authentication.

#### Scenario: Tapping on a notification with an unmapped or invalid URL
- **WHEN** a user taps on a notification without a valid or recognized destination
- **THEN** the system MUST fall back safely to the application home dashboard.

### Requirement: Background Rich Notification Display
The system SHALL support displaying rich big-picture notifications from backend data-only FCM messages when the application is backgrounded or terminated on supported platforms.

#### Scenario: Receiving a background notification with an image
- **WHEN** a background data-only FCM message is received containing an image URL
- **THEN** the background messaging handler MUST download the image to temporary storage and display a rich notification with the image in the system notification panel.

