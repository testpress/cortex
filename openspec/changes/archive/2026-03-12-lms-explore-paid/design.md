## Context

The "Explore" functionality in the current application is represented by a placeholder screen. The original design specifies a rich discovery experience that includes global search, featured content carousels, trending/recommended course lists, and a study tips section. This design document outlines the technical approach to building the "Explore" feature as a modular package.

## Goals / Non-Goals

**Goals:**
- **Modularization**: Implementation of the feature within a new `packages/explore` package to ensure clean separation of concerns.
- **Discovery Experience**: A responsive dashboard containing search, banners, and multiple horizontal scrolling sections for content discovery.
- **Content Entry Points**: Provide clear entry points for "Study Tips", Most Watched Videos, and Popular Tests.

**Non-Goals:**
- **Real-time Backend Integration**: While the API structure will be defined, the initial implementation will rely on an enhanced `MockDataSource` in the `core` package.
- **Social Features**: Features like commenting on study tips or following other learners are out of scope for this change.

## Decisions

1.  **Architecture: New `explore` Package**
    - **Decision**: Create a dedicated package `packages/explore`.
    - **Rationale**: The Explore feature is semi-independent of the core "Study" flow. It has unique visual primitives (medal badges, featured banners) and discovery logic that would bloat the `courses` package if combined. 
    - **Alternatives**: Placing Explore inside `packages/courses`. Rejected because it violates the "Single Responsibility" of the courses package (which is meant for curriculum management) and would increase build times for the largest module.

2.  **UI Construction: Sliver-based Dashboard**
    - **Decision**: Use a single `CustomScrollView` with multiple `SliverToBoxAdapter` and `SliverList` components.
    - **Rationale**: This ensures optimal performance when rendering many different types of sections (banners, horizontal lists, featured content) in a single scrolling view, as Flutter will only render what is visible on screen.

3.  **Data Modeling: Extended DTOs**
    - **Rationale**: These are new entities required specifically for the Explore experience. While `ExploreBannerDto` and `StudyTipDto` are centralized in `packages/core`, `TestDto` is reused from `packages/exams` to maintain domain ownership of examination data.

## Risks / Trade-offs

- [Risk] **Asset Load Intensity** → **Mitigation**: Featured banners can be heavy. We will use `Image.network` with optimized thumbnail sizes and handle error states using a placeholder widget to ensure a smooth scrolling experience.
- [Risk] **Complex Scroll Persistence** → **Mitigation**: Use `PageStorageKey` for horizontal lists within the Explore dashboard to ensure that scroll positions are maintained when switching between tabs.
