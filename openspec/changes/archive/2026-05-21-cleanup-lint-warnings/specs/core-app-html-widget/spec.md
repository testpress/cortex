## MODIFIED Requirements

### Requirement: Premium HTML Rendering via WebView
The core package SHALL provide an `AppHtml` widget that leverages `webview_flutter` to render complex HTML, MathJax equations, tables, and custom CSS styles with fully clean static analysis and zero unreferenced internal members.

#### Scenario: Renders HTML in WebView
- **WHEN** the `AppHtml` widget is rendered with HTML data
- **THEN** it initializes a `WebViewController`, loads the HTML content, and displays it in a WebView widget with support for JavaScript execution
