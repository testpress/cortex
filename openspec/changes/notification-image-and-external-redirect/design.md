## Context

Push notifications in Cortex are powered by `packages/testpress/lib/providers/push_notification_service.dart` and `flutter_local_notifications`. When the Testpress backend sends data-only FCM messages, Cortex displays them locally using standard text alerts, and clicks are routed through `DeepLinkHandler.resolve()`. Currently, there are two gaps:
1. Payloads with image banners are shown as plain text without any visual media.
2. Clicking notifications with external links (e.g. `https://google.com` or external survey/registration links) fails to open a browser and falls back to `/home`.

## Goals / Non-Goals

**Goals:**
- Extract image URLs cleanly across backend-supported keys (`image_url`, `image`, and standard FCM `notification.android.imageUrl` / `notification.apple.imageUrl`).
- Extract redirect destination URLs respecting the backend contract: `SendNotificationTask` transmits `"destination_url": notification.destination_url or ""` along with a fallback `"short_url": reverse("dashboard_v1")`. Therefore, `destination_url` takes top precedence when present, seamlessly falling back to `short_url` (or `url`/`link`/`redirect_url`) when empty.
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

### Decision 2: Short Network Timeout and 2 MB Size Cap with Non-Blocking Fallback
- **Decision:** Enforce a strict 5-second timeout and a 2 MB size limit on image downloads. Reject immediately if `Content-Length > 2 MB`, and abort the stream early if accumulated bytes exceed 2 MB. If the download fails, times out, exceeds the size limit, or receives a non-200 status, return `null` and immediately render the standard text notification.
- **Rationale:** Notifications are time-sensitive alerts. A slow, failing, or oversized image request must never suppress notification display, delay alerts, or cause Out-Of-Memory (OOM) crashes in the background isolate.

### Decision 3: External URL Differentiation and Trust Assumptions in Deep Link Dispatching
- **Decision:** In `_dispatchRoute`, evaluate whether the target link is an external web link (`http://` or `https://`) that does not map to a recognized internal application route. If external, launch with `launchUrl(uri, mode: LaunchMode.externalApplication)`. If internal, navigate via GoRouter.
- **Rationale:** `DeepLinkHandler.resolve` returns `defaultRoute` (`/home`) for any unmapped route. By checking URL characteristics before or alongside resolution, we preserve existing internal routing while enabling direct external browser launches.
- **Trust Assumption & Admin Authorization:** Push notification payloads originate exclusively from the authenticated Testpress backend via secure FCM server credentials. Only authorized institute admins can configure notification URLs. Per customer requirements from the Siddhi Prep PDR (matching Classplus Campaigns workflows), admins need the ability to broadcast links to YouTube videos, webinar registrations, or external resources alongside product and course destinations. Restricting this via a client-side allowlist would break legitimate admin broadcasts.
- **Separation from In-App WebViews (`AppWebView`, `lesson_webview`, `AppIframeView`):** This external redirect is completely independent of in-app study webviews. In-app webviews enforce strict navigation locks to prevent students from navigating away while studying or taking exams. Notification external redirects, by contrast, are explicit admin-directed announcements launched entirely outside Cortex in the system browser or native handler (e.g. YouTube app) via `LaunchMode.externalApplication`, ensuring full OS-level sandbox isolation.

## Risks / Trade-offs

- **[Risk] Accumulation of temporary image files** → **Mitigation:** In `_saveToTempFile`, automatically prune old `notif_img_*` files before saving a new image, strictly capping the cache to the 5 most recent notification images.
- **[Risk] Unbounded image download causing OOM in background isolate** → **Mitigation:** Enforce a 2 MB upper limit (`maxBytes`) checked against `Content-Length` and aborted early during stream consumption.
- **[Risk] Network failure in background isolate** → **Mitigation:** Wrap image download logic in a broad `try-catch` block returning `null`, guaranteeing the local notification is displayed with text.
- **[Risk] Malformed or javascript: URLs** → **Mitigation:** Only launch external URLs with explicit `http` or `https` schemes via `launchUrl`.

