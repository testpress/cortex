## 1. Dependency Configurations

- [x] 1.1 Constrain `sqlite3` and restore `sqlite3_flutter_libs` dependencies in `packages/core/pubspec.yaml`
- [x] 1.2 Add conditional exclude rule for `sqlite3-native-library` in `app/android/app/build.gradle.kts`

## 2. UI Integration & Sentry Reporting

- [x] 2.1 Implement Zoom meeting launch inside `video_conference_viewer.dart`
- [x] 2.2 Add try-catch block to report Zoom auth/init failures via `sentryServiceProvider`

## 3. Verification

- [x] 3.1 Verify compile-time and runtime compatibility in both Zoom-enabled and Zoom-disabled builds
