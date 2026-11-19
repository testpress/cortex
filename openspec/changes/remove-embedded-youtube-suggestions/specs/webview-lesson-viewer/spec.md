## ADDED Requirements

### Requirement: YouTube Iframe Embed Sanitization in HTML Content
The `LessonWebView` SHALL intercept YouTube iframe `src` URLs in HTML lesson content (e.g., notes and `embedContent`) during HTML styling and ensure the `rel=0` query parameter is present to prevent external video suggestions.

#### Scenario: Injecting rel=0 into YouTube embed iframe in lesson HTML
- **WHEN** lesson HTML containing `<iframe src="https://www.youtube.com/embed/xyz"></iframe>` is rendered
- **THEN** the iframe source URL is modified to `https://www.youtube.com/embed/xyz?rel=0`

#### Scenario: Preserving existing parameters with HTML entities in lesson HTML
- **WHEN** lesson HTML contains an iframe source with query parameters and HTML entities (e.g. `src="https://www.youtube.com/embed/xyz?start=15&amp;autoplay=1"`)
- **THEN** `rel=0` is appended while preserving all other query parameters properly decoded/encoded

#### Scenario: Idempotent rel=0 injection in lesson HTML
- **WHEN** lesson HTML contains an iframe source that already has `rel=0` or `rel=1`
- **THEN** `rel=0` is preserved or updated without duplicate query keys

#### Scenario: Symmetrical attribute quote handling in lesson HTML
- **WHEN** lesson HTML contains an iframe source wrapped in single quotes (e.g. `<iframe src='https://www.youtube.com/embed/xyz'></iframe>`)
- **THEN** `rel=0` is appended and the single-quote attribute delimiters are preserved symmetrically

### Requirement: Outbound YouTube Navigation Suppression
The `LessonWebView` SHALL intercept top-level navigation requests targeting YouTube hosts (`youtube.com`, `youtube-nocookie.com`, `youtu.be`) as well as third-party sharing intents containing YouTube payloads (such as sharing to WhatsApp, Facebook, Reddit, or Twitter from the embed share dialog) and prevent them without delegating to `url_launcher`, ensuring learners cannot navigate out of the lesson embed. Non-YouTube external links (e.g., Google Meet, Zoom, Drive) SHALL continue to be delegated to `url_launcher`.

#### Scenario: Blocking outbound YouTube navigation in lesson webview
- **WHEN** a navigation request targeting a YouTube host (e.g. `https://www.youtube.com/watch?v=123` or `https://youtu.be/123`) occurs with `isMainFrame == true`
- **THEN** navigation is intercepted with `NavigationDecision.prevent`
- **AND** `url_launcher` is NOT invoked

#### Scenario: Blocking player share intents to third-party apps
- **WHEN** a navigation request targets a third-party share endpoint embedding a YouTube link (e.g. `api.whatsapp.com/send?text=https://youtu.be/...` or `facebook.com/dialog/share?...`)
- **THEN** navigation is intercepted with `NavigationDecision.prevent`
- **AND** `url_launcher` is NOT invoked

#### Scenario: Preserving external link delegation for non-YouTube URLs
- **WHEN** a navigation request targeting a non-YouTube external host (e.g. `https://meet.google.com/abc-xyz` or an article like `https://example.com/article?source=youtube.com`) occurs with `isMainFrame == true`
- **THEN** navigation is intercepted with `NavigationDecision.prevent`
- **AND** `url_launcher` is invoked in `LaunchMode.inAppBrowserView`
