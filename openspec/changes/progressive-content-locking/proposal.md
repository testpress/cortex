## Why

When learners open locked content before completing its prerequisites, the lesson screen gets stuck in an infinite skeleton loading state without explaining why access is denied. In addition, list items allow opening locked content, while expired and locked lessons share overlapping visual cues. We need proper progressive lock handling to guard list navigation, clearly differentiate locked vs. expired states, and display an informative notice screen instead of an endless loading skeleton.

## What Changes

- Integrate progressive lock enforcement into the curriculum data layer to track prerequisite completion status for each lesson.
- Guard chapter and course list interactions to prevent navigation into locked content while displaying clear user feedback.
- Visually differentiate locked prerequisite content (`LucideIcons.lock`) from time-expired content (`LucideIcons.calendarClock`) across all course lists.
- Introduce a dedicated `ContentNoticeView` in the lesson orchestrator to explain prerequisite requirements when a learner encounters locked content during player navigation.
- Suppress secondary actions (bookmarking, manual completion, downloads, and doubt inquiries) on locked or expired content while preserving next/previous navigation controls.
- Add localized notice titles, prerequisite instructions, and expiration messages across English, Tamil, Arabic, and Malayalam.

## Capabilities

### New Capabilities
- `progressive-content-locking`: Enforces sequential course progression by tracking locked content states, gating list access, and presenting prerequisite guidance in the player.

### Modified Capabilities
- `content-expiration`: Distinguishes time-based content expiry with dedicated calendar clock iconography and formatted expiration notices.

## Impact

- `packages/core/lib/data/models/lesson_dto.dart`: Added lock state tracking.
- `packages/core/lib/data/sources/curriculum_parser.dart`: Integrated locked content resolution.
- `packages/core/lib/l10n/`: Multi-language strings for lock, unlock toast, and expiry notices.
- `packages/core/lib/widgets/content_notice_view.dart` (New): Shared notice component for locked and expired content exported by `package:core`.
- `packages/courses/lib/widgets/chapter_content_item.dart`: List item tap guards, status badge handling, and distinct lock/expiry icons.
- `packages/courses/lib/widgets/lesson_list_item.dart`: Course list tap guards, status badge handling, and icon updates.
- `packages/courses/lib/screens/lesson_detail_orchestrator.dart`: In-player locked and expired content handling with disabled actions.
- `packages/exams/lib/screens/exam_prescreen.dart`: Exam prescreen locked content notice rendering.
