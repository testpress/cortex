## Context
Currently, the `TestQuestionCard` renders a question using one `AppHtml` widget for the question text and `n` `AppHtml` widgets for the `n` options. Each `AppHtml` widget spins up a native `WebViewController`, loading MathJax asynchronously. Swiping between questions therefore spins up 5+ native WebViews simultaneously, causing massive UI freezes and rendering jank. The Android SDK solves this by rendering the entire question and options in a single HTML payload within one WebView.

## Goals / Non-Goals
**Goals:**
- Eliminate the rendering lag when navigating between exam questions.
- Consolidate question text and options into a single HTML structure.
- Communicate option selections from the single WebView back to Flutter via a javascript message channel.

**Non-Goals:**
- We are not changing the API data structure or exam flow state machine.
- We are not building a custom math renderer in Flutter (still relying on MathJax via WebView).

## Decisions
1. **Unified HTML Generation**: Instead of mapping over `question.options` to create Flutter widgets, `TestQuestionCard` will generate an HTML string appending standard radio buttons (or checkboxes) inside styled `div`s.
   - *Rationale*: Replicates the Android SDK approach, replacing 5 WebViews with 1, eliminating the platform view initialization overhead.
2. **Javascript Message Channel**: `AppHtml` will be updated to accept an `onMessage` callback and register a `MessageChannel`. The unified HTML payload will include javascript to post the selected option ID to `MessageChannel` on click.
   - *Rationale*: Flutter needs to know when an option is tapped to update the state.
3. **Preserving Visuals**: The generated HTML and CSS will be carefully crafted to look exactly like the current `OptionCard` Flutter widget, utilizing `Design.of(context)` to fetch theme colors and border radii and inject them into the HTML template.
4. **State Syncing**: The HTML Javascript will handle the immediate visual toggling of the selected option. It will send the selected option ID to Flutter, which will update the state. To prevent `AppHtml` from completely reloading the WebView string when the `answer` state updates (which would cause a flash), `TestQuestionCard` will rely on Javascript to maintain the immediate visual state, while the Flutter state is updated silently.

## Risks / Trade-offs
- **Risk**: The HTML/CSS for options may differ slightly from the native `OptionCard` look.
  - *Mitigation*: Hardcode the specific CSS logic using colors injected from the Flutter side to match native UI closely.
- **Risk**: State mismatch between Flutter and WebView.
  - *Mitigation*: The Javascript will faithfully reflect user interactions, and Flutter will passively record them. Re-entering a question will properly set the `checked` state based on the current Flutter state upon initial WebView load.
