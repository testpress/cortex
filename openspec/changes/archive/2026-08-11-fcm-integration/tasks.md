## 1. Setup & Configuration

- [x] 1.1 Add firebase_core, firebase_messaging, and flutter_local_notifications packages in pubspec.yaml files.
- [x] 1.2 Conditionally apply google-services plugin and configure core library desugaring in Android build files.
- [x] 1.3 Add POST_NOTIFICATIONS permissions and default notification icon metadata in AndroidManifest.xml.

## 2. API & Data Layer Implementation

- [x] 2.1 Add registerDevice endpoint constant mapping in ApiEndpoints class.
- [x] 2.2 Implement registerDeviceToken contracts inside DataSource, HttpDataSource, MockDataSource, and UserRepository.

## 3. Core Service Implementation

- [x] 3.1 Initialize Firebase Core safely in initialization_provider.dart.
- [x] 3.2 Implement PushNotificationService supporting foreground/background listeners, local channels, and GoRouter deep-link matching.
- [x] 3.3 Set up authenticated device token synchronization on boot, token refresh, and login events.

## 4. Preference Toggles Integration

- [x] 4.1 Read notificationPreferencesProvider inside PushNotificationService.
- [x] 4.2 Filter and suppress local foreground notification banners according to active preference toggle states.
