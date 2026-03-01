## Context
The `ChapterDetailPage` is a core screen in the Study tab of the LMS Coaching App. It provides a detailed view of the content within a chapter, mapped from the React `ChapterDetailPage.tsx` component.

## Goals / Non-Goals

**Goals:**
- Implement the `ChapterDetailPage` widget in `packages/courses`.
- Support status filters (Running, Upcoming, History) for categorization.
- Implement specialized list items for each content type (Video, PDF, Assessment, Test) with corresponding icons and styling.
- Integrate with `GoRouter` for seamless navigation from the course/chapter lists.

**Non-Goals:**
- Implementing the actual content readers/players (VideoPlayer, PDFReader) — these are separate screens.
- Implementing complex search within the chapter — list is expected to be manageable.

## Decisions

### 1. Component Location
- **Decision:** Place `ChapterDetailPage` in `packages/courses/lib/ui/chapter_detail/`.
- **Rationale:** This screen is specific to the course hierarchy and should reside in the `courses` package.

### 2. State Management
- **Decision:** Use Riverpod `StateProvider` to manage the selected status filter (`running`, `upcoming`, `history`).
- **Rationale:** The filtering is purely UI-driven and simple enough for a localized `StateProvider`.

### 3. Navigation Structure
- **Decision:** Add a route `/study/chapter/:chapterId` in the main `GoRouter` configuration.
- **Rationale:** Enables deep linking to specific chapter details and follows the navigation shell patterns.

### 4. Reusing Core Primitives
- **Decision:** Utilize `AppBadge` for status indicators if needed and `DesignColors` for content type icons.
- **Rationale:** Ensures consistency with the established design system tokens.

## Risks / Trade-offs

- **[Risk] Data model inconsistency** → **Mitigation**: Ensure `Chapter` and `Lesson` models in `packages/courses` are robust and support the necessary fields (secondary label, duration, type).
- **[Risk] Status filter complexity** → **Mitigation**: If filtering logic becomes complex (e.g., involving database queries), move it to a `StreamProvider` or `Notifier` instead of simple list filtering.
