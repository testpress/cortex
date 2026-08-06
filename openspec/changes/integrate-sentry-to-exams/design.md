## Context

The application uses `SentryService` from the `core` package for centralized exception tracking. Currently, the `exams` package handles exceptions locally (using `debugPrint` or `dev.log` in development mode) or swallows them. We need to integrate exception reporting in the repositories, providers, and screen components of the `exams` package using the existing `SentryService` abstraction.

## Goals / Non-Goals

**Goals:**
- Inject `sentryServiceProvider` from the `core` package into all relevant repositories and providers in the `exams` package.
- Capture critical errors, parsing failures, and unexpected database or request failures in `exams` repositories and providers to Sentry.
- Keep the `exams` package free of direct dependencies on `sentry_flutter` by using the abstracted `SentryService`.

**Non-Goals:**
- Modifying the underlying `sentry_flutter` implementation inside `core`.
- Changing how network request errors are handled globally by `SentryService`.

## Decisions

- **Constructor Injection for Repositories**: We will update the constructors of `OnlineExamRepository`, `OfflineExamRepository`, and `SubjectAnalyticsRepository` to accept `SentryService`.
  - *Alternative Considered*: Reading `sentryServiceProvider` directly via global provider refs.
  - *Rationale*: Injection via constructors keeps the repositories pure, testable, and aligned with standard Clean Architecture. This matches the pattern established in the `courses` package (e.g., `CourseRepository`).
- **Riverpod Provider Updates**: We will watch `sentryServiceProvider` inside the respective Riverpod repository providers (`examRepositoryProvider`, `offlineExamRepositoryFactoryProvider`, and `subjectAnalyticsRepositoryProvider`) and pass it into the constructor.
- **Handling UI and Async notifier exceptions**: Riverpod controllers (`SubjectAnalyticsPagination`, `GenerateCustomExam`) and screens (`OfflineExamActionButton`, `ReviewAnalyticsController`, `ReviewAnswerDetailScreen`, `TestDetailScreen`) will read the `sentryServiceProvider` from their ref/context to capture errors.

## Risks / Trade-offs

- **Risk**: High frequency of connection/offline-sync failures in Sentry (noise).
  - **Mitigation**: Primarily capture unexpected processing/state errors and handle network exceptions gracefully or let Sentry filter them. Individual asset download failures will be handled as breadcrumbs rather than full-severity exceptions where appropriate.
