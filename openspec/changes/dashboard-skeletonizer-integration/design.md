## Context

The current dashboard implementation hides components like the `HeroBannerCarousel` when no data is available. On the first launch, the local database is empty, leading to a blank screen that "pops in" once network data arrives. We will integrate the `skeletonizer` package to provide a structural loading state that preserves the layout and improves perceived performance.

## Goals / Non-Goals

**Goals:**
- Implement flicker-free dashboard loading using `skeletonizer`.
- Keep providers **pure** (no dummy/fake data emissions).
- Centralize skeleton state management in the UI layer using Riverpod provider state and bootstrap orchestration.
- Ensure consistent aspect ratios for all dashboard sections during load.
- Maintain a scrollable UI even when all content is in a skeletonized state.

**Non-Goals:**
- Emitting placeholder DTOs or "dummy" objects from repositories or providers.
- Building custom manual shimmer animations for each component.

## Decisions

### 1. Centralized Dependency and Configuration
`skeletonizer` will be added as a dependency to shared packages. The dashboard screen applies `SkeletonizerConfig` locally so shimmer uses `Design` tokens and can respect motion preferences.

### 2. Pure Providers
Dashboard providers (e.g., `heroBannersProvider`, `whatsNewFeedProvider`) will remain pure. They will only emit real data, errors, or stay in a loading state. 
- **Rationale**: The data layer should not be polluted with UI concerns like skeletons or dummy models.

### 3. UI-Managed Skeleton State
The `PaidActiveHomeScreen` determines skeleton visibility using a bootstrap loading signal plus cache presence checks. 
- **Handling Cache Flicker**: The UI keeps skeletons visible while bootstrap refresh is loading and dashboard cache is empty, then switches to real content when cached or fresh data is available.

### 4. Null-Safe Widget Placeholders
Widgets like `HeroBannerCarousel` and `LessonCardsSection` will be updated to handle empty/null data gracefully while in a skeleton state.
- **Structural Integrity**: When loading, widgets build fixed placeholder structures. These placeholders may use UI-local skeleton DTO constants, but repositories/providers remain pure.

## Risks / Trade-offs

- **[Risk]** Complexity in UI logic to handle "Refreshing" states. → **Mitigation**: Use simple boolean logic based on `AsyncValue` properties to track network sync status.
- **[Trade-off]** More logic in the build methods of the home screen. → **Rationale**: This is the correct layer for UX/UI orchestration, keeping the rest of the app's architecture clean and testable.
