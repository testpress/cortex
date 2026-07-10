## 1. Add `bookmarkId` to `QuestionDto`

- [x] 1.1 Add `final int? bookmarkId;` field to `QuestionDto`
- [x] 1.2 Add `bookmarkId` parameter to `QuestionDto` constructor (default `null`)
- [x] 1.3 Add `bookmarkId` parameter to `QuestionDto.copyWith()`
- [x] 1.4 Add `bookmarkId` to `QuestionDto.toJson()`

## 2. Pass `bookmarkId` through `ReviewItemDto.toQuestionDto()`

- [x] 2.1 In `ReviewItemDto.toQuestionDto()`, pass `bookmarkId: bookmarkId` to the `QuestionDto` constructor

## 3. Add bookmark icon to `ReviewQuestionCard._QuestionHeader`

- [x] 3.1 Add `int? bookmarkId` and `VoidCallback? onBookmarkToggle` parameters to `ReviewQuestionCard`
- [x] 3.2 Pass them through to `_QuestionHeader`
- [x] 3.3 In `_QuestionHeader`, add a bookmark icon button to the right side of the row (before the pill badge) — shows `LucideIcons.bookmarkOff` if `bookmarkId != null`, `LucideIcons.bookmark` if `null`
- [x] 3.4 Apply appropriate styling (primary color when filled, textSecondary when outline, 48dp touch target)
- [x] 3.5 Add `AppSemantics.button` wrapper for accessibility

## 4. Wire bookmark state in `ReviewAnswerDetailScreen`

- [x] 4.1 Add `_isBookmarkSheetOpen` and `_isCreateFolderDialogOpen` boolean state fields
- [x] 4.2 Derive `parsedLessonId` from current question's ID
- [x] 4.3 Use `"user_selected_answer"` as category for bookmark API calls
- [x] 4.4 Implement `_removeBookmark(QuestionDto question)` method using `removeBookmarkProvider`
- [x] 4.5 Wire `onBookmarkToggle` on `ReviewQuestionCard` — removes if bookmarked, opens sheet if not
- [x] 4.6 Add `BookmarkFoldersSheet` wrapped in `AppBottomSheet` to the widget tree
- [x] 4.7 Add `CreateFolderDialog` to the widget tree
- [x] 4.8 Use `ref.listen` on `bookmarksForLessonProvider` to sync bookmark state after add

## 5. Persist attemptId for bookmark navigation

- [x] 5.1 Add `int? attemptId` field + `copyWith` to `BookmarkDto`
- [x] 5.2 Implement file-based persistent store in `BookmarkRepository` (`bookmark_attempts.json` via `path_provider`)
- [x] 5.3 Add `loadAttemptIdStore()` call in `bookmarkRepository` Riverpod provider
- [x] 5.4 Add `saveAttemptId()` public method and `_removeAttemptId()` private method to `BookmarkRepository`
- [x] 5.5 Merge attemptId into `BookmarkDto` in all stream methods (`watchBookmarks`, etc.) and `fetchBookmarks()`
- [x] 5.6 In `ReviewAnswerDetailScreen`, save attemptId on bookmark creation via `ref.listen`
- [x] 5.7 In `bookmarks_screen.dart`, add `question`/`userselectedanswer` navigation to `_navigateToBookmark`
- [x] 5.8 Implement `_navigateToReviewQuestion` to fetch review items, find question index, and push `ReviewAnswerDetailScreen`

## 6. Add truncation + typography params to `AppHtmlV2`

- [x] 6.1 Add `int? maxLines` field + constructor parameter to `AppHtmlV2`
- [x] 6.2 Add `FontWeight? fontWeight` field + constructor parameter to `AppHtmlV2`
- [x] 6.3 Add `double? textHeight` field + constructor parameter to `AppHtmlV2`
- [x] 6.4 Apply `fontWeight` and `textHeight` to `HtmlWidget.textStyle` via `copyWith`
- [x] 6.5 Pass `fontWeight` to `_MathWidgetFactory` constructor
- [x] 6.6 Apply `fontWeight` to all `TextStyle` uses in `_MathWidgetFactory` (inline math, block math, error fallbacks)

## 7. Apply CSS max-lines truncation via customStylesBuilder

- [x] 7.1 When `maxLines` is set, add `max-lines: N` and `text-overflow: ellipsis` CSS to text-containing elements in `customStylesBuilder` (`p`, `div`, `li`, `span`, `h1`-`h6`)
- [x] 7.2 Restructure `customStylesBuilder` from individual `return` statements to accumulated `Map` to allow merging base styles with truncation styles

## 8. Update BookmarkItem to use truncated AppHtmlV2

- [x] 8.1 In `BookmarkItem`, replace plain-text rendering with `AppHtmlV2` for question-type bookmarks
- [x] 8.2 Pass `fontSize: 14`, `fontWeight: FontWeight.w500`, `textHeight: 1.4`, `maxLines: 2` to match `bodySmall` typography
- [x] 8.3 Remove image stripping from HTML (CSS truncation handles overflow naturally)

## 9. Verify

- [x] 9.1 Bookmark icon shows on each question card (`LucideIcons.bookmark` when not bookmarked, `LucideIcons.bookmarkOff` when bookmarked)
- [x] 9.2 Tapping outline icon opens `BookmarkFoldersSheet`
- [x] 9.3 Selecting a folder adds bookmark — icon changes to filled
- [x] 9.4 Tapping filled icon removes bookmark directly with toast — icon changes to outline
- [x] 9.5 Folder creation flow works correctly from review screen
- [x] 9.6 Icon state updates correctly when navigating between questions
- [x] 9.7 Icon state updates correctly when switching filters
- [x] 9.8 Tapping a question-type bookmark in bookmarks screen navigates to `ReviewAnswerDetailScreen` at the correct question
- [x] 9.9 attemptId survives app restart (persisted in JSON file)
- [x] 9.10 Removing a bookmark cleans up the persisted attemptId
- [x] 9.11 Question bookmark cards in Bookmarks screen have consistent height
- [x] 9.12 Long question text shows ellipsis after 2 lines
- [x] 9.13 Question text in bookmark list matches `bodySmall` typography (w500, 14px, height 1.4)
- [x] 9.14 LaTeX equations in truncated previews render with correct fontWeight
