## Why

Students need a direct communication channel with their institute's instructors and support staff to ask administrative questions, resolve doubts, and receive academic assistance.

The messaging interface is hosted on the Testpress web platform (`/messages/?testpress_app=1`). Embedding this interface inside Cortex via `AppWebView` with single sign-on (SSO) enables students to access their messages directly within the mobile app.

## What Changes

- Add `messagesEnabled` (and optional `messagesLabel`) to `InstituteSettings` parsed from `/api/v2.3/settings/`.
- Introduce `messagesUrlProvider` in `packages/testpress` to resolve the presigned SSO URL targeting `/messages/?testpress_app=1` with custom institute domain fallback.
- Create `MessagesScreen` in `packages/testpress/lib/screens/messages_screen.dart` utilizing `AppWebView` with camera/storage permissions, custom header with back navigation, and error/loading states.
- Support Android hardware/gesture back navigation using `PopScope` to navigate backward in WebView history before popping the screen.
- Register `/messages` in `GlobalRoutes.immersiveRoutes`.
- Add a "Messages" entry point in `DashboardDrawer` visible when `messagesEnabled` is true.
- Add localization strings for Messages in `AppLocalizations`.

## Capabilities

### New Capabilities
- `messages-screen`: WebView-based messages screen with presigned SSO authentication, custom navigation header, back navigation delegate, and embedded `AppWebView`.

### Modified Capabilities
- `institute-settings`: Extend `InstituteSettings` to parse and expose `messages_enabled` and `messages_label`.

## Impact

- **Packages**: `packages/core` (`InstituteSettings`, l10n strings) and `packages/testpress` (`MessagesScreen`, `DashboardDrawer`, `GlobalRoutes`, URL provider).
- **APIs**: Consumes existing `getPresignedSsoUrl()` API and institute settings endpoint.
- **Dependencies**: Uses existing `AppWebView` and `permission_handler` from `packages/core`.
