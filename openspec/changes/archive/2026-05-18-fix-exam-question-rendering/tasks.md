## 1. Modify core-app-html-widget
- [x] 1.1 Update `AppHtml` in `packages/core/lib/widgets/app_html.dart` to accept an `onMessage` callback and register a `MessageChannel` with `WebViewController`.

## 2. Refactor TestQuestionCard HTML Generation
- [x] 2.1 Refactor `TestQuestionCard` in `packages/exams/lib/widgets/test_detail/test_question_card.dart` to generate a single unified HTML string incorporating the question text and all option texts.
- [x] 2.2 Replicate the visual styling of `OptionCard` in the unified HTML using inline CSS and dynamic colors from `Design.of(context)`.
- [x] 2.3 Inject Javascript logic into the unified HTML to handle option click events, visually toggle standard radio/checkbox elements, and post the selected option ID to `MessageChannel`.
- [x] 2.4 Update `TestQuestionCard` to render exactly one `AppHtml` widget, passing the `onMessage` callback to handle Javascript events and invoke `onOptionSelect`.

## 3. ReviewQuestionView Updates
- [x] 3.1 Investigate and similarly consolidate HTML inside `ReviewQuestionView` if it uses the multi-webview pattern.

## 4. Enforce Deterministic Chapter Lesson Ordering
- [x] 4.1 Update `getLessons(chapterId)` in `packages/courses/lib/repositories/course_repository.dart` to sort by `orderIndex` ascending.

## 5. Structured JSON Height Communication
- [x] 5.1 Refactor JavaScript `postMessage` calls inside `AppHtml` to send stringified JSON objects (`{"event": "...", "height": ...}`).
- [x] 5.2 Refactor Dart `onMessageReceived` inside `_AppHtmlState` to safely parse the JSON payload using `jsonDecode`.

## 6. Extract HTML Builders (Separation of Concerns)
- [x] 6.1 Create `TestQuestionHtmlBuilder` in `packages/exams/lib/widgets/test_detail/test_question_html_builder.dart` with a static `build(...)` method encapsulating all HTML/CSS/JS generation for active exam questions.
- [x] 6.2 Create `ReviewQuestionHtmlBuilder` in `packages/exams/lib/screens/review_answer/widgets/review_question_html_builder.dart` encapsulating all HTML/CSS for review-mode question cards.
- [x] 6.3 Simplify `test_question_card.dart` and `review_question_view.dart` to layout-only widgets that delegate HTML generation to their respective builders.

## 7. Fix WebView Memory Leak (OOM Crash on Large Tests)
- [x] 7.1 Remove `AutomaticKeepAliveClientMixin` and `wantKeepAlive = true` from `TestQuestionCard`.
       Previously, every visited question kept its WebView alive permanently. On a 200-question test
       this accumulated 200 WebViews (~40MB each) → OOM crash. Flutter now naturally disposes
       off-screen WebViews. The selected answer state is preserved by Riverpod, not the widget.
