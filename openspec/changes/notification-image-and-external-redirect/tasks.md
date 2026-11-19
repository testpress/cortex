## 1. Payload Parsing and Image Download

- [x] 1.1 Add `notificationImageUrlFromMessage` helper to extract image URLs across known payload keys (`image_url`, `image`, `picture`, `notification.android.imageUrl`)
- [x] 1.2 Implement `downloadNotificationImage` utility with strict timeout and safe exception handling returning temporary file path or null
- [x] 1.3 Add unit tests for payload image extraction and download fallback behavior

## 2. Rich Notification Display

- [x] 2.1 Update `notificationDetailsForChannel` to construct `BigPictureStyleInformation` (Android) and `DarwinNotificationAttachment` (iOS) when an image file path is provided
- [x] 2.2 Integrate image download and rich notification details into `_showLocalNotification` (foreground)
- [x] 2.3 Integrate image download and rich notification details into `firebaseMessagingBackgroundHandler` (background/terminated)

## 3. External URL Redirection

- [x] 3.1 Update `_dispatchRoute` in `PushNotificationService` to distinguish external web URLs from internal app routes
- [x] 3.2 Launch external URLs using `launchUrl(..., mode: LaunchMode.externalApplication)` with fallback to `/home` on invalid schemes
- [x] 3.3 Ensure cold start / unauthenticated pending links preserve and dispatch external URLs appropriately

## 4. Verification and Regression Testing

- [x] 4.1 Add unit tests for external URL routing and fallback behavior in `push_notification_service_test.dart`
- [x] 4.2 Run existing test suite for deep link handling and push notifications to verify zero regression
