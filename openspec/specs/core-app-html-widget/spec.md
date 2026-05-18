# core-app-html-widget Specification

## Purpose
TBD - created by archiving change core-app-html-widget. Update Purpose after archive.
## Requirements
### Requirement: Premium HTML Rendering via WebView
The core package SHALL provide an `AppHtml` widget that leverages `webview_flutter` to render complex HTML, MathJax equations, tables, and custom CSS styles.

#### Scenario: Renders HTML in WebView
- **WHEN** the `AppHtml` widget is rendered with HTML data
- **THEN** it initializes a `WebViewController`, loads the HTML content, and displays it in a WebView widget with support for JavaScript execution

### Requirement: Dynamic Height Scaling
The `AppHtml` widget SHALL automatically compute and adjust its height dynamically based on the rendered HTML content height.

#### Scenario: Adjusts height on content changes
- **WHEN** the HTML page is finished loading or resizing
- **THEN** a `ResizeObserver` detects the height of the document content and propagates the height update back to the Flutter widget, updating its height constraints dynamically

### Requirement: Javascript Message Channel Support
The `AppHtml` widget SHALL support receiving arbitrary string messages from the WebView javascript execution environment via a generic MessageChannel.

#### Scenario: Receiving a message from Javascript
- **WHEN** Javascript calls `MessageChannel.postMessage("some data")`
- **THEN** the `AppHtml` widget triggers its `onMessage` callback, providing the message string to its parent widget
