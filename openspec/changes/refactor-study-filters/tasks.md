## 1. Remove Lesson Filter

- [x] 1.1 Remove `lesson` from `CurriculumFilter` enum in `chapters_filter_tab_bar.dart`
- [x] 1.2 Remove any usages or fallback logic tied specifically to `CurriculumFilter.lesson` in `ChaptersFilterRules` or providers

## 2. Update Chapters Filter UI

- [x] 2.1 Update `ChaptersFilterTabBar` to accept `activeFilter` as `CurriculumFilter?` instead of non-nullable
- [x] 2.2 Change `_onFilterChanged` to toggle the filter off if the user taps the currently active filter, emitting `null`

## 3. Update Chapters List Page State Logic

- [x] 3.1 Update `_activeFilter` variable in `_ChaptersListPageState` to be `CurriculumFilter?` defaulting to `null`
- [x] 3.2 Update `_onFilterChanged` in `_ChaptersListPageState` to accept and set a nullable `CurriculumFilter?`
- [x] 3.3 Update `_apiTypeForFilter` to handle `null` gracefully and remove the explicit `lesson` branch
- [x] 3.4 Ensure `activeFilter` passed to `ChaptersFilterTabBar` is resolved safely handling nulls

## 4. Update View Logic (Folder vs Flat View)

- [x] 4.1 Update `showChapters` boolean logic: `activeFilter == null && chapters.isNotEmpty`
- [x] 4.2 Update `filteredLessons` logic: if `activeFilter == CurriculumFilter.all` show all `lessons`. Remove old explicit lesson mapping logic.
- [x] 4.3 Update fallback states to correctly display empty states for Folder View vs Flat View.

## 5. Add Notes and Attachment Filters

- [x] 5.1 Add `notes` and `attachment` to `CurriculumFilter` enum and its display name
- [x] 5.2 Add new filter tabs in `ChaptersFilterTabBar` with appropriate icons
- [x] 5.3 Update `_apiTypeForFilter` in `_ChaptersListPageState` for notes and attachments
- [x] 5.4 Update fallback filtering in `_ChaptersListPageState` to map `CurriculumFilter.attachment` to `[attachment, pdf]` and `notes` to `[notes, embedContent]`
- [x] 5.5 Update DB local filter in `course_repository.dart` to support grouping `pdf` under `attachment` and `embedContent` under `notes`
