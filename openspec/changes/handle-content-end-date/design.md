## Context
The v2.5 API for chapter contents now returns `end` (the expiration date/time) and `has_ended` (a boolean indicating if the content is expired) fields. Currently, our `Lesson` and `LessonDto` models do not capture these fields, meaning the app does not restrict access or show visual indicators when content has expired. We need to parse these fields, block navigation to expired content, and display a locked state in the UI.

## Goals / Non-Goals

**Goals:**
- Parse `end` (String) and `has_ended` (bool) from the API response into `LessonDto` and `Lesson` models.
- Prevent users from opening a lesson if `has_ended` is true, showing a toast message: "Your access to this content has ended!"
- Update the content list item UI (`ChapterContentItem` or equivalent) to display a lock icon and the text "Access expired on <end_date>" when `has_ended` is true.

**Non-Goals:**
- Implementing local timers to automatically expire content while the user is actively viewing it (we rely on the API response state).
- Redesigning the entire lesson list UI.

## Decisions

1. **Model & Database Updates**:
   - `LessonDto` (in `core`) will be updated to include `final String? end;` and `final bool hasEnded;`.
   - `Lesson` (in `courses`) will be updated similarly.
   - `LessonsTable` (in `core/lib/data/db/tables/lessons_table.dart`) will be updated to add `TextColumn get end => text().nullable()();` and `BoolColumn get hasEnded => boolean().withDefault(const Constant(false))();`.
   - Run drift build runner to generate the updated local database schema.
   - `LessonNetworkMapper` (or equivalent API mapping layer) will parse `end` and `has_ended`.

2. **Access Control**:
   - The click handler in `study_content_list.dart` or `chapter_content_item.dart` will check `lesson.hasEnded`. If true, it will show the toast using the existing toast/snackbar utility and abort navigation.

3. **UI Representation**:
   - Inside the list item widget, if `lesson.hasEnded` is true, we will render a lock icon and a text label displaying "Access expired on <readable_date>". We'll parse the `end` date string into a readable format (e.g., using `intl` DateFormat or existing date utilities).

## Risks / Trade-offs
- [Risk] Date parsing could fail if the API returns a non-standard ISO-8601 format. 
  - Mitigation: We'll safely parse the date and fallback to showing "Access expired" without the date if parsing fails, or use standard `DateTime.tryParse`.
