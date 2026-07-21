## 1. Build Pipeline Updates

- [x] 1.1 Update `app/scripts/run_client.dart` to fetch `primary_color` and append it to `--dart-define`
- [x] 1.2 Update `app/scripts/generate_client_app.dart` to fetch `primary_color` and append it to `--dart-define`

## 2. Design System Injection

- [x] 2.1 Add robust `_parseColor` helper to `packages/core/lib/design/design_config.dart`
- [x] 2.2 Add `_darken` helper to `packages/core/lib/design/design_config.dart`
- [x] 2.3 Refactor `DesignColors.light()` to compute dynamic colors and bypass `DesignColors.smart()`
- [x] 2.4 Refactor `DesignColors.dark()` to compute dynamic colors and bypass `DesignColors.smart()`

## 3. Testing

- [x] 3.1 Expose `parseColor`, `lighten`, and `darken` using `@visibleForTesting`
- [x] 3.2 Create `packages/core/test/design/design_config_test.dart` to test color parsing and blending math
