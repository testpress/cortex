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

### Decision 2: Single Overall 8-Second Download Deadline and 2 MB Size Cap with Non-Blocking Fallback
- **Decision:** Enforce a single overall 8-second deadline and a 2 MB size limit on image downloads. Reject immediately if `Content-Length > 2 MB`, abort the stream early if accumulated bytes exceed 2 MB, and cap total download and temp-file preparation to 8 seconds. If the download fails, times out, exceeds the size limit, or receives a non-200 status, return `null` and immediately render the standard text notification.
- **Rationale:** Android background execution limits allocate a short window (~20s) for FCM background handlers. Sequential compounding timeouts (e.g. 5s connect + 5s headers + 5s stream idle = 15s+) risk exceeding the OS execution budget and causing process termination before notifications are displayed. A single 8-second overall deadline guarantees that notification delivery is never starved by slow image assets, leaving ample headroom to display the text notification reliably.

### Decision 3: External URL Differentiation and Host Validation in Deep Link Dispatching
- **Decision:** In `DeepLinkHandler.tryResolve` and `_dispatchRoute`, require that full HTTP(S) URLs belong to Testpress (`testpress.in`, `*.testpress.in`) or match the configured institute domain (`appHost`) to be routed internally. Any third-party HTTP(S) URL (e.g. `https://youtube.com/...`, `https://udemy.com/...`, `https://evil.com/...`) is treated as an external web URL and launched externally in the system browser via `launchUrl(uri, mode: LaunchMode.externalApplication)`.
- **Rationale:** Previously, `tryResolve` evaluated only `pathSegments`, meaning any external URL sharing path structure with internal routes (such as `https://partner.com/courses/123`) would inadvertently be hijacked and routed internally to an in-app course screen. Requiring an internal host or tenant domain check ensures third-party links broadcast by admins always open in the system browser as expected while still supporting custom institute domains.
- **Trust Assumption & Admin Authorization:** Push notification payloads originate exclusively from the authenticated Testpress backend via secure FCM server credentials. Only authorized institute admins can configure notification URLs. Per customer requirements from the Siddhi Prep PDR (matching Classplus Campaigns workflows), admins need the ability to broadcast links to YouTube videos, webinar registrations, or external resources alongside product and course destinations. Restricting this via a client-side allowlist would break legitimate admin broadcasts.
- **Unauthenticated External Link Launching:** In `_handleDeepLink`, external URLs are intentionally launched immediately without requiring prior authentication. Because external URLs open outside the app in the system browser and contain no sensitive in-app user session data, gating them behind mobile login would create unnecessary friction for public broadcasts (such as webinar registrations, marketing campaigns, or public feedback surveys).
- **Separation from In-App WebViews (`AppWebView`, `lesson_webview`, `AppIframeView`):** This external redirect is completely independent of in-app study webviews. In-app webviews enforce strict navigation locks to prevent students from navigating away while studying or taking exams. Notification external redirects, by contrast, are explicit admin-directed announcements launched entirely outside Cortex in the system browser or native handler (e.g. YouTube app) via `LaunchMode.externalApplication`, ensuring full OS-level sandbox isolation.

## Risks / Trade-offs

- **[Risk] Accumulation of temporary image files** → **Mitigation:** In `_saveToTempFile`, automatically prune old `notif_img_*` files before saving a new image, strictly capping the cache to the 5 most recent notification images.
- **[Risk] Unbounded image download causing OOM in background isolate** → **Mitigation:** Enforce a 2 MB upper limit (`maxBytes`) checked against `Content-Length` and aborted early during stream consumption.
- **[Risk] Network failure in background isolate** → **Mitigation:** Wrap image download logic in a broad `try-catch` block returning `null`, guaranteeing the local notification is displayed with text.
- **[Risk] Malformed or javascript: URLs** → **Mitigation:** Only launch external URLs with explicit `http` or `https` schemes via `launchUrl`.
- **[Risk] Cleartext HTTP image requests** → **Mitigation:** In `_parseAndValidateImageUrl`, strictly require the `https` scheme. Cleartext `http://` image downloads are rejected to align with Android cleartext network security policy and iOS App Transport Security (ATS).

