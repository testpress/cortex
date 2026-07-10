# Question Bookmark Button in Exam Review

## Data Model

### `QuestionDto`

Add an optional `bookmarkId` field:

```dart
class QuestionDto {
  // ... existing fields ...
  final int? bookmarkId;

  const QuestionDto({
    // ... existing params ...
    this.bookmarkId,
  });

  QuestionDto copyWith({
    // ... existing params ...
    int? bookmarkId,
  }) {
    return QuestionDto(
      // ... existing params ...
      bookmarkId: bookmarkId ?? this.bookmarkId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // ... existing keys ...
      'bookmark_id': bookmarkId,
    };
  }

  factory QuestionDto.fromJson(Map<String, dynamic> json) {
    return QuestionDto(
      // ... existing keys ...
      bookmarkId: (json['bookmark_id'] as num?)?.toInt(),
    );
  }
}
```

### `ReviewItemDto.toQuestionDto()`

```dart
QuestionDto toQuestionDto() {
  return QuestionDto(
    // ... existing params ...
    bookmarkId: bookmarkId,  // NEW: pass through
  );
}
```

## Widget — `ReviewQuestionCard._QuestionHeader`

### Layout

The header row currently has:
```
[icon] [question #] ................................ [badge pill]
```

After change:
```
[icon] [question #] ................... [bookmark icon] [badge pill]
```

The bookmark icon sits between the question number text and the badge pill, aligned to the right side of the row.

### Bookmark Icon

- **Not bookmarked** (`bookmarkId == null`): `Icon(LucideIcons.bookmark, size: 20, color: design.colors.textSecondary)`
- **Bookmarked** (`bookmarkId != null`): `Icon(LucideIcons.bookmark, size: 20, color: design.colors.primary)` — filled variant (use `color: design.colors.primary`)
- Touch target: minimum 48x48dp (wrap in `AppSemantics.button` with a `GestureDetector` or `InkWell`)
- Icon uses the same `LucideIcons.bookmark` in both states, just different colors

### Accessibility

```dart
AppSemantics.button(
  label: isBookmarked ? l10n.bookmarkRemove : l10n.bookmarkSaveTo,
  onTap: onBookmarkToggle,
  child: GestureDetector(
    onTap: onBookmarkToggle,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: EdgeInsets.all(8),  // ensure 48dp touch target
      child: Icon(...),
    ),
  ),
)
```

## Behavior — `ReviewAnswerDetailScreen`

### State fields

```dart
bool _isBookmarkSheetOpen = false;
bool _isCreateFolderDialogOpen = false;
```

### Current question derivation

```dart
final currentQuestion = ...;  // already exists
final parsedLessonId = int.tryParse(currentQuestion.id) ?? 0;
```

### Remove bookmark

```dart
Future<void> _removeBookmark(QuestionDto question) async {
  final bookmarkId = question.bookmarkId;
  if (bookmarkId == null) return;
  
  final l10n = AppLocalizations.of(context)!;
  AppToast.show(context, message: l10n.bookmarkRemoved);

  try {
    await ref.read(removeBookmarkProvider(
      bookmarkId: bookmarkId,
      lessonId: int.tryParse(question.id) ?? 0,
    ).future);
  } catch (e, stack) {
    debugPrint('Error removing bookmark: $e\n$stack');
    if (mounted) {
      AppToast.show(context, message: L10n.of(context).errorFailedToRemoveBookmark, isError: true);
    }
  }
}
```

### Bookmark toggle handler

```dart
void _onBookmarkToggle(QuestionDto question) {
  if (question.bookmarkId != null) {
    _removeBookmark(question);
  } else {
    setState(() => _isBookmarkSheetOpen = true);
  }
}
```

### Pass to `ReviewQuestionCard`

```dart
ReviewQuestionCard(
  question: currentQuestion,
  attemptState: _attemptStates[currentQuestion.id],
  l10n: l10n,
  isCorrect: isAnswerCorrect(currentQuestion),
  isUnanswered: isUnanswered(currentQuestion),
  questionNumber: ...,
  onBookmarkToggle: () => _onBookmarkToggle(currentQuestion),
)
```

### BookmarkFoldersSheet placement

Add to the existing `Column` below the `ReviewNavigation`, wrapped in `Stack`:

```dart
Stack(
  children: [
    // existing column content (header, filter, question card, footer, nav, summary)
    Column(...),
    
    AppBottomSheet(
      isOpen: _isBookmarkSheetOpen,
      onClose: () => setState(() => _isBookmarkSheetOpen = false),
      child: BookmarkFoldersSheet(
        lessonId: int.tryParse(currentQuestion.id) ?? 0,
        category: 'question',
        parentContext: context,
        onClose: () => setState(() => _isBookmarkSheetOpen = false),
        onCreateFolderRequest: () {
          setState(() {
            _isBookmarkSheetOpen = false;
            _isCreateFolderDialogOpen = true;
          });
        },
      ),
    ),
    if (_isCreateFolderDialogOpen)
      CreateFolderDialog(
        lessonId: int.tryParse(currentQuestion.id) ?? 0,
        category: 'question',
        onClose: () => setState(() => _isCreateFolderDialogOpen = false),
      ),
  ],
)
```

## Navigation from Bookmarks Screen

### Problem

When a user bookmarks a question from the review screen and later taps that bookmark in the Bookmarks screen, we need to navigate back to `ReviewAnswerDetailScreen` at the exact question. This requires passing the `attempt_id` to fetch the review items, and passing the `lessonId` (which acts as the `questionId`) so the screen can open to the correct index.

### Solution: Native Backend Support

The backend `/api/v2.4/bookmarks/` API now natively returns the `attempt_id` field. We parse this directly into `BookmarkDto`, persist it in Drift, and use it seamlessly during navigation. 

### BookmarkDto Changes

```dart
class BookmarkDto {
  // ... existing fields ...
  final int? attemptId; 

  factory BookmarkDto.fromJson(Map<String, dynamic> json) {
    return BookmarkDto(
      // ... existing fields ...
      attemptId: (json['attempt_id'] as num?)?.toInt() ?? (json['attemptId'] as num?)?.toInt(),
    );
  }
}
```

The `attemptId` is mapped directly into `BookmarkItemsTable` in Drift, completely avoiding any need for a local JSON attempt store.

### Bookmarks Screen Navigation

```dart
void _navigateToBookmark(BuildContext context, BookmarkDto bookmark) {
  switch (type) {
    case 'question':
    case 'userselectedanswer':
      if (bookmark.attemptId != null) {
        _navigateToReviewQuestion(context, bookmark);
      }
      break;
  }
}

void _navigateToReviewQuestion(BuildContext context, BookmarkDto bookmark) {
  final attemptId = bookmark.attemptId!;
  final navigator = Navigator.of(context);

  navigator.push(
    AppRoute(
      page: ReviewAnswerDetailScreen(
        assessmentTitle: bookmark.chapterName,
        questions: const [],
        attemptStates: const {},
        attempt: AttemptDto(id: attemptId),
        onBack: () => navigator.pop(),
        initialQuestionId: bookmark.lessonId.toString(),
      ),
    ),
  );
}
```

By providing `initialQuestionId` to `ReviewAnswerDetailScreen`, the detail screen fetches the review items itself and natively dynamically calculates the index internally, eliminating massive fetching and mapping boilerplate in the `bookmarks_screen`.



### ReviewAnswerDetailScreen Listener

```dart
ref.listen(bookmarksForLessonProvider(parsedLessonId), (prev, next) {
  next.whenOrNull(data: (bookmarks) {
    if (!mounted || currentQuestion == null) return;
    final newBookmarkId = bookmarks.isNotEmpty ? bookmarks.first.id : null;
    if (newBookmarkId != currentQuestion!.bookmarkId) {
      setState(() {
        final idx = _questions.indexWhere((q) => q.id == currentQuestion!.id);
        if (idx != -1) {
          _questions[idx] = _questions[idx].copyWith(bookmarkId: newBookmarkId);
        }
      });
      if (newBookmarkId != null &&
          currentQuestion!.bookmarkId == null &&
          widget.attempt?.id != null) {
        ref.read(bookmarkRepositoryProvider).future.then((repo) {
          repo.saveAttemptId(newBookmarkId, widget.attempt!.id!);
        });
      }
    }
  });
});
```

### Refreshing bookmark state after API call

After `_removeBookmark` succeeds, update the local question's `bookmarkId` to `null` so the icon immediately reflects the new state:

```dart
setState(() {
  final idx = _questions.indexWhere((q) => q.id == question.id);
  if (idx != -1) {
    _questions[idx] = question.copyWith(bookmarkId: null);
  }
});
```

Similarly, after the `BookmarkFoldersSheet` adds a bookmark, the provider stream will push the new bookmark through `bookmarksForLessonProvider`. However, since `_questions` is in local state, we need to either:
- Listen to the stream and update matching questions, or
- Invalidate and refetch review items, or
- After the sheet closes, manually update the local state

The simplest approach: after the `BookmarkFoldersSheet` `onClose` fires, use the `bookmarksForLessonProvider` stream to check for the newly created bookmark and update `_questions` state accordingly (or refetch).
