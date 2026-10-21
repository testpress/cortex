## ADDED Requirements

### Requirement: Inline Iframe Video Rendering
The `AppHtmlV2` widget SHALL detect `<iframe>` elements in HTML content and render them as inline, responsive embedded views without dropping the iframe or breaking the surrounding native text layout.

#### Scenario: Renders iframe as embedded responsive view
- **WHEN** HTML containing an `<iframe>` tag (such as YouTube or Vimeo) is passed to `AppHtmlV2`
- **THEN** the iframe is rendered inline within a 16:9 aspect ratio container with rounded corners matching the design system
- **AND** the surrounding paragraphs, headings, and images continue to be rendered natively by Flutter

### Requirement: Secure and Error-Resistant Origin Handling
The embedded iframe viewer SHALL load iframe URLs using an authorized HTTPS base URL (e.g., `https://www.testpress.in`) and unrestricted JavaScript mode to prevent origin mismatch errors (such as YouTube Error 153).

#### Scenario: Playing embedded YouTube video
- **WHEN** an iframe with `src="https://www.youtube.com/embed/..."` is rendered
- **THEN** the WebView initializes with a valid HTTPS origin
- **AND** the video player loads and plays inline without blocking or crashing

### Requirement: Scroll Interaction Stability
The inline iframe view SHALL support touch interactions for playback controls without seizing or locking the vertical scrolling gestures of the parent scroll view.

#### Scenario: Scrolling past an embedded video
- **WHEN** the user drags vertically outside or across the video embed in a scrollable view (e.g. `ProductDetailScreen`)
- **THEN** the parent scroll view scrolls smoothly without pointer deadlock

### Requirement: Navigation and Scheme Guardrails
The embedded iframe viewer SHALL intercept navigation requests to prevent unsupported OS schemes from crashing the WebView and prevent users from navigating away from the embedded lesson content.

#### Scenario: Unsupported scheme navigation (such as Android Intent)
- **WHEN** the user or embed triggers an external scheme navigation (e.g., `intent://`, `market://`, `vnd.youtube:`)
- **THEN** the navigation request is prevented
- **AND** the WebView does not display an `ERR_UNKNOWN_URL_SCHEME` error page

#### Scenario: Navigation away from the video embed
- **WHEN** the user clicks external links, channel links, or non-embed video links inside the player
- **THEN** navigation outside the embed URL is prevented, keeping the user focused on the intended content

### Requirement: Immediate Inline Appearance
The embedded iframe viewer SHALL mount the player directly without blocking overlays or artificial delays so that video thumbnails and play controls appear immediately.

#### Scenario: Loading the video container
- **WHEN** the embedded iframe view is initialized
- **THEN** the webview is immediately visible without an artificial spinner overlay covering the player

