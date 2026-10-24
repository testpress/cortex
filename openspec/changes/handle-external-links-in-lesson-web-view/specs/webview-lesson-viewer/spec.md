## ADDED Requirements

### Requirement: External Hyperlink Delegation
The `LessonWebView` SHALL intercept external HTTP and HTTPS navigation requests and delegate them to the system handler via `url_launcher` in external application mode, while preventing internal WebView navigation.

#### Scenario: Tapping external hyperlink in notes
- **WHEN** the user taps an `http` or `https` link in lesson notes
- **THEN** navigation is intercepted with `NavigationDecision.prevent`
- **AND** the URL is launched externally via `LaunchMode.externalApplication`

#### Scenario: Direct URL lesson loading
- **WHEN** `LessonWebView` is configured with an initial `url` parameter
- **THEN** navigation to the exact initial URL is permitted with `NavigationDecision.navigate`

### Requirement: Responsive Table Layout
The `LessonWebView` SHALL apply responsive CSS to HTML tables so wide data tables do not overflow the viewport or cause horizontal clipping of page margins.

#### Scenario: Rendering wide tables in lesson notes
- **WHEN** HTML content containing a `<table>` is rendered in `LessonWebView`
- **THEN** the table is styled with `max-width: 100%`, `display: block`, and `overflow-x: auto`
- **AND** the table permits horizontal scrolling without breaking the surrounding screen padding
