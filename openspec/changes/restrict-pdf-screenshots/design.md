## Context

The app currently uses `SfPdfViewer` (Syncfusion) wrapped in `AppPdfViewer` to render PDF materials. We need to prevent screenshots on this specific screen to protect intellectual property. The `no_screenshot` package provides a declarative way to achieve this using `SecureWidget` on mobile platforms (Android/iOS).

## Goals / Non-Goals

**Goals:**
- Secure the `AppPdfViewer` widget so that when a PDF is being viewed, the OS blocks screenshots (Android and iOS).
- Ensure the app switcher/recents view is protected when the PDF viewer is active.

**Non-Goals:**
- Preventing screenshots on desktop platforms (macOS/Linux/Windows) or Web, as this is either impossible or unreliable due to OS-level limitations.
- Building custom watermark features beyond what is already implemented in the viewer.

## Decisions

**1. Use `SecureWidget` declarative approach**
We will wrap the `SfPdfViewerTheme` inside `AppPdfViewer`'s `build` method with `SecureWidget(mode: OverlayMode.secure)`.
*Rationale:* This approach leverages the Flutter widget lifecycle to automatically turn on the protection when the widget is mounted and turn it off when unmounted. It avoids polluting the state with imperative lifecycle calls (`initState`/`dispose`) and ensures the protection is strictly tied to the PDF viewer's visibility.

**2. Scope of protection**
The `SecureWidget` will only wrap the successfully loaded viewer, not the loading or error states.
*Rationale:* There is no sensitive content visible during loading or error states.

## Risks / Trade-offs

- **Risk:** The package might not perfectly prevent screenshots on older iOS versions or non-standard Android distributions.
  *Mitigation:* This is an accepted limitation of relying on OS-level flags. It handles the vast majority of standard devices.

- **Risk:** `no_screenshot` adds a small amount of native code overhead.
  *Mitigation:* The native footprint of `no_screenshot` is extremely small and primarily invokes standard OS APIs like `FLAG_SECURE`.
