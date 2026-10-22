## MODIFIED Requirements

### Requirement: Push Notification Tap Navigation Handling
The system SHALL intercept incoming notification URLs and process them through `DeepLinkHandler` before performing navigation.

- **URL Extraction**: When a notification is tapped in foreground, background, or terminated states, `PushNotificationService` SHALL extract the deep link URL from the notification payload (`data['url']` or `data['link']`).
- **Normalized Routing**: `PushNotificationService` SHALL resolve extracted URLs using `DeepLinkHandler.resolve(url)` and validate tab/feature availability against the loaded `InstituteSettings` and build configuration at dispatch time before pushing the route.
- **Unauthenticated Session Persistence**: If a deep link is received while unauthenticated or loading, the raw URL SHALL be retained in memory as pending with a 30-minute TTL and resolved/dispatched once the user transitions to `BootstrapState.authenticated` and institute settings are available. Stale links beyond this window SHALL be discarded to prevent unexpected navigation.
- **Session Cleanup on Logout**: When an authenticated user logs out, `PushNotificationService` SHALL clear any pending deep link to prevent subsequent users logging into the same device from receiving targets intended for the prior session.
- **Feature Availability Fallback**: If a resolved route targets an unavailable tab or disabled feature, `PushNotificationService` SHALL fall back to `/home` (or `/study` if the exam tab is disabled).
- **Tab vs Detail Navigation Dispatching**: Primary tab root destinations (matching `NavTab.values`, e.g. `/home`, `/study`, `/exams`, `/store`, `/profile`, `/ai`) SHALL navigate via `GoRouter.go()` to switch the bottom navigation shell branch, while nested or detail screens (e.g. `/study/lesson/:id`, `/store/product/:slug`) SHALL navigate via `GoRouter.push()` to preserve back navigation.
- **Safe Route Resolution**: Unrecognized, malformed, or arbitrary URLs SHALL normalize safely to `/home` via `DeepLinkHandler.resolve`, ensuring navigation targets are always valid GoRouter routes without displaying error screens.

#### Scenario: User taps notification with dashboard web URL
- **GIVEN** a push notification received with payload `{'url': 'https://staging.testpress.in/dashboard'}`
- **WHEN** the user taps on the notification
- **THEN** `PushNotificationService` SHALL resolve the URL to `/home`
- **AND** the app SHALL navigate to the home dashboard without throwing `GoException`

#### Scenario: User taps notification with lesson web URL
- **GIVEN** a push notification received with payload `{'url': 'https://staging.testpress.in/exams/chapter_content/2054/?content_detail_v2=true'}`
- **WHEN** the user taps on the notification
- **THEN** `PushNotificationService` SHALL resolve the URL to `/study/lesson/2054`
- **AND** the app SHALL navigate to `/study/lesson/2054` directly
