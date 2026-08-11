## Context

See proposal.md - Why. Currently, the application lacks push notification listeners, local system notification channel registrations, and device token mapping with the Testpress backend.

## Goals / Non-Goals

**Goals:**
- Implement a robust foreground and background push notification listener system using Firebase Cloud Messaging (FCM).
- Setup local system notification channels to handle foreground alert rendering.
- Maintain an authenticated device token registration flow using the Testpress REST API.
- Respect user preference toggles dynamically at runtime.

**Non-Goals:**
- Managing push notifications or Celery queues on the server side.
- Managing local database persistence for notifications history.

## Decisions

### Safe Core Initialization
We register `Firebase.initializeApp()` inside a try-catch wrapper in `initialization_provider.dart`. 
* **Rationale**: Avoids startup crashes for developers running the codebase without a local `google-services.json` file.
* **Alternative**: Requiring credentials to run. Rejected because it blocks testing and CI workflows.

### Decoupled Data Layer for Device Registration
We expose the device registration REST calls via `DataSource` / `HttpDataSource` -> `UserRepository` -> `PushNotificationService`.
* **Rationale**: Decouples networking logic from UI/service layer. Follows SDK-first monorepo design principles.
* **Alternative**: Directly posting JSON using Dio inside the notification service. Rejected because it violates separation of concerns.

### Foreground Local Notifications
We use `flutter_local_notifications` for foreground notification delivery on Android.
* **Rationale**: FCM does not display heads-up banners on Android when the app is in the foreground. Using local notifications enables foreground banners while matching user preference settings.

## Risks / Trade-offs

- **[Risk]** FCM Token Refreshes. -> **Mitigation**: Listen to `messaging.onTokenRefresh` and trigger automated re-registration on backend.
- **[Risk]** Token Mismatch. -> **Mitigation**: Perform registration POST requests only when user is authenticated (`isLoggedIn`).
