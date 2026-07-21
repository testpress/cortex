## Why

We need robust global error tracking and crash reporting to monitor application stability in production, particularly for background operations (like offline syncing) and network layer failures. The current architecture lacked a centralized, decoupled mechanism for capturing these errors consistently without hardcoding dependencies across multiple packages.

## What Changes

- Add `sentry_flutter` to track exceptions, breadcrumbs, and crashes.
- Introduce an encapsulated `SentryService` inside the `core` package, ensuring the underlying SDK is abstracted away from other domain packages.
- Hook into the global network request handler (`network_utils.dart`) to automatically capture unhandled API errors.
- Ensure `Sentry` is correctly initialized in the Workmanager background isolate so that offline sync crashes are captured.
- Refactor existing packages (like `testpress`) to use decoupled `AppErrorLevel` enums and `NavigatorObserver` factories instead of depending directly on `sentry_flutter`.

## Capabilities

### New Capabilities
- `error-tracking`: Centralized crash reporting and exception capturing across main and background isolates.

## Impact

- **Affected Code:** `packages/core/lib/data/services/sentry_service.dart`, `packages/core/lib/network/network_utils.dart`, background workers, and initialization logic.
- **Dependencies:** Adds `sentry_flutter` strictly to `core`. Removes it from `testpress`.
- **Systems:** Global network calls, offline background sync isolate.
