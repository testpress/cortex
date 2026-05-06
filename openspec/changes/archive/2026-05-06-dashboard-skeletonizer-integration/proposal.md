## Why

The app currently experiences a noticeable layout shift (pop-in effect) on the first launch or after a fresh install. This happens because the local database is initially empty, causing dashboard streams to emit empty lists. Since UI components like the `HeroBannerCarousel` currently hide themselves when empty, the dashboard height jumps once network data arrives and the real content is rendered.

## What Changes

- Add `skeletonizer` as a dependency to the project.
- Apply a screen-level `SkeletonizerConfig` in the dashboard home screen using design tokens.
- **Pure Providers**: Implement dashboard providers as pure data streams and keep skeleton decisions in the UI layer.
- **UI-Managed Skeletons**: Update the dashboard UI to manage skeleton visibility using Riverpod's `AsyncValue` state.
- **Null-Safe Widgets**: Update dashboard widgets to render stable placeholder structures during loading using UI-local skeleton placeholders only.

## Capabilities

### New Capabilities
- `shimmer-loading-infrastructure`: Standardized approach for handling loading states across the dashboard using structural skeletons and pure providers.

### Modified Capabilities
- `lms-home-paid-active`: Update the home screen layout to support skeleton states for its sub-sections.

## Impact

- `packages/core`: Addition of `skeletonizer` dependency and shared shimmer design tokens.
- `packages/courses`: `HeroBannerCarousel` updated to handle null-safe rendering.
- `packages/testpress`: `PaidActiveHomeScreen` and `LessonCardsSection` updated to manage skeleton states purely in the UI layer.
