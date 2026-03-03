## Context

The `ChaptersListPage` is a sub-screen of the Study tab that provides a detailed curriculum view for a specific course. In the reference React implementation, this screen is the bridge between the top-level course list and individual lessons. It supports filtering content by type (Video, PDF, etc.) across the entire course.

## Goals / Non-Goals

**Goals:**
- Implement the `ChaptersListPage` as a stateful screen in `packages/courses`.
- Use a sticky header for the back button and course title, ensuring visibility during scroll.
- Support real-time content filtering with persistent tab state.
- Integrate subject-based color themes for chapter icons and status chips.
- Follow the 4px vertical rhythm (8px/12px/16px padding) as per existing design guidelines.

**Non-Goals:**
- Implementation of the full-screen lesson reader or video player (out of scope).
- Background data synchronization logic (handled by `appInitializationProvider`).

## Decisions

### 1. Unified Filtered View
**Decision**: Use a single `ListView.builder` that switches its content builder based on whether the "All" tab or a specific content filter is active.
**Rationale**: Simplifies the scroll physics and state management. When "All" is active, we list chapters; when a filter is active, we list a flattened list of all lessons of that type.

### 2. State-Based Tab Filtering
**Decision**: Use a local `StateProvider` (or generic `StateProvider` in `packages/courses/providers`) to track the `activeContentFilter`.
**Rationale**: While the reference implementation uses local `useState`, a Riverpod provider allows other parts of the system to potentially react or pre-load filtered data.

### 3. Subject-Specific Theme Injection
**Decision**: Chapters and content items will pull foreground/background colors directly from the `DesignStudyTheme` extension based on the course subject.
**Rationale**: Aligns with the premium design tokens; avoids hardcoding hex values and ensures high-contrast mode compliance.

### 4. Router Integration
**Decision**: Register the new route as `/study/:courseId/chapters` in `app_router.dart`.
**Rationale**: Allows direct deep-linking and structured parameter passing.

## Risks / Trade-offs

- **[Risk] High unique color count for status chips** → [Mitigation] Standardize on `AppBadge` variants (Success, Warning, Info, Locked) rather than ad-hoc color mapping.
- **[Risk] Large curriculum depth (chapters/lessons)** → [Mitigation] Use `ListView.builder` for all list rendering and `FutureProvider` for non-blocking UI entry.
