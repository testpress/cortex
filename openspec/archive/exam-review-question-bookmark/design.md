## Context

The exam review screen (`ReviewAnswerDetailScreen`) shows one question at a time with navigation (prev/next) and filter (all/correct/incorrect/unanswered). Each question is rendered by `ReviewQuestionCard`, which contains a `_QuestionHeader` widget showing a badge + question number on the left, and a colour-coded pill on the right.

The lesson detail page (`LessonDetailOrchestrator`) already has a working bookmark flow:
- Shows `LucideIcons.bookmark` (filled) when bookmarked, outline when not.
- Tapping when bookmarked removes directly with toast.
- Tapping when not bookmarked opens `BookmarkFoldersSheet` for folder selection.
- `BookmarkFoldersSheet` uses `lessonId` (int) and `category` (string) parameters.

The review API returns `ReviewItemDto` which includes `bookmarkId`. This data is currently parsed from JSON but discarded when mapping to `QuestionDto`.

The Bookmarks screen uses `BookmarkItem` to render bookmark entries. Question-type bookmarks (contentType `question` or `userselectedanswer`) use `AppHtmlV2` to render the question HTML. Without truncation, cards with long text or images create inconsistent heights.

## Goals / Non-Goals

**Goals:**
- Show bookmark icon on each review question card (top-right of header)
- Allow bookmarking/unbookmarking questions using the existing bookmark infrastructure
- Preserve `bookmarkId` from API through to the UI
- Follow the same UX conventions as lesson bookmarks
- Render question bookmarks in the Bookmarks screen with consistent card heights
- Show ellipsis when question text overflows the preview area
- Preserve LaTeX rendering in truncated previews
- Match `bodySmall` typography for question text in bookmark list

**Non-Goals:**
- Changing the bookmark screen, folder management, or provider layer
- Adding bulk bookmark operations
- Changing the `BookmarkFoldersSheet` widget interface
- Modifying the API layer or DTO models beyond adding `bookmarkId` to `QuestionDto`

## Decisions

**Decision 1: Add `bookmarkId` to `QuestionDto`**
Instead of passing `bookmarkId` as a separate parameter through the widget tree, add it to `QuestionDto` as an optional `int?` field.
*Rationale:* `ReviewItemDto.toQuestionDto()` already maps review data to `QuestionDto`. Adding `bookmarkId` there is the minimal change. `QuestionDto.copyWith()` already exists for immutable updates. Existing callers are unaffected since the field is optional.

**Decision 2: Reuse `BookmarkFoldersSheet` for folder selection**
When the user taps the bookmark icon on an unbookmarked question, show the same `BookmarkFoldersSheet` bottom sheet used in lesson detail.
*Rationale:* The user said "balance everything (the flow) were already there". `BookmarkFoldersSheet` provides consistent UX (folder selection, toast feedback, create folder dialog). The `lessonId` parameter is repurposed as the question ID; the `category` is hardcoded to a sensible default (e.g. `"question"` or `"exam"`).

**Decision 3: Follow same toggle pattern as lesson detail**
When already bookmarked, tapping the icon removes the bookmark directly with a toast, without showing the folder sheet. When not bookmarked, the folder sheet opens.
*Rationale:* This matches the existing `LessonDetailOrchestrator` behavior exactly, providing a consistent mental model.

**Decision 4: Manage bookmark sheet state in `ReviewAnswerDetailScreen`**
The screen already has `_ReviewAnswerDetailScreenState`. Add `_isBookmarkSheetOpen` and `_isCreateFolderDialogOpen` boolean fields, similar to `LessonDetailOrchestrator`.
*Rationale:* The screen already uses `setState` for `_currentQuestionIndex` and `_activeFilter`. Adding two more state fields is consistent and low-impact.

**Decision 5: Map `ReviewItemDto.bookmarkId` into `QuestionDto` during review fetch**
In `_fetchReviewItems()`, after mapping to `QuestionDto`, set the `bookmarkId` from the corresponding `ReviewItemDto`.
*Rationale:* Currently the `bookmarkId` is lost. The mapping loop in `_fetchReviewItems()` iterates over `reviewItems` and creates both `QuestionDto` and `AnswerDto`. Adding `bookmarkId` to the `QuestionDto` there preserves the link.

**Decision 6: Truncate question previews via CSS `max-lines` on text elements**
Apply `max-lines: N` and `text-overflow: ellipsis` CSS properties to each text-containing HTML element (`p`, `div`, `li`, `span`, `h1`-`h6`) via `AppHtmlV2.customStylesBuilder`. The library processes these per-element (they are non-inherited, so they must be applied to each text element individually).
*Rationale:* Wrapping content in a `<div style="max-lines:N">` does not work because the library stores `maxLines` as a non-inherited property via `setNonInherited`. Child text nodes do not inherit the parent's `maxLines`. Applying directly to each text-bearing element ensures the `RichText` widgets receive the limit.

**Decision 7: Add `fontWeight` and `textHeight` to `AppHtmlV2` for typography alignment**
Add `FontWeight? fontWeight` and `double? textHeight` parameters to `AppHtmlV2`. When set, they are applied via `textStyle.copyWith` on `HtmlWidget`. `fontWeight` is also forwarded to `_MathWidgetFactory` for LaTeX equation styling. Math blocks use the same `fontSize` as body text (no extra scaling); `fontWeight` provides visual differentiation instead.
*Rationale:* The bookmark list renders non-question items with `bodySmall` (w500, 14px, height 1.4). Question items rendered by `AppHtmlV2` use `design.typography.body` as a base (w400, height 1.5) with `fontSize` override. Matching `fontWeight` and `textHeight` ensures a professional, consistent appearance. Removing prior `fontSize * 1.1` (inline) / `fontSize * 1.2` (block) math scaling avoids uneven baseline drift and lets `fontWeight` control emphasis.

**Decision 8: Use CSS `max-lines` rather than `SizedBox` clipping for truncation**
Do not use `SizedBox` + `ClipRect` or fade-overlay approaches for truncation.
*Rationale:* Fixed-height clipping cuts text mid-line and looks unprofessional. CSS `max-lines` + `text-overflow: ellipsis` provides proper line-aware truncation and a clear overflow indicator. The library natively supports these CSS properties on text elements via `parseStyle`, resulting in `RichText(maxLines: N, overflow: TextOverflow.ellipsis)`.

## Data Flow

```
ReviewItemDto.bookmarkId
  -> ReviewItemDto.toQuestionDto() [new: passes bookmarkId]
  -> QuestionDto.bookmarkId [new field]
  -> ReviewQuestionCard.question.bookmarkId
  -> _QuestionHeader reads question.bookmarkId
   -> Icon state: LucideIcons.bookmarkOff if != null, LucideIcons.bookmark if null
  -> Toggle -> setState in ReviewAnswerDetailScreen -> show BookmarkFoldersSheet or removeBookmarkProvider

BookmarkItem (Bookmarks screen, question type)
  -> AppHtmlV2(data: title, fontSize: 14, fontWeight: w500, textHeight: 1.4, maxLines: 2)
  -> HtmlWidget processes HTML with customStylesBuilder
  -> Each <p>/<div>/<li>/<span>/<h1>-<h6> gets max-lines:2; text-overflow:ellipsis
  -> RichText(maxLines: 2, overflow: TextOverflow.ellipsis)
  -> Consistent card heights, ellipsis on overflow
```
