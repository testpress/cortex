## Why

The exam review screen (`ReviewAnswerDetailScreen`) shows each question with a colour-coded header badge (correct/incorrect/unanswered), but provides no bookmark icon. Users cannot bookmark individual questions from the review page for later reference.

The review API already returns `bookmark_id` per question (`ReviewItemDto.bookmarkId`), but this data is dropped during the `ReviewItemDto.toQuestionDto()` mapping and never reaches the UI. The entire bookmark infrastructure (providers, `BookmarkFoldersSheet`, repository) already exists in `packages/core`.

The Bookmarks screen renders question-type bookmarks using `AppHtmlV2`, which renders full HTML (images, LaTeX) with no line limit. This causes inconsistent card heights and an unprofessional look. The list needs truncation with ellipsis while preserving LaTeX rendering.

## What Changes

- Add `bookmarkId` to `QuestionDto` so the review question card can read bookmark state.
- Pass `bookmarkId` through `ReviewItemDto.toQuestionDto()` so the API data flows to the widget.
- Add a bookmark icon to the `_QuestionHeader` widget's right side, mirroring the lesson-detail pattern.
- Reuse the existing `BookmarkFoldersSheet` bottom sheet for the "add to folder" flow.
- Wire bookmark toggle state in `ReviewAnswerDetailScreen` (same pattern as `LessonDetailOrchestrator`).
- Add `maxLines`, `fontWeight`, `textHeight` parameters to `AppHtmlV2` for line clamping and typography control.
- Apply CSS `max-lines` and `text-overflow: ellipsis` per text-element via `customStylesBuilder` to truncate question cards in the bookmark list.
- Propagate `fontWeight` to `_MathWidgetFactory` so LaTeX rendering matches the surrounding text style.

## Capabilities

### New Capabilities
- `question-bookmark-button`: Show a bookmark outline/filled icon on each review question card. Tapping it opens `BookmarkFoldersSheet` (if not bookmarked) or removes the bookmark directly (if already bookmarked), with toast feedback.
- `bookmark-list-question-preview`: Render question bookmarks with consistent card heights using `AppHtmlV2` truncation (max-lines CSS, ellipsis overflow) and typography matching `bodySmall` (w500 weight, 1.4 height, 14px size).
- `app-html-v2-typography-control`: `AppHtmlV2` accepts `fontWeight` and `textHeight` parameters, propagated to both the base `textStyle` and the internal `_MathWidgetFactory` for consistent LaTeX rendering.

## Impact

- **Affected Code**: `question_dto.dart`, `review_models.dart`, `review_question_view.dart`, `review_answer_detail_screen.dart`, `app_html_v2.dart`, `bookmark_item.dart`
- **Behavior**: Users can bookmark individual questions during exam review. Bookmark list shows truncated question previews with consistent card heights and proper ellipsis.
