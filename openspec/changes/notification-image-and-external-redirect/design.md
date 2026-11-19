## Context

Push notifications in Cortex are powered by `packages/testpress/lib/providers/push_notification_service.dart` and `flutter_local_notifications`. When the Testpress backend sends data-only FCM messages, Cortex displays them locally using standard text alerts, and clicks are routed through `DeepLinkHandler.resolve()`. Currently, there are two gaps:
1. Payloads with image banners are shown as plain text without any visual media.
2. Clicking notifications with external links (e.g. `https://google.com` or external survey/registration links) fails to open a browser and falls back to `/home`.

## Goals / Non-Goals

**Goals:**
- Extract image URLs defensively across known keys (`image_url`, `image`, `picture`, `notification.android.imageUrl`).
- Download images safely to local temporary storage with strict timeouts and robust fallback to text-only display if downloading fails.
- Render rich big-picture notifications on Android and attachments on iOS across foreground and background isolates.
- Distinguish between internal deep links and external URLs upon notification tap, routing internal links via GoRouter and external URLs via `url_launcher`.

**Non-Goals:**
- Native iOS Notification Service Extension (NSE) target configuration in Xcode for terminated iOS background isolates (deferred unless specifically required by iOS app release pipeline).
- Custom interactive notification action buttons.

## Decisions

### Decision 1: Download to Local File Cache vs In-Memory Bitmaps
- **Decision:** Download image bytes using `HttpClient` to `getTemporaryDirectory()` and reference them via `FilePathAndroidBitmap` and `DarwinNotificationAttachment`.
- **Rationale:** Android Binder IPC has a transaction limit of ~1MB; passing raw byte buffers via `ByteArrayAndroidBitmap` over platform channels risks `TransactionTooLargeException` on high-resolution images. Local files avoid IPC payload bloat and are natively supported by both Android and iOS notification plugins.
- **Alternatives considered:** `ByteArrayAndroidBitmap` (rejected due to Binder limits); downloading in native Kotlin/Swift (rejected to keep logic unified in Dart).

### Decision 2: Short Network Timeout with Non-Blocking Fallback
- **Decision:** Enforce a strict 5-second timeout on image downloads. If the download fails, times out, or receives a non-200 status, return `null` and immediately render the standard text notification.
- **Rationale:** Notifications are time-sensitive alerts. A slow or failing image request must never suppress, delay indefinitely, or crash the notification alert.

### Decision 3: External URL Differentiation in Deep Link Dispatching
- **Decision:** In `_dispatchRoute`, evaluate whether the target link is an external web link (`http://` or `https://`) that does not map to a recognized internal application route. If external, launch with `launchUrl(uri, mode: LaunchMode.externalApplication)`. If internal, navigate via GoRouter.
- **Rationale:** `DeepLinkHandler.resolve` returns `defaultRoute` (`/home`) for any unmapped route. By checking URL characteristics before or alongside resolution, we preserve existing internal routing while enabling direct external browser launches.

## Risks / Trade-offs

- **[Risk] High-volume notifications filling temp storage** → **Mitigation:** Use unique sanitized filenames in the OS temporary directory (`getTemporaryDirectory()`), which the operating system automatically clears under storage pressure.
- **[Risk] Network failure in background isolate** → **Mitigation:** Wrap image download logic in a broad `try-catch` block returning `null`, guaranteeing the local notification is displayed with text.
- **[Risk] Malformed or javascript: URLs** → **Mitigation:** Only launch external URLs with explicit `http` or `https` schemes via `launchUrl`.

