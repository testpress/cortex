## Context

The `ChapterContentItem` widget in `packages/courses/lib/widgets/chapter_content_item.dart` renders every lesson (video, PDF, test, etc.) in the chapter content list. The `Lesson` model already carries a `hasAttempts: bool` field that is populated from the API field `has_attempts`, persisted to the local Drift DB, and used elsewhere (e.g. to filter the "History" tab in `chapter_detail_page.dart`).

The field is fully wired end-to-end — the only missing piece is that `ChapterContentItem` does not render any visual indicator when `hasAttempts` is true.

The design system provides `design.colors.accent4` (green) and `LucideIcons.check` for consistent completion iconography.

## Goals / Non-Goals

**Goals:**
- Render a small green circular tick badge on the trailing side of a `ChapterContentItem` when `lesson.hasAttempts == true`
- Badge applies only to exam/assessment content types (`LessonType.test`, `LessonType.assessment`)
- Reuse existing design tokens — no hardcoded colours or ad-hoc sizes
- Zero API, model, or DB changes

**Non-Goals:**
- Showing the badge on non-exam content types (videos, PDFs, notes)
- Showing attempt count or score on the card
- Adding any new API field — `has_attempts` is already available

## Decisions

### 1. Badge placement — top-right of left thumbnail
**Decision:** Position the badge at the top-right corner of the left thumbnail image/container (using `Stack` and `Positioned(top: -6, right: -6)`), overlapping the image boundary, and surrounded by a border matching the card background.

**Rationale:** This matches the Android app visual specification exactly. The badge overlaps the thumbnail to provide a tight, cohesive visual relationship, while the card-colored border separates it cleanly from the thumbnail content.

**Alternative considered:** Placing the badge to the left of the chevron arrow — rejected because it doesn't match the Android app's layout, where the badge sits on the thumbnail.

### 2. Badge only for exam types
**Decision:** Conditionally show badge only when `lesson.type == LessonType.test || lesson.type == LessonType.assessment`.

**Rationale:** `hasAttempts` is technically set for any content with a `ChapterContentParticipant` record. However, "attempted" is only meaningful UX for exams. For videos/PDFs, watch percentage and the progress status already convey completion state.

### 3. Design tokens — `accent4` + `LucideIcons.check`
**Decision:** Use `design.colors.accent4` (already mapped to green in both light and dark themes) and `LucideIcons.check`.

**Rationale:** Consistent with the existing `_getColorForType` mapping in the same widget (`assessment` already uses `accent4`). Avoids introducing a new colour token.

### 4. Badge size — 22×22 circle, icon size 13
**Decision:** Fixed 22×22 container with a 13px icon.

**Rationale:** Matches the visual weight of the `chevronRight` (20px) without overpowering the card layout. Small enough to not clip on tight screens.

### 5. Correct `hasAttempts` determination for exams
**Decision:** In `CurriculumParser.parseFullCurriculum`, when parsing the attempts sync payload, determine attempt and completion state strictly from the presence of a finished attempt (nested `state: 1` or `completed`) inside the `content_attempts` list. In `CourseRepository._applyContentStatuses`, apply attempts and progress updates for non-video lessons strictly using these parsed remote attempt records.

**Rationale:** The endpoint payload includes a `chapter_contents` sidecar list that contains metadata (like `attempts_count`), but this can be stale or incorrect. Deriving completion strictly from actual `content_attempts` records ensures accuracy. Furthermore, we must check the nested attempt `state` inside `content_attempts` to filter out in-progress attempts (`state: 0`), so that ticks only show when attempts count is actually > 0.

## Risks / Trade-offs

- **Stale `hasAttempts` data**: If a user completes an exam on another device and the local DB hasn't synced, the badge won't appear immediately. → Mitigated by the existing `refreshContentStatuses` call in `ChapterDetailPage.initState`, which fetches fresh statuses on every page load.

- **Badge not visible for locked content**: Locked lessons already show a lock icon overlay on the thumbnail. If an admin accidentally marks a locked lesson as having attempts (edge case), the badge will still render. → Acceptable; it's a rare admin-side scenario and doesn't break UX.

## Migration Plan

No data migration required. No API versioning needed. The change is purely additive to one widget file:

1. Modify `chapter_content_item.dart` to add the badge widget
2. Manually verify on a real device/emulator against a course with at least one completed exam
3. No rollback complexity — removing the badge is a one-line change

## Open Questions

- None. All dependencies (data, tokens, icons) are confirmed available.
