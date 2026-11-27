## MODIFIED Requirements

### Requirement: Deep Link Navigation Routing
The system SHALL intercept incoming notification URLs and process them through `DeepLinkHandler` before performing navigation, routing users to the corresponding internal screen or external website destination.

- **URL Extraction**: When a notification is tapped in foreground, background, or terminated states, `PushNotificationService` SHALL extract the deep link URL from the notification payload (`data['url']` or `data['link']`).
- **Normalized Routing**: `PushNotificationService` SHALL resolve extracted URLs using `DeepLinkHandler.resolve(url)` and validate tab/feature availability against the loaded `InstituteSettings` and build configuration at dispatch time before pushing the route.
- **Unauthenticated Session Persistence**: If an internal deep link is received while unauthenticated or loading, the raw URL SHALL be retained in memory as pending with a 30-minute TTL and resolved/dispatched once the user transitions to `BootstrapState.authenticated` and institute settings are available. Stale links beyond this window SHALL be discarded to prevent unexpected navigation. External URLs SHALL NOT be queued and SHALL launch directly.
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

#### Scenario: Tapping on a notification with an external website URL
- **WHEN** a user taps on a notification containing an external http or https URL not mapped to an internal route
- **THEN** the system MUST launch the URL in the system browser using external application mode.

#### Scenario: Tapping on an external URL while unauthenticated
- **WHEN** a user taps on a notification containing an external website URL while unauthenticated
- **THEN** the system MUST intentionally launch the external URL directly in the system browser without gating behind user login or queuing for post-authentication.

#### Scenario: Tapping on a notification with an unmapped or invalid URL
- **WHEN** a user taps on a notification without a valid or recognized destination
- **THEN** the system MUST fall back safely to the application home dashboard.

