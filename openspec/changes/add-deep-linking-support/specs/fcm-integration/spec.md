## MODIFIED Requirements

### Requirement: Push Notification Tap Navigation Handling
The system SHALL intercept incoming notification URLs and process them through `DeepLinkHandler` before performing navigation.

- **URL Extraction**: When a notification is tapped in foreground, background, or terminated states, `PushNotificationService` SHALL extract the deep link URL from the notification payload (`data['url']` or `data['link']`).
- **Normalized Routing**: `PushNotificationService` SHALL pass the extracted URL to `DeepLinkHandler.resolve(url)` and navigate using `GoRouter` with the resolved route.
- **Unauthenticated Session Persistence**: If a deep link is received while unauthenticated or loading, the target route SHALL be retained in memory with a 30-minute TTL and dispatched once the user transitions to `BootstrapState.authenticated`. Stale links beyond this window SHALL be discarded to prevent unexpected navigation.
- **Graceful Error Handling**: If resolution or navigation throws an unexpected exception, the system SHALL catch the error, log it, and navigate the user to `/home` to maintain a seamless user experience.

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
