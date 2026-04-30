## Why

The "brilliantpala" tenant requires a specific navigation structure that prioritizes Exams and removes non-essential tabs like Explore and Profile to focus the user experience on core educational content.

## What Changes

- **Navigation Items**: Add an "Exam" tab to the primary navigation when the tenant is "brilliantpala".
- **Conditional Visibility**: Restrict the navigation tabs for "brilliantpala" to only: Home, Study, Exam, and Info.
- **Tenant Configuration**: Update `ClientConfig` to support feature flags for the Exam tab and restricted navigation mode.
- **Exam Landing Page**: Create a placeholder or basic entry point for the Exam tab within the `exams` package.

## Capabilities

### New Capabilities
- `exam-navigation`: Management of the Exam tab landing page and its integration into the app shell.

### Modified Capabilities
- `navigation-shell`: Requirement change to support dynamic tab lists and tenant-specific navigation filtering.

## Impact

- `packages/core`: `ClientConfig` and related providers.
- `packages/testpress`: `AppRouter` and navigation layout logic.
- `packages/exams`: New screen for the Exam tab.
