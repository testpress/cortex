## Why

Replacing basic loading spinners with structured `Skeletonizer` shimmer effects improves perceived performance and provides a much cleaner visual transition while content is loading. It fulfills the core design philosophy by maintaining the visual structure of the screen instead of an abrupt layout shift.

## What Changes

- Replace `AppLoadingIndicator` with structured shimmers using `Skeletonizer`.
- Standardize skeleton logic across Explore screens, Course grids, and List layouts.
- Ensure item counts during loading reflect reasonable real-world density instead of random counts.
- Introduce localized "Skeleton DTOs" for different models to power consistent shimmer text sizing.

## Capabilities

### New Capabilities
<!-- None, extending existing infrastructure -->

### Modified Capabilities
- `shimmer-loading-infrastructure`: Expand standard requirements from the dashboard context to the global application scope, covering Explore views, Search Results, Course Lists, and Details screens.

## Impact

- All packages utilizing `AppLoadingIndicator` or displaying content loading screens (`courses`, `exams`, `testpress`).
- Updates to common screen compositions to support `isSkeleton` state propagation.
