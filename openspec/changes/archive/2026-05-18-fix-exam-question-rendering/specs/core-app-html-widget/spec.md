## ADDED Requirements

### Requirement: Javascript Message Channel Support
The `AppHtml` widget SHALL support receiving arbitrary string messages from the WebView javascript execution environment via a generic MessageChannel.

#### Scenario: Receiving a message from Javascript
- **WHEN** Javascript calls `MessageChannel.postMessage("some data")`
- **THEN** the `AppHtml` widget triggers its `onMessage` callback, providing the message string to its parent widget
