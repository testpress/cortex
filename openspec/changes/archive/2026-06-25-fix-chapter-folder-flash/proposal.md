# Proposal: Fix Chapter Folder Flash

## Context
When navigating to a chapter in the study section, the UI incorrectly flashes the lesson list
and makes an unwanted contents API call. This happened due to two distinct bugs discovered
during investigation:

**Bug 1 — Empty DB on first visit:**
When `localChapters` is empty but `isChaptersSynced` is true, `subChaptersProvider` would
yield `[]` immediately and trigger a background sync. `ChaptersListPage` saw empty chapters
with `isLoading: false` and incorrectly fell through to the lesson list.

**Bug 2 — Pull-to-refresh cascade delete (race condition):**
When the user pulls to refresh the course list and then opens a course, `refreshCourses`
deletes all chapters from the DB in a background transaction. If the user opens a course mid-way,
`subChaptersProvider` may have already yielded real chapters, but the cascade delete causes the
`watchChapters` stream to emit `[]` again. Since the provider had already completed its initial
fetch logic (`keepAlive: true`, generator does not re-run), it streamed the empty state with
`isLoading: false`, causing the UI to flash to lesson mode.

**Bug 3 — Flawed UI gate:**
`ChaptersListPage` used `(chapters.isEmpty && !chaptersAsync.isLoading)` as a proxy for
"this is a leaf folder, show lessons". This heuristic fired on any DB empty event — including
external purges — regardless of whether the folder was actually a leaf.

## Proposed Change
Fix all three bugs:
1. `subChaptersProvider`: always `await refreshChapters()` when DB is empty (fix Bug 1).
2. `subChaptersProvider`: replace `yield*` with a resilient `await for` loop that detects
   `non-empty → empty` transitions and silently re-fetches (fix Bug 2).
3. `ChaptersListPage`: gate `showLessons` exclusively on `widget.isLeaf` (set from the
   API's `chapter.leaf` field) or an active filter tab — never on `chapters.isEmpty` (fix Bug 3).

## Scope
- `packages/courses/lib/providers/course_detail_provider.dart`
- `packages/courses/lib/screens/chapters_list_page.dart`
