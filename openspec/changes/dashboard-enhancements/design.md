## Context

The home dashboard features several interactive elements including the Hero Banner Carousel, the "Recently completed" list, and horizontal carousels (`AppCarousel`). User feedback indicates friction in these areas:
- The Hero Banner's auto-scroll conflicts with manual swiping.
- "Recently completed" items have a 0.6 opacity that makes them look disabled.
- Horizontal carousels use `PageView` which forces snapping, preventing smooth and infinite continuous scrolling.

## Goals / Non-Goals

**Goals:**
- Pause the Hero Banner auto-play during user interaction.
- Remove opacity from "Recently completed" items.
- Enable smooth, non-snapping continuous horizontal scrolling in `AppCarousel`.

**Non-Goals:**
- We will not completely rewrite `AppCarousel`; we will update its properties to support smooth scrolling while retaining its page indicator.

## Decisions

1. **Hero Banner Interactivity**: 
   - **Decision**: Wrap the `PageView` inside `HeroBannerCarousel` with a `Listener` to detect `onPointerDown`, `onPointerUp`, and `onPointerCancel` events. This will pause the `Timer.periodic` while the user is touching the carousel.
   - **Rationale**: Direct touch detection via `Listener` is more reliable than `ScrollNotification` for distinguishing user interaction from timer-driven animations.

2. **Recently Completed Opacity**:
   - **Decision**: Update `LessonCardWidget` to render without reduced opacity when `isCompleted` is true. The `Opacity` widget will either be removed or its opacity value set to 1.0 unconditionally.
   - **Rationale**: Ensures the items are fully legible and do not appear disabled.

3. **Smooth Horizontal Scrolling**:
   - **Decision**: Set `pageSnapping: false` on the `PageView.builder` inside `AppCarousel`.
   - **Rationale**: Setting `pageSnapping: false` turns `PageView` into a smooth-scrolling list, fulfilling the request for continuous scrolling, while preserving the `PageController` logic needed by the existing `SmoothPageIndicator`.

## Risks / Trade-offs

- [Risk] Disabling `pageSnapping` in `AppCarousel` might cause the `SmoothPageIndicator` to behave slightly differently.
  - Mitigation: `ScrollingDotsEffect` handles continuous offsets smoothly, so it should visually transition fine even between integer pages.
