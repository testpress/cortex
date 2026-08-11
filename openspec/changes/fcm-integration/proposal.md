## Why

To support push notification delivery from the Testpress backend, the mobile application must retrieve its Firebase Cloud Messaging (FCM) registration token, register it with the backend server, listen to incoming messages, and route deep links to the target screen content.

## What Changes

- **Firebase Core & Messaging Setup**: Add dependency packages and initialize Firebase Core and Messaging on app boot.
- **Dynamic Google Services Gradle Configuration**: Conditionally apply the `google-services` plugin and configuration on Android to make local developer compilation robust even when configuration credentials are not present.
- **Push Notification Service**: Implements notification permission requests, background/foreground message listeners, local system notification channel setup, and deep-link target routing.
- **Authenticated Device Token Syncing**: Implements `/api/v2.2/devices/register/` POST endpoint to store GCM/FCM registration IDs on the Testpress backend.
- **Preference-based Suppression**: Suppress foreground notification alerts if user settings have toggled off alerts for the respective category (exams, chapters, live classes, posts).

## Capabilities

### New Capabilities
- `fcm-integration`: Implements Firebase Cloud Messaging core integration, permission management, background and foreground notification handling, and GoRouter deep-link matching.
- `fcm-device-registration`: Synchronizes client FCM registration tokens with the Testpress backend database to link active user sessions to their target device.

### Modified Capabilities
- `lms-notifications`: Integrates runtime suppression logic to filter foreground push notifications matching toggled-off preferences.

## Impact

- **Affected Code**: `packages/core`, `packages/testpress`
- **Android Integration**: `app/android/app/build.gradle.kts`, `app/android/settings.gradle.kts`, `AndroidManifest.xml`
- **Build Scripts**: `app/scripts/client_utils.dart`, `app/scripts/run_client.dart`, `app/scripts/generate_client_app.dart`
- **External Dependencies**: `firebase_core`, `firebase_messaging`, `flutter_local_notifications`
- **APIs**: Hitting POST `/api/v2.2/devices/register/` with `registration_id` and `device_id`.
