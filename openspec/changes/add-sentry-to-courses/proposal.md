## Why

The application currently uses Sentry for centralized error tracking via the `core` package, but the domain-specific `courses` package is not yet capturing and logging its exceptions. This change ensures that unhandled exceptions, network failures, and parsing errors within the `courses` module are tracked properly for monitoring and debugging.

## What Changes

- Inject `sentryServiceProvider` (from `core`) into `courses` repositories, providers, and UI screens.
- Replace empty or console-logging `catch` blocks in repositories (e.g., `CourseRepository`, `StoreRepository`), providers (e.g., `LessonDetailProvider`), and screens (e.g., `DownloadsScreen`) with `sentryService.captureException`.
- Attach `SentryService.createNavigatorObserver()` to any course-specific routing if applicable.

## Capabilities

### New Capabilities
- `courses-error-tracking`: Capturing and logging exceptions within the courses module using the centralized SentryService.

### Modified Capabilities

## Impact

- **Code**: Modifies files across `packages/courses/lib/repositories/`, `packages/courses/lib/providers/`, and `packages/courses/lib/screens/` to enhance error catching.
- **Dependencies**: Uses `core`'s `sentryServiceProvider` for error reporting, maintaining the abstraction over the actual `sentry_flutter` package.
