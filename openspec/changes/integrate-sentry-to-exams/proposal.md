## Why

The application currently uses Sentry for centralized error tracking via the `core` package and has integrated it into `courses`, but the domain-specific `exams` package does not yet capture and log its exceptions. This change ensures that unhandled exceptions, network failures, and local processing/mapping errors within the `exams` module are tracked properly for monitoring and debugging.

## What Changes

- Inject `sentryServiceProvider` (from `core`) into `exams` repositories, providers, and UI screens.
- Replace or supplement empty, console-logging, or toast-only `catch` and `catchError` blocks in `exams` repositories (e.g., `OnlineExamRepository`, `OfflineExamRepository`, `SubjectAnalyticsRepository`), providers (e.g., `GenerateCustomExam`, `SubjectAnalyticsPagination`, `ExamList`), and screens/controllers (e.g., `OfflineExamActionButton`, `ReviewAnalyticsController`, `ReviewAnswerDetailScreen`, `TestDetailScreen`) with `sentryService.captureException`.
- Maintain clean decoupling: ensure `sentry_flutter` is not directly imported in the `exams` package, relying entirely on the abstraction in `core`.

## Capabilities

### New Capabilities
- `exams-error-tracking`: Capturing and logging exceptions within the exams module using the centralized SentryService.

### Modified Capabilities

## Impact

- **Code**: Modifies files across `packages/exams/lib/repositories/`, `packages/exams/lib/providers/`, `packages/exams/lib/screens/`, and `packages/exams/lib/widgets/` to capture exceptions.
- **Dependencies**: Uses `core`'s `sentryServiceProvider` for error reporting, maintaining the abstraction over the actual `sentry_flutter` package.
