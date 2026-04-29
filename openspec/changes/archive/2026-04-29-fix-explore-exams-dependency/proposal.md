## Why

The `explore` package incorrectly imports `package:exams` just to fetch a popular tests list, making two peer SDK modules aware of each other. This blocks the clean dissolution of `explore` as a standalone package into `courses`.

## What Changes

- Remove `package:exams` dependency from `explore/pubspec.yaml`
- Replace `examRepositoryProvider` usage with `dataSourceProvider` from `core`
- Add `getPopularTests()` to the `core` data source interface
- **Dissolve `packages/explore` into `packages/courses`** to simplify the monorepo architecture

## Capabilities

### New Capabilities
- `explore-popular-tests-datasource`: Popular tests data fetched via core's shared data source
- `integrated-explore-discovery`: Explore features now live directly inside the `courses` domain

### Modified Capabilities
- `explore-routing`: App router now points to `ExplorePage` in the `courses` package

## Impact

- `packages/courses` — now contains Explore screens, widgets, and providers
- `packages/explore` — deleted entirely
- `packages/testpress` — updated to import Explore features from `courses`
- `packages/core` — updated `DataSource` and models

