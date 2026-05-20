## Why

The Study tab course list is the clearest place where shimmer improves perceived loading without confusing the user. We want to keep that one structural skeleton experience and avoid spreading shimmer to other screens where the current loading UI is already familiar.

## What Changes

- Keep the Study tab course list as the only shimmer-based loading state in this change.
- Leave all other screens on their existing loading presentation.
- Preserve accessibility, motion preferences, and existing design tokens while changing only the Study list loading presentation.
- Keep the Study loading implementation close to the real card layout and let Skeletonizer drive the skeleton presentation from that layout.

## Capabilities

### New Capabilities
- `study-course-list-loading`: guidance for the Study tab course list loading state and its skeleton presentation.

### Modified Capabilities
- `shimmer-loading-infrastructure`: document the Study tab course list as the only shimmer-based loading surface in this change.
- `core/primitives`: keep the shared loading primitive behavior unchanged for button and inline loading flows.

## Impact

- Affects the Study tab course list in `packages/courses`.
- May keep existing loading behavior elsewhere unchanged.
- No API changes are expected for backend services; this is a presentation-layer change.
