## Context

The Cortex exam player currently renders only MCQ question types (single-select `R` and multiple-select `C`). The Testpress API also returns Short Answer (`S`), Numerical (`N`), and Essay (`E`) question types. Today, `QuestionDto.fromJson` maps `S`, `N`, and `E` to `singleSelect` as a silent fallback, `TestQuestionHtmlBuilder` only renders option lists, and `AnswerDto` has no `shortText` field. Users encountering these question types see question text but cannot enter any answer and their state is never submitted to the backend.

The Android SDK handles this entirely within the WebView layer — it injects an HTML `<input>` or `<textarea>` element into the question's HTML and communicates keystrokes back to native code via a JS-to-native bridge in real time.

## Goals / Non-Goals

**Goals:**
- Render `S`, `N`, and `E` type questions with appropriate HTML input elements inside the existing `TestQuestionHtmlBuilder`.
- Communicate the user's typed text back to Flutter in real-time via the existing `MessageChannel` JS channel with a new message format.
- Persist the typed value in-memory per-question in `ExamRepository` so it survives question navigation.
- Submit `short_text` in the answer payload to the backend API for these question types.
- Sanitize numerical input in JavaScript to prevent malformed values (commas, multiple decimals, misplaced dashes).

**Non-Goals:**
- File upload questions (`F` type) — out of scope for this change.
- Rich text / Quill formatting for Essay — plain `<textarea>` is sufficient, matching Android SDK behavior.
- Review-mode rendering for input questions — `ReviewQuestionHtmlBuilder` is not changed.
- Offline exam mode considerations.

## Decisions

### Decision: Extend the existing `MessageChannel` rather than add a new JS channel
**Chosen:** Use the existing `MessageChannel` with a structured JSON payload that includes a `type` field (`optionSelect` vs `inputChange`) so Flutter can differentiate between MCQ selection events and text input events.

**Alternative considered:** Register a separate JS channel (e.g. `InputChannel`) dedicated to text input.

**Rationale:** The `MessageChannel` is already wired up in `AppHtml`. Adding a second channel requires threading a new channel name through the widget tree and `TestQuestionCard`. A discriminated JSON payload keeps the interface surface minimal and is consistent with the existing structured JSON approach used by the `HeightChannel`.

---

### Decision: Store typed text in `ExamRepository._pendingAnswers` as `shortText` on `AnswerDto`
**Chosen:** Extend `AnswerDto` with an optional `shortText` field. On every `inputChange` message, call a lightweight `updateShortText(questionId, text)` on the repository which updates the in-memory `_pendingAnswers` map without debouncing — submission debouncing only happens at the flush layer.

**Alternative considered:** Store typed text in a separate `_pendingShortTexts` map.

**Rationale:** The pending answer is already the canonical in-memory record for a question. Keeping `shortText` co-located with `selectedAnswers` and `review` on the same `AnswerDto` avoids split state and ensures the flush pipeline (`_flushPendingAnswers`) submits everything in one pass.

---

### Decision: JS sanitization for numerical type, number keyboard via WebView input mode
**Chosen:** For type `N`, inject a `sanitizeInput` JS function that strips commas, collapses multiple decimal points, and enforces a single leading dash for negatives — matching the Android SDK implementation exactly. Use `inputmode="decimal"` on the HTML `<input>` to request the numeric keyboard on mobile browsers/WebViews without restricting the input to a numeric-only type (which would block the decimal and minus sign).

**Alternative considered:** Use `type="number"` on the HTML input.

**Rationale:** `type="number"` behaves inconsistently across Android WebView versions and strips leading zeroes. `inputmode="decimal"` is the modern standard and supported by all target platforms.

---

### Decision: `QuestionDto` maps `S`, `N`, `E` explicitly; keeps `shortText` on the model
**Chosen:** Add `shortText` as a nullable field on `QuestionDto` so that a previously saved answer (fetched from the attempt's question list) can be pre-populated into the input field on initial render.

**Rationale:** The API returns `short_text` on each attempt question when resuming a paused attempt. Pre-populating this on first render is essential for correct resume behavior.

---

### Decision: Group flat questions list by `attempt_section.name` and compute offsets dynamically
**Chosen:**
1. Parse the section name (via `attempt_section.name` or fallback to `subject`) into a new `sectionName` field on `QuestionDto`.
2. For flexible exams, sort the flat list of questions in `test_detail_screen.dart` so questions with the same `sectionName` are grouped sequentially in the order of `state.sections`.
3. Calculate section starting indices and question counts dynamically by scanning the grouped/sorted questions list in `TestDetailScreen`, rather than relying on `state.sections[i].questionsCount` (which can be null/0 from the API).
4. Jump and highlight tabs based on these dynamic offsets.

**Rationale:** This mirrors `TestFragment.initializeSectionSpinner()` in the Android SDK, which groups the flat questions list by section name and registers their offsets locally without making any new API calls on tab click. Since the API's `questionsCount` field in `state.sections` can be null or 0 for flexible exams, calculating these values dynamically from the grouped questions list prevents navigation bugs where all pills would scroll to index 0 and appear unclickable.

---

### Decision: `hasSectionalLock` is computed from section durations, not from a dedicated API flag
**Chosen:** Add a `hasSectionalLock` getter on `AttemptDto` that returns `true` only if there are 2+ sections **and** every section has a non-zero, non-null `duration`.

**Rationale:** The Testpress API does not return an explicit `has_sectional_lock` boolean. This is the exact same derivation used in the Android SDK (`Attempt.hasSectionalLock()` in `greendao/Attempt.java`, which delegates to `AttemptSection.hasDuration()` checking for `duration != "0:00:00"`). It is not a Cortex-specific hack — it is the official platform convention.

---

## Risks / Trade-offs

- **Long essay text and WebView resize**: Large essay inputs may not resize the WebView height correctly. → Mitigation: The existing `HeightChannel` observer fires on content changes; no special handling needed for initial scope.
- **Sanitization edge cases for Numerical**: Pasting unusual unicode or scientific notation (e.g. `1e5`) is not handled by the JS sanitizer. → Mitigation: The backend will reject invalid values; this is acceptable for V1.
- **MessageChannel collision**: If another part of the app posts a plain integer to `MessageChannel` (the old MCQ format), the new JSON parser will fail silently. → Mitigation: Update the MCQ `selectOption` JS function to also post structured JSON (`{"type":"optionSelect","id":"123"}`), making the format consistent. A fallback parser handles legacy plain-integer messages during transition.
