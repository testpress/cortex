## Context
The application uses `SentryService` in the `core` package to centralize error reporting. Currently, the `courses` package catches exceptions but either swallows them or logs them locally without sending them to Sentry. This prevents developers from having visibility into production issues happening in the `courses` module.

## Goals / Non-Goals

**Goals:**
- Inject `sentryServiceProvider` from the `core` package into all relevant repositories and providers in the `courses` package.
- Ensure that unhandled exceptions and critical errors in `courses` are captured in Sentry.
- Attach `SentryService.createNavigatorObserver()` to any custom routers used within the `courses` package to improve breadcrumb tracking.

**Non-Goals:**
- Modifying the underlying `sentry_flutter` implementation inside the `core` package.
- Adding error tracking to packages other than `courses` in this change.

## Decisions
- **Use `sentryServiceProvider` via Riverpod:** We will read `sentryServiceProvider` from `ref` wherever possible (e.g., in Riverpod providers). For repositories, we will pass it as a dependency or read it if the repository initialization has access to `ref`.
- **Maintain Abstraction:** We will strictly use the abstraction provided by `SentryService` (like `captureException`) and avoid importing `sentry_flutter` directly in the `courses` package.
- **Selective Logging:** Not all caught exceptions need to go to Sentry. We will evaluate `catch` blocks and primarily capture unexpected errors (e.g., parsing failures, critical API failures, null pointer exceptions).

## Risks / Trade-offs
- **Risk:** Noise in Sentry due to capturing expected or recoverable errors. 
  - **Mitigation:** Carefully review which exceptions are sent to Sentry. Avoid sending expected validation errors or basic offline exceptions unless they indicate a larger failure.
