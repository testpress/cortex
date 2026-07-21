## 1. Setup & Dependencies

- [x] 1.1 Add `sentry_flutter` dependency to `packages/core/pubspec.yaml`
- [x] 1.2 Remove `sentry_flutter` from `packages/testpress/pubspec.yaml`
- [x] 1.3 Add Kotlin compatibility workaround in `app/android/build.gradle.kts` for sentry_flutter plugin

## 2. Core Implementation

- [x] 2.1 Implement `SentryService` wrapper in `packages/core/lib/data/services/sentry_service.dart`
- [x] 2.2 Create `AppErrorLevel` enum to abstract `SentryLevel`
- [x] 2.3 Expose `createNavigatorObserver()` in `SentryService`

## 3. Network & Background Handlers

- [x] 3.1 Hook `onNetworkErrorCapture` into `network_utils.dart`'s `DioException` and general exception catches
- [x] 3.2 Inject and initialize `SentryService` directly within the `callbackDispatcher` of `offline_exam_sync_worker.dart`

## 4. Refactoring Usages

- [x] 4.1 Update `testpress` initialization to use `AppErrorLevel.fatal`/`AppErrorLevel.warning`
- [x] 4.2 Update `testpress` `app_router.dart` to use `SentryService.createNavigatorObserver()`
- [x] 4.3 Replace any remaining references to `SentryLevel` in `core` background services with `AppErrorLevel`
