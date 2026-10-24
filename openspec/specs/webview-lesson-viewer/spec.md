# webview-lesson-viewer Specification

## Purpose
TBD - created by archiving change integrate-lesson-detail-ui. Update Purpose after archive.
## Requirements
### Requirement: Single-Root HTML Rendering
All rich-text and embed contents MUST be rendered through a unified `WebView` to ensure layout fidelity for iframes and complex HTML.

#### Scenario: Rendering HTML Notes
- **WHEN** A lesson has type `notes`
- **THEN** The content is rendered inside a WebView with CSS injected to match the app's primary typography.

#### Scenario: Rendering Video Embeds
- **WHEN** A lesson has type `embedContent`
- **THEN** The WebView player is used instead of the native DRM player.

### Requirement: External Hyperlink Delegation
The `LessonWebView` SHALL intercept top-level (`isMainFrame == true`) HTTP and HTTPS navigation requests and delegate them via `url_launcher` in in-app browser mode (`LaunchMode.inAppBrowserView`), while preventing internal WebView navigation. Subframe navigations (`isMainFrame == false`) for HTTP/HTTPS iframe embeds SHALL be permitted to load internally.

#### Scenario: Tapping external hyperlink in notes
- **WHEN** the user taps an `http` or `https` link in lesson notes (`isMainFrame == true`)
- **THEN** navigation is intercepted with `NavigationDecision.prevent`
- **AND** the URL is launched via `LaunchMode.inAppBrowserView`

#### Scenario: Loading embedded iframe content in notes
- **WHEN** an embedded `<iframe>` with an `http` or `https` URL is loaded (`isMainFrame == false`)
- **THEN** navigation is permitted with `NavigationDecision.navigate` without delegating to `url_launcher`

#### Scenario: Direct URL lesson loading
- **WHEN** `LessonWebView` is configured with an initial `url` parameter
- **THEN** navigation to URLs on the same host as `initialUrl` is permitted with `NavigationDecision.navigate` to support server redirects and normalized paths

#### Scenario: HTML string content with default base URL
- **WHEN** `LessonWebView` renders HTML content using `defaultBaseUrl` as origin
- **THEN** navigation requests matching the `defaultBaseUrl` host are permitted with `NavigationDecision.navigate` without delegating to `url_launcher`

### Requirement: Responsive Table Layout
The `LessonWebView` SHALL apply responsive CSS to HTML tables so wide data tables do not overflow the viewport or cause horizontal clipping of page margins.

#### Scenario: Rendering wide tables in lesson notes
- **WHEN** HTML content containing a `<table>` is rendered in `LessonWebView`
- **THEN** the table is styled with `max-width: 100%`, `display: block`, and `overflow-x: auto`
- **AND** the table permits horizontal scrolling without breaking the surrounding screen padding

