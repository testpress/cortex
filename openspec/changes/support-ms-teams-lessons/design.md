## Context

Users need the ability to join MS Teams video conference lessons directly from the application. We want to enable joining Teams lessons using an in-app WebView, while providing a seamless, auto-join experience that skips Microsoft's "Download App" gate pages.

## Goals / Non-Goals

**Goals:**
- Enable students to join MS Teams lessons via the "Attend Class" button.
- Provide a seamless experience by automatically bypassing the Teams "How do you want to join?" gate page.
- Ensure camera and microphone permissions are requested prior to joining.

**Non-Goals:**
- Reusing `LessonWebView` (it is designed for static content and lacks the necessary JS/Navigation flexibility for the Teams flow).

## Decisions

- **Dedicated WebView**: Created `TeamsVideoConferenceScreen` instead of reusing `LessonWebView`. This allows for unrestricted JavaScript execution and custom navigation handling.
- **Desktop User-Agent Spoofing**: We force a desktop Chrome User-Agent in the WebView. If we don't, Teams detects a mobile device and forces a "Download the Teams App" screen that cannot be bypassed.
- **JavaScript Auto-Join**: We use `TeamsAutoJoinHandler` to inject JavaScript on page load. The JS automatically finds and clicks the "Continue on this browser" button. 
- **Loading Overlay**: To hide the intermediate gate page from the user, a loading overlay covers the WebView. It naturally drops via the `onPageFinished` navigation delegate only after the gate has been bypassed and the final lobby page has loaded.

## Risks / Trade-offs

- [Risk] MS Teams DOM changes. The JavaScript relies on specific CSS selectors (e.g., `[data-tid="joinOnWeb"]`). If Microsoft changes these, the auto-join will timeout. → Mitigation: We implemented text-based fallback selectors and a robust timeout mechanism that drops the loader and shows an error toast if it fails.
- [Risk] iOS vs Android Permission discrepancies. → Mitigation: We use `permission_handler` at the OS level before the WebView initializes, guaranteeing both platforms have hardware access before loading Teams.
