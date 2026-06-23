## Why

Users cannot visually tell which exams/tests they have already completed when browsing the chapter content list. The `has_attempts` field is already returned by the API and stored in the local DB — it just isn't shown in the UI, leaving users without the green completion badge they expect.

## What Changes

- Add a green circular tick badge to `ChapterContentItem` for any lesson where `lesson.hasAttempts == true`
- Badge renders only for `LessonType.test` and `LessonType.assessment` types (exams only, not videos/PDFs)
- Badge sits on the top-right corner of the left thumbnail image/container, overlapping its boundary
- No API changes, no model changes, no DB migration — data is derived strictly using actual attempt records in `content_attempts` during status synchronization

## Capabilities

### New Capabilities

- `exam-completion-badge`: Visual indicator (green tick) on exam content cards showing the user has previously attempted the exam

### Modified Capabilities

- `chapter-detail`: The chapter detail content list now renders a completion badge on exam items when `hasAttempts` is true

## Impact

- **Modified file**: `packages/courses/lib/widgets/chapter_content_item.dart` — add badge widget to the row's trailing section
- **No API impact**: `has_attempts` already flows from backend → `LessonDto.hasAttempts` → `Lesson.hasAttempts` → DB → UI
- **No model/DB impact**: field is fully wired already
- **Design tokens used**: `design.colors.accent4` (green) for badge background, `LucideIcons.check` for the checkmark icon
