## Why

Currently, push notifications received in the Cortex app only render plain text (title and body) in the system notification panel, ignoring rich media like promotional banners and thumbnails configured in the admin portal. Additionally, clicking a notification containing an external website URL fails to open the browser and instead falls back to `/home`, preventing institutes from redirecting students to external announcements, Google Forms, or external resources.

Supporting rich image notifications and external URL redirects ensures students see promotional/educational imagery directly in the notification shade and are routed seamlessly to either internal screens or external web destinations upon tapping.

## What Changes

- Extract image URLs (`image_url`, `image`, `picture`) from incoming FCM message payloads.
- Download notification images to temporary storage with a resilient network timeout and graceful fallback to text-only display if download fails or times out.
- Display rich notifications with images in the system notification panel using `BigPictureStyleInformation` on Android and media attachments on iOS in both foreground and background/terminated states.
- Support external URL redirection: when a notification payload contains an external web link (`http://` or `https://`) that does not map to internal app routes, open it using `launchUrl` in an external browser.
- Ensure pending link resolution respects external URLs during cold start and authentication bootstrapping.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `fcm-integration`: Add requirements for rich big-picture image display in notifications and external URL redirection support when tapping notifications.

## Impact

- `packages/testpress/lib/providers/push_notification_service.dart`: Update FCM payload extraction, background/foreground notification rendering with image support, and click routing logic.
- `packages/testpress/lib/navigation/deep_link_handler.dart`: Helper check or integration to differentiate between internal routes and external web URLs.
- Dependencies: Uses `url_launcher` (already exported in `core`) and `path_provider` for temporary image caching.

