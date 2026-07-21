# 0006: Centralized Error Tracking with Sentry

## Context
The application lacked a global mechanism to track unhandled exceptions, network failures, and background isolate crashes. While we selected `sentry_flutter` as our crash reporter, we needed to wire it into critical app infrastructure (auth, downloads, offline sync, payments, startup, and background workers) without tightly coupling our domain packages (e.g., `testpress`, `courses`) to a specific third-party dependency. 

## Decision
We introduced a `SentryService` wrapper strictly inside the `core` package (`packages/core/lib/data/services/sentry_service.dart`). 

Key architectural decisions include:
1. **Abstraction over Types**: We introduced an `AppErrorLevel` enum and a `createNavigatorObserver()` factory in `core` so that domain packages can log errors and track navigation without importing `sentry_flutter`.
2. **Dependency Inversion in Network Utils**: The global `network_utils.dart` handler exposes an `onNetworkErrorCapture` callback, which `SentryService` attaches to during initialization. This keeps the network layer pure.
3. **Isolate Initialization**: Because Dart isolates do not share static memory, `SentryService` is explicitly instantiated and initialized within the `Workmanager` background isolate (`offline_exam_sync_worker.dart`) to ensure offline crashes are captured successfully.
4. **App-Lifetime Scope**: `sentryServiceProvider` is annotated with `@Riverpod(keepAlive: true)` to ensure global listeners (like syncing the user context via `userProvider`) remain active for the duration of the application.

## Consequences
- **Positive**: Domain packages can log errors and track routing without any direct dependency on Sentry.
- **Positive**: Network exceptions and background isolate crashes are reliably reported.
- **Positive**: If we migrate away from Sentry to another crash reporter (e.g., Firebase Crashlytics), we only need to modify `SentryService` inside `core`.
- **Tradeoff**: Background isolate execution incurs a minor latency penalty to initialize the crash reporter locally upon startup.
