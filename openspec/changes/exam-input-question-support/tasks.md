## 1. Data Model

- [x] 1.1 Update `QuestionDto.fromJson` type switch to map `S` → `shortAnswer`, `N` → `numerical`, `E` → `essay` (in addition to existing `R` and `C` mappings)
- [x] 1.2 Add `shortText` (nullable `String`) field to `QuestionDto` and populate it from `json['short_text']` in `fromJson`
- [x] 1.3 Add `shortText` (nullable `String`) field to `AnswerDto` and include it in `toJson()` as `'short_text'`

## 2. HTML Builder — Input Rendering

- [x] 2.1 In `TestQuestionHtmlBuilder.build`, add a branch for `shortAnswer` type: inject a single-line `<input class="edit_box" type="text" inputmode="text" placeholder="YOUR ANSWER">` pre-populated with `question.shortText ?? ''`
- [x] 2.2 Add a branch for `numerical` type: inject `<input class="edit_box" type="text" inputmode="decimal" placeholder="YOUR ANSWER">` pre-populated with `question.shortText ?? ''`, followed by the JS `sanitizeInput` function (strip commas, enforce single decimal, single leading dash)
- [x] 2.3 Add a branch for `essay` type: inject a `<textarea class="essay_box" rows="10" placeholder="YOUR ANSWER">` pre-populated with `question.shortText ?? ''`
- [x] 2.4 Add CSS for `.edit_box` and `.essay_box` classes styled consistently with the card's design tokens (border, radius, text color, background)

## 3. JS Message Protocol

- [x] 3.1 Update the `oninput` handler on `<input>` and `<textarea>` to post `{"type":"inputChange","value":"<text>"}` to `window.MessageChannel`
- [x] 3.2 Update the `selectOption` JS function to post `{"type":"optionSelect","id":"<id>"}` instead of a raw integer string
- [x] 3.3 Update the Flutter `MessageChannel` handler in `test_detail_screen.dart` to JSON-decode all messages and dispatch based on the `type` field (`optionSelect` → existing handler, `inputChange` → new handler)
- [x] 3.4 Add a legacy fallback in the Flutter message handler: if JSON decoding fails, treat the raw string as a plain option ID (backward compatibility during transition)

## 4. Repository — In-Memory State & Submission

- [x] 4.1 Add `updateShortText(String questionId, String text)` method to `ExamRepository` that updates `_pendingAnswers[questionId].shortText` (or creates an `AnswerDto` entry if none exists)
- [x] 4.2 Ensure `_flushPendingAnswers` passes `shortText` from `AnswerDto` to the answer API payload for input-type questions
- [x] 4.3 Wire the `inputChange` message (from task 3.3) in `test_detail_screen.dart` to call `examRepository.updateShortText(currentQuestionId, value)`

## 5. Verification

- [x] 5.1 Verify Short Answer questions show the text input field and no option list
- [x] 5.2 Verify Numerical questions show the numeric input, the decimal keyboard appears on focus, and comma/multi-decimal sanitization works
- [x] 5.3 Verify Essay questions show the textarea and no option list
- [x] 5.4 Verify typed text is preserved when navigating away from a question and returning
- [x] 5.5 Verify the answer API payload contains `short_text` when submitting a Short Answer or Numerical question
- [x] 5.6 Verify existing MCQ questions are unaffected by the JS message format change

## 6. Section Tab Label Alignment (Bug Fix — discovered during testing)

*Root cause: Cortex used `question.subject` as pill label source in all cases, and always fetched questions per-section. The Android SDK uses `AttemptSection.getName()` for labels and fetches all questions from the root URL when there is no sectional lock.*

- [x] 6.1 Add `hasSectionalLock` getter to `AttemptDto` — returns `true` only when 2+ sections all have a non-zero `duration` (matches `Attempt.hasSectionalLock()` in the Android SDK)
- [x] 6.2 Add `hasNoSectionalLock` getter to `AttemptDto` as the inverse of `hasSectionalLock`
- [x] 6.3 Update `ExamRepository._initializeAttempt` to fetch from `attempt.questionsUrl` (root) when `hasSectionalLock` is false, instead of `activeSection.questionsUrl`
- [x] 6.4 Update `SectionsTabBar` to show section names from `SectionDto` (not question subjects) when `hasSectionalLock` is true; fall back to subject-derived pills when false
- [x] 6.5 Update `test_detail_screen.dart` to only call `switchSection` on pill tap when `hasSectionalLock` is true; otherwise scroll the `PageView` to the first question of that subject
- [x] 6.6 Update `test_detail_screen.dart` to only show the "Next Section" finish label and suppress `hasNextSection` nav when `hasSectionalLock` is true
- [x] 6.7 Parse `sectionName` in `QuestionDto.fromJson` from `attempt_section` (with fallback to `subject`)
- [x] 6.8 Sort/group flat question list by `sectionName` in `test_detail_screen.dart` to group questions of the same section together
- [x] 6.9 Dynamically calculate starting indices and counts for each section in `test_detail_screen.dart`
- [x] 6.10 Update `onTabSelected` to jump to the dynamically calculated starting index of the selected section
- [x] 6.11 Update `activeTabIndex` computation to use the dynamically calculated starting indices and counts

### 6. Verification
- [x] 6.12 Verify a flexible exam (sections with `duration == "0:00:00"`) loads all 75 questions at once with no per-section API calls
- [x] 6.13 Verify section pill labels match the section names returned by the API for the flexible exam (e.g. `Mathematics`, `Physics`, `Chemistry`)
- [x] 6.14 Verify tapping a section pill instantly scrolls the `PageView` to the first question of that section without a loading screen for the flexible exam
- [x] 6.15 Verify swiping past the last question of one section proceeds to the first question of the next section without a "Next Section" button for the flexible exam
- [x] 6.16 Verify a strict-lock exam (sections with real durations) still uses per-section fetch, shows the "Next Section" button, and requires the API call on section switch
