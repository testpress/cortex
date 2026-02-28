## Context

The `StudyPage` is the secondary hub (after Home) where users spend their time. It requires efficient navigation through potentially large course catalogs. The reference React implementation uses a flat list for courses but allows deep filtering by content type (Video, PDF, etc.).

## Goals / Non-Goals

**Goals:**
- Implement a search-enabled course list with sticky header.
- Support "Content Type" filtering that switches from a Course-view to a Lesson-view.
- Integrate the "Resume" mini-card for continuity.
- Follow the 4px vertical rhythm (8px/12px/16px) as established in the spacing audit.

**Non-Goals:**
- Implementation of the actual Lesson viewers (Video Player/PDF Viewer) - these are separate changes (`lms-lesson-detail`, `lms-video-lesson`).
- Offline data synchronization (handled by `lms-data-layer`).

## Decisions

### 1. View Switching Logic
**Decision**: Use a single `StudyPage` widget that conditionally renders either `CourseCardList` or `FilteredLessonList` based on whether any filters are selected.
**Rationale**: Simplifies state management. React implementation uses `getFilteredLessons()` which returns an empty array if no filters are active; we will follow this pattern but at the widget tree level.

### 2. Mini-Player (Resume Card) State
**Decision**: Use a Riverpod provider (`recentActivityProvider`) in `packages/data` to supply the resume card data globally.
**Rationale**: Allows the resume card to show up on both Home and Study tabs consistently without dual-implementation of fetch logic.

### 3. Visual Separation & Spacing
**Decision**: Use a Pure White (`#FFFFFF`) header for search/filters on a Slate-150 canvas background (`design.colors.canvas`).
**Rationale**: Adheres to the Premium Calibration contrast contract, providing a refined ~1.08:1 separation while maintaining the signature neutral aesthetic.

### 4. Floating Action & Search Refinements
**Decision**: 
- **Search Bar**: Flattened (no shadow), slim (8px vertical padding), using canvas background.
- **Filter Chips**: Compressed height using a `childAspectRatio` of 4.5.
- **Resume Card**: Refactored to use `AppCard` with `surfaceSoft` shadow and no border. Corner radius strictly follows the 16.0 invariant (`radius.card`).
- **Course Card**: Green progress bar (`success`) with percentage label aligned to the far right.
**Rationale**: Aligns with the Anti-Regression Rules (Border + Shadow stacking prohibited) and the Shadow Governance invariant established in Premium Calibration.

## Risks / Trade-offs

- **[Risk] High unique color count** → [Mitigation] Group colors into a `StudyTheme` extension or helper class to avoid inline hex-codes.
- **[Risk] Performance with large lists** → [Mitigation] Use `ListView.builder` (part of `AppScroll` primitive) for the courses.
