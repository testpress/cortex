## Context

The application lacks a student performance report view in the mobile app. The web platform has a `/report/` path that can serve this personal dashboard for users.

## Goals / Non-Goals

**Goals:**
- Load personalized reports using an authorized `AppWebView`.
- Normalize schemes and support custom white-labeled domain URLs.
- Style the header consistent with modern cards (matching custom exam selection and offline exams list screen).
- Add the drawer item conditionally.
- Provide full localization across supported languages (English, Arabic, Malayalam, and Tamil).

**Non-Goals:**
- Native rendering of report charts/data (webview-only).
- Modifying other drawer list order or platform styling.

## Decisions

- **Core WebView Utility**: Created `AppWebView` as a core primitive using `webview_flutter`. It automatically appends authentication headers (JWT Token) securely when accessing trusted hosts.
- **Custom Header**: Used `ColoredBox(color: design.colors.card)`, `SafeArea(bottom: false)`, `AppFocusable`, `AppSemantics`, and `context.pop()` to match visual alignment with offline exam and custom exam headers, ensuring consistent touch targets and aesthetics.
- **Drawer Item Visibility**: Added `MyReportScreen` to dashboard drawer and IMMERSIVE routes, dynamically checking `InstituteSettings.disableStudentReport`.

## Risks / Trade-offs

- **Authentication Token Lifespan**: Webview passes JWT on initial request, but token expiration inside webview is handled by the server session/cookies.
- **Network Errors**: Mitigated by providing `AppErrorView` with retry capability in `AppWebView`.
