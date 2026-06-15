## ADDED Requirements

### Requirement: Unified Content Header Layout
The lesson detail headers (such as `LessonDetailHeader`, `LessonDetailShell`, and `VideoLessonDetailScreen`) MUST visually mirror the `CurriculumHeader` from the course list. They must use a two-row layout within a container with `design.colors.card` background and manual safe area padding (`safeArea.top + 12`).
- The first row MUST contain the Back button (left-aligned) and any action buttons (right-aligned).
- The action buttons MUST be absolutely positioned using a `Stack` so that taller buttons do not shift the Back button or title out of vertical alignment.
- The second row MUST contain the Lesson Title.
- The title MUST be moved from the lesson body up into this header to reclaim screen space.

#### Scenario: Viewing Lesson Detail Header
- **WHEN** a user opens the lesson detail page
- **THEN** the header is identical in padding and background to the course list header, and contains the lesson title on a second line with perfect vertical alignment.

### Requirement: Compact & Balanced Navigation Footer
The next and previous navigation buttons on the content detail page MUST be small and inline, similar to the exams UI.
- The footer container MUST NOT have a top border divider.
- The "Next" and "Previous" buttons MUST be wrapped in `Expanded` to take up equal halves of the screen width when both are present, or 100% width when only one is present.
- The "Previous" button MUST use a soft-pill style to indicate it is a secondary action: `design.colors.surfaceVariant` background, no border, and `design.colors.textPrimary` text.

#### Scenario: Displaying Navigation Buttons
- **WHEN** a user reaches the end of the content or scrolls to the bottom
- **THEN** the next and previous buttons are displayed compactly, filling the screen width evenly, with the previous button styled as a softer secondary pill.

### Requirement: Standardized Empty State Typography
Empty state messages within the Doubts tab MUST use standardized typography sizes to maintain a correct visual hierarchy.
- Titles MUST use `AppText.title` instead of `headline`.
- Subtitles/descriptions MUST use `AppText.caption` instead of `body`.

#### Scenario: Viewing Empty Doubts List
- **WHEN** a user views a lesson or doubt screen that has no content
- **THEN** the empty state text is appropriately sized and does not overpower the screen.
