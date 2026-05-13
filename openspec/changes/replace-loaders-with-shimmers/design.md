## Context

Currently, several high-traffic UI views (like Explore and Courses screens) display either static spinners via `AppLoadingIndicator` or revert to empty `SizedBox.shrink()` while lazy-loading, leading to abrupt visual jumping when data arrives. 
The dashboard established a successful pattern using the `Skeletonizer` package which provides a responsive shimmer that mimics the actual content layout. This change scales that pattern globally.

## Goals / Non-Goals

**Goals:**
- Replace high-level container-level spinners/empty states with shimmer layouts.
- Implement deterministic skeleton counts (e.g., 6 courses for a list, 3 banners for a carousel) consistent with target density.
- Maintain layout structure (e.g., aspect ratios) during shimmer phase to minimize Cumulative Layout Shift (CLS).

**Non-Goals:**
- Replacing tiny inline loaders (e.g., button loading states).
- Refactoring repository logic or API pagination mechanisms.

## Decisions

### 1. Local Context Skeleton Counts
**Decision:** Standardize "loading density" within UI components by supplying fallback counts if `isSkeleton` is enabled.
- **Rational:** Guarantees correct shimmer coverage.
- **Details:** Explore sections will use 3-4 items for carousels and 4-6 items for lists while loading.

### 2. Explicit Skeleton Mock Objects
**Decision:** Retain existing pattern of creating private module-level const DTOs (e.g., `_skeletonCourse`) to populate fields required for layout measurement.
- **Rational:** Ensures Skeletonizer extracts precise text height and image bounds.

## Risks / Trade-offs

**[Risk]: Content overflow if skeleton data strings differ wildly from actual data lengths.**
*Mitigation*: Design skeleton text to closely approximate median field length (e.g., "Title Loading Example").
