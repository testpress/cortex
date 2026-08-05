## Context

Currently, `ChaptersListPage` and `ChapterDetailPage` are shared components used across the Study, Exams, and Info sections of the app. The top-level tab screens (Study, Exams, Info) already implement pull-to-refresh via `AppRefreshIndicator`. However, once a user navigates into a course and opens its chapters list or a chapter's lesson list, there is no standard gesture to reload content — they must navigate back and re-enter the screen.

`ChaptersListPage` uses `AppScroll` (wraps `SingleChildScrollView`) for the chapters view and a plain `ListView.builder` for the filtered lessons view. Neither is currently wrapped in an `AppRefreshIndicator`. Additionally, the empty-state view is rendered as a plain `Center` widget which is not scrollable, meaning an `AppRefreshIndicator` on the parent wouldn't work when the list is empty.

`ChapterDetailPage` already runs `syncChapterContents` + `refreshContentStatuses` in `initState`, but there is no way to re-trigger this while on the screen.

## Goals / Non-Goals

**Goals:**
- Add pull-to-refresh to `ChaptersListPage` in both chapter-list mode and filtered-lessons mode.
- Add pull-to-refresh to `ChapterDetailPage` to re-run the existing sync logic on demand.
- Ensure the pull gesture works even on short and empty lists by using `AlwaysScrollableScrollPhysics`.
- Fix the empty state in `ChaptersListPage` to be scrollable (use `SliverFillRemaining` inside `CustomScrollView`).

**Non-Goals:**
- Adding refresh to `ExamPrescreen` — exam attempt state cannot change while the user is on this screen.
- Adding refresh to lesson/content detail screens (video player, PDF viewer, etc.).
- Adding refresh to the top-level tab screens — already implemented.
- Introducing any new API endpoints or data providers.

## Decisions

### Decision: Await network calls directly in `ChaptersListPage` to preserve cache
- **Choice**: The `onRefresh` callback directly awaits `repo.refreshChapters(...)` for chapter mode, and `notifier.refresh()` for filtered lessons mode, without using `ref.invalidate`.
- **Rationale**: Using `ref.invalidate` destroys the provider's state, artificially dropping the local cache and causing the UI to flash skeleton loaders. By awaiting the network calls directly, the pull-to-refresh spinner stays active for the duration of the request while preserving the existing data on screen, fully respecting the offline-first architecture. A `refresh` method was added to `LessonPaginationController` and `FilteredLessons` notifier to enable this.

### Decision: Delegate to `ChapterDetailController` for `ChapterDetailPage`
- **Choice**: The `onRefresh` callback in `ChapterDetailPage` delegates to `chapterDetailControllerProvider.notifier.refresh()`, rather than calling repository methods directly.
- **Rationale**: The controller already orchestrates the `syncChapterContents` + `refreshContentStatuses` operations and handles error reporting (e.g., throwing so the UI can show a toast). Delegating to the controller keeps business logic out of the UI and maintains consistency with the initial load sequence.

### Decision: Fix empty-state scrollability with `SliverFillRemaining`
- **Choice**: Replace the `Center` widget in the empty-state branch of `ChaptersListPage` with a `CustomScrollView` containing `SliverFillRemaining`.
- **Rationale**: An `AppRefreshIndicator` requires its child to be a `Scrollable`. A plain `Center` is not scrollable, so the pull gesture would not register. `SliverFillRemaining(hasScrollBody: false)` centers the content while being scrollable.

### Decision: `AlwaysScrollableScrollPhysics` on all scroll views
- **Choice**: Pass `physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics())` to every scroll view wrapped by the `AppRefreshIndicator`.
- **Rationale**: Without `AlwaysScrollableScrollPhysics`, the pull gesture is disabled when the content does not overflow the viewport (i.e., very short lists). This is the same pattern used in `StudyScreen` and `ExamsScreen`.

## Risks / Trade-offs

- None identified. The integration purely exposes existing safe sync methods to a standard UI gesture without invalidating caches or altering core architecture.
