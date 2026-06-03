## Why

The exam engine currently only handles MCQ-style questions (single-select and multiple-select). The Testpress API also serves **Short Answer** (type `S`), **Numerical** (type `N`), and **Essay** (type `E`) question types, which require a text input from the user instead of an option selection. These question types are silently ignored in Cortex today — users see no input field, cannot provide an answer, and their responses are never submitted to the backend.

## What Changes

- `QuestionDto` will map three new question types from the API: `S` (Short Answer), `N` (Numerical), and `E` (Essay).
- `TestQuestionHtmlBuilder` will render an appropriate input widget in the WebView for each new type:
  - **Short Answer (`S`)**: A single-line text `<input>` field.
  - **Numerical (`N`)**: A single-line text `<input>` with JS sanitization that enforces numeric-only input (integers, decimals, and negative numbers) and triggers the number keyboard on mobile.
  - **Essay (`E`)**: A multi-row `<textarea>` for free-form text.
- A new JS-to-Flutter bridge message type (`inputChange`) will be added so that text typed into the WebView is relayed back to the Flutter layer in real-time.
- `AnswerDto` will be extended with a `shortText` field to carry the typed answer through the submission pipeline.
- `ExamRepository.selectAnswer` will include `short_text` in the API payload when submitting answers for `S`, `N`, or `E` type questions.
- The in-memory answer state in `ExamRepository` will preserve the typed value across question swipes so the text is restored when navigating back to the question.
- **Section tab label alignment (discovered during testing):** The Testpress API returns `sections` on every exam attempt, but exams without a strict time limit per section (i.e. `duration == "0:00:00"`) must be treated differently. For such exams ("no sectional lock"), the Android SDK groups questions by `AttemptSection.getName()` for the spinner labels and fetches all questions at once from the root `questionsUrl`. Cortex was incorrectly using `question.subject` as the pill label source in all cases, and was always fetching questions per-section. This caused wrong pill labels and forced loading screens on section tab taps for flexible exams. The fix adds a `hasSectionalLock` computation on `AttemptDto` and updates `SectionsTabBar`, `ExamRepository`, and `test_detail_screen` to branch on it. It also groups/sorts the flat list of questions by section name in the UI, and dynamically computes starting indices/counts for each section to ensure correct tab click behavior and highlighting.

## Capabilities

### New Capabilities
- `exam-input-question-types`: Covers rendering and submission of Short Answer, Numerical, and Essay question types in the active exam player.

### Modified Capabilities
- `exam-question-unified-renderer`: The HTML builder now handles four question type categories (MCQ, short answer, numerical, essay) instead of two.
- `exam-section-tab-alignment` *(bug fix, no new spec)*: Sections pills in the exam header now use section names from the API (matching Android SDK) and do not trigger API loads for flexible/non-locked exams.

## Impact

- `packages/core/lib/data/models/question_dto.dart` — add `S`, `N`, `E` to the type switch; add `shortText` field; add `sectionName` field and parse it from `attempt_section`.
- `packages/core/lib/data/models/answer_dto.dart` — add `shortText` field; include it in `toJson()`.
- `packages/core/lib/data/models/attempt_dto.dart` — add `hasSectionalLock` and `hasNoSectionalLock` computed getters.
- `packages/exams/lib/widgets/test_detail/test_question_html_builder.dart` — render input/textarea HTML branch; add `inputChange` JS message; number keyboard hint for `N` type.
- `packages/exams/lib/repositories/exam_repository.dart` — pass `shortText` in answer payload; preserve per-question text state in memory; fetch all questions from root URL when `hasSectionalLock` is false.
- `packages/exams/lib/screens/test_detail_screen.dart` — handle new `inputChange` JS channel message and forward to repository; sort/group questions by section name and dynamically calculate boundary offsets/counts to enable pill clickability and tab highlighting on flexible exams.
- `packages/exams/lib/widgets/test_detail/sections_tab_bar.dart` — use section names (not question subjects) for pill labels when sections exist.
