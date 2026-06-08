## 1. Setup Configuration Strategy

- [x] 1.1 Create `config/` directory at the root of the workspace.
- [x] 1.2 Create `brilliant.json` containing the specific feature toggles required for the Brilliant client.
- [x] 1.3 Move any required client branding assets (like logos) from package assets directly into the `app/` shell's `pubspec.yaml`.

## 2. Refactor Configuration Models

- [x] 2.1 Delete `ClientConfig` models and DTOs completely.
- [x] 2.2 Delete `clientConfigProvider` from Riverpod state.
- [x] 2.3 Refactor `AppConfig` to contain static `const bool.fromEnvironment` and `const String.fromEnvironment` properties with default fallbacks for all feature toggles.

## 3. UI and Logic Updates

- [x] 3.1 Refactor all UI screens (`paid_active_home_screen`, `study_screen`, `chapters_list_page`, `bookmarks_screen`) to statically reference `AppConfig` instead of the Riverpod provider.
- [x] 3.2 Update `ChaptersFilterRules` to rely on the static `AppConfig`.
- [x] 3.3 Update unit tests to conditionally `skip` based on the compiled `AppConfig` state.

## 4. Verification

- [x] 4.1 Verify `dart analyze` passes with zero issues.
- [x] 4.2 Verify all test suites (`core`, `courses`, `testpress`) successfully pass or correctly skip tests based on the default configuration.
- [x] 4.3 Verify the app builds and successfully injects configuration when running `flutter run --dart-define-from-file=../config/brilliant.json` from the `app/` directory.
