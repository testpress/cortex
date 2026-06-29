## Context

`ReviewAnswerDetailScreen` (`packages/exams`) shows a per-question review after exam submission. Each question card has an "Ask Doubt" button wired to `onAskDoubt` in `ReviewFooterActions`. Currently, tapping it calls `_showAskDoubtDialog`, which opens a bare inline dialog with a plain text field — disconnected from the full `AskDoubtFormScreen` in the `discussions` package.

Additionally, the Comment (`BaseReviewDialog`) and Report (`ReportReviewDialog`) dialogs in `review_dialog_components.dart` use `Expanded` on both the Cancel and action buttons, making them equal-width across the full row. This gives Cancel an oversized, unbalanced appearance — both buttons should be natural-width and right-aligned.

The full ask-doubt form (`/home/discussions/doubts/ask`) is already a named GoRouter route in `home_routes.dart`. It accepts a `question_id` query parameter that pre-fills the doubt context badge on screen. No new UI or backend work is needed.

**Current dependency graph of `packages/exams`**: depends on `core`, `courses`. Does **not** depend on `discussions`.

## Goals / Non-Goals

**Goals:**
- Replace `_showAskDoubtDialog` in `ReviewAnswerDetailScreen` with a navigation call to the existing `AskDoubtFormScreen` route.
- Pass the current `questionId` from the review item so the form pre-fills the doubt context.
- Remove the now-redundant local dialog code from `review_answer_detail_screen.dart`.
- Fix the Comment and Report dialog button rows: Cancel at natural width on the left, action button right-aligned beside it.

**Non-Goals:**
- Not changing `AskDoubtFormScreen` itself.
- Not adding `discussions` as a compile-time dependency to `packages/exams` — navigation is handled via string routes in `packages/testpress`, keeping package boundaries intact.

## Decisions

### 1. Navigate via GoRouter URL — not package import

**Decision**: Use `context.push('/home/discussions/doubts/ask?question_id=<id>')` from within `ReviewAnswerDetailScreen`.

**Why**: Adding `discussions` as a dependency to `packages/exams` would create a cross-domain coupling that doesn't belong at the SDK layer. The route already exists in `home_routes.dart` and accepts query parameters. Navigation-by-URL is the established pattern in this monorepo (see `exams_routes.dart`, `study_routes.dart`).

**Alternative considered**: Import `AskDoubtFormScreen` directly into `packages/exams`. Rejected — `exams` is a domain package and should not depend on `discussions`.

### 2. Pass questionId via query parameter

**Decision**: Use the existing `question_id` query parameter that `home_routes.dart` already reads as `int.tryParse(state.uri.queryParameters['question_id'])`.

**Why**: The route builder already handles this — no route changes needed. `AskDoubtFormScreen` will show the doubt context badge with "Question ID: <id>" automatically.

**Note**: The `questionId` in `QuestionDto` is a `String` (the DTO's `.id` field). Verify the question's numeric ID is available in the review item. If `QuestionDto.id` is a string slug and not a numeric int, pass it as-is; the form gracefully falls back.

### 3. Remove the inline dialog entirely

**Decision**: Delete `_showAskDoubtDialog` from `review_answer_detail_screen.dart` rather than keeping it as a fallback.

**Why**: The inline dialog is a dead end — it doesn't submit anywhere. Keeping dead code creates confusion. The new navigation is the complete replacement.

### 4. Fix Comment & Report button alignment in dialog components

**Decision**: In `BaseReviewDialog` and `ReportReviewDialog`, remove `Expanded` from the Cancel button, set `mainAxisAlignment: MainAxisAlignment.end` on the button row. The action button remains unsized (natural width from `AppButton`).

**Why**: The current `Expanded` layout stretches Cancel to half the dialog width, which is visually noisy and doesn't match standard dialog conventions. Right-aligning both buttons at natural size (Cancel → Action) is the expected pattern for modal actions.

**Alternative considered**: Keep `Expanded` but make Cancel smaller with a custom width. Rejected — natural width from `AppButton` is cleaner and consistent with how `AppButton` is used elsewhere.

## Risks / Trade-offs

- **Back-stack depth**: Navigating to `/home/discussions/doubts/ask` from the exam review context (which is itself a deep route) adds another screen to the stack. The user taps back to return to the review. This is the expected UX pattern and acceptable.
- **questionId format**: If the review item's `QuestionDto.id` is not a numeric string, `int.tryParse` in the route builder returns `null`, and `AskDoubtFormScreen` receives `questionId: null` — it falls back gracefully with no context badge. This is a safe degradation.
- **No package boundary change in `exams`**: `packages/exams/pubspec.yaml` does not get a `discussions` dependency. This is intentional; the navigation string coupling lives entirely in `review_answer_detail_screen.dart` which is consumed by `packages/testpress`.
