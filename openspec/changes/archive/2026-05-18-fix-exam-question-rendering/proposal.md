## Why
The exam player screen suffers from a severe "rendering jerk" when users navigate to the next question. This is because the current implementation instantiates multiple `AppHtml` widgets (one for the question text, and one for each option), which spawns 5+ native WebViews simultaneously, downloading and executing MathJax 5 times per question.

## What Changes
We will mimic the highly optimized Android SDK approach by combining the question and its options into a single HTML structure and rendering it in a single `AppHtml` widget per question.
- Update `AppHtml` to accept an `onMessage` callback for generic bidirectional communication via JavaScript channels.
- Refactor `TestQuestionCard` to generate a single unified HTML payload containing both the question text and standard HTML radio/checkbox elements for the options.
- Inject Javascript into the combined HTML payload to handle option clicks and dispatch the selected option IDs back to Flutter via the new message channel.

## Capabilities

### New Capabilities
- `exam-question-unified-renderer`: Consolidates exam questions and options into a single HTML document to eliminate multi-webview lag.

### Modified Capabilities
- `core-app-html-widget`: Add message channel support to send arbitrary data from WebView JS to Flutter.

## Impact
- **Performance**: Drastically reduces memory usage, initialization latency, and UI jank during exam progression.
- **Affected Code**: `packages/exams/lib/widgets/test_detail/test_question_card.dart`, `packages/core/lib/widgets/app_html.dart`.
