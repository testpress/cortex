## Context

Currently, the `core`, `courses`, and `exams` packages handle errors and exception tracking by using the centralized `SentryService` defined in `core` (exported via `sentryServiceProvider`). The remaining packages (`discussions`, `profile`, and `testpress`) lack central error reporting and swallow or local-print caught exceptions. See `proposal.md` for motivation.

## Goals / Non-Goals

**Goals:**
- Inject `SentryService` into repository layers in the discussions package.
- Read and utilize `sentryServiceProvider` in Riverpod providers to report errors in asynchronous/generator methods.
- Capture unexpected and generic runtime exceptions in presentation-level event handlers (e.g., login, registration, bookmark deletion).
- Standardize catch blocks to capture both the error and its stack trace (`catch (e, stackTrace)`).

**Non-Goals:**
- Modifying Sentry configuration or initialization inside `core/lib/data/services/sentry_service.dart`.
- Reporting anticipated validation/business errors (e.g. invalid password formatting, cancellation exceptions) to Sentry.

## Decisions

### Decision 1: Constructor Injection of SentryService in Repositories
We will update `ForumRepository` to accept `SentryService` in its constructor.
* **Rationale**: This is standard across other packages (`exams` and `courses`), keeps repository classes independent of Riverpod framework imports, and allows easy mocking during testing.
* **Alternative Considered**: Accessing the provider directly or using global functions (rejected to maintain clean architecture).

### Decision 2: Watch and Pass SentryService in Providers
In Riverpod providers that instantiate repositories (like `forumRepositoryProvider`), we will watch `sentryServiceProvider` and inject it.
* **Rationale**: Leverages Riverpod's dependency injection to pass the active service down.

### Decision 3: Capture Exceptions in Presentation Event Handlers
Inside UI screens and controllers, when user-triggered operations fail unexpectedly (e.g. profile edit, OTP verification, or bookmark deletion), we will catch the exception, show the local user-facing message, and capture the error with Sentry.
* **Rationale**: This captures failures that occur before or during presentation flows, ensuring full coverage of crucial flows (such as onboarding and authentication).

## Risks / Trade-offs

* **Risk**: High noise in Sentry from transient network issues (e.g. offline status).
  * **Mitigation**: The global `onNetworkErrorCapture` handles network-level timeouts gracefully, and standard business API errors (`ApiException`, `AuthException`) will not be reported.
* **Risk**: Riverpod boilerplate in stateful/stateless widgets.
  * **Mitigation**: Standardize on utilizing `ref.read(sentryServiceProvider)` inside UI interaction callbacks (e.g., button `onPressed`) only when there is an unexpected failure.
