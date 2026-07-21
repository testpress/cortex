## Context

The app currently lacks a centralized mechanism to track unhandled exceptions, particularly from network requests and background offline sync jobs. By introducing `sentry_flutter`, we can capture these errors, but we must be careful not to tightly couple all our domain packages (like `testpress`) to a specific third-party dependency. 

## Goals / Non-Goals

**Goals:**
- Capture all unhandled DioExceptions globally.
- Capture isolate crashes during Workmanager background tasks.
- Keep the Sentry SDK strictly encapsulated within the `core` package.

**Non-Goals:**
- Removing or replacing existing `debugPrint` or user-facing error dialogues.

## Decisions

**1. Dependency Inversion in Network Utils**
Instead of `network_utils.dart` directly calling `Sentry.captureException`, it exposes a nullable `onNetworkErrorCapture` callback. `SentryService` attaches to this callback during its own initialization. 
*Rationale:* Keeps the network layer pure and ignorant of crash reporting systems.

**2. Abstracting Sentry Types (AppErrorLevel)**
The `testpress` package previously imported `sentry_flutter` to use `SentryLevel.warning` and `SentryNavigatorObserver`. We introduced an `AppErrorLevel` enum in `core` and a `createNavigatorObserver()` factory.
*Rationale:* Completely removes `sentry_flutter` from all package `pubspec.yaml` files except `core`. If we migrate away from Sentry, we only change the mapper inside `SentryService`.

**3. Isolate Initialization**
Since Dart isolates do not share static memory, `SentryFlutter.init` called in the main isolate does not apply to background workers. `OfflineExamSyncWorker` now instantiates and initializes a fresh `SentryService` at the top of its `callbackDispatcher`.
*Rationale:* This is strictly necessary for Sentry to function inside background isolates.

## Risks / Trade-offs

- **Risk:** Background isolate Sentry initialization might delay the sync execution slightly.
  - *Mitigation:* The initialization is fast and relies purely on local configuration, avoiding network blocking during init.
