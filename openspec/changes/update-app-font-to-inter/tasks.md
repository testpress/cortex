# Tasks

## 1. Core Typography Update

- [x] 1.1 Update `DesignTypographyScale.defaults()` in `packages/core/lib/design/design_config.dart` to use `GoogleFonts.inter` and verify analyzer passes
- [x] 1.2 Update `ThemeData.fontFamily` in `app/lib/main.dart` to `GoogleFonts.inter().fontFamily` and verify analyzer passes

## 2. Verification

- [x] 2.1 Run unit tests in `packages/core` to verify typography scale construction and token integrity (`flutter test packages/core`)
- [x] 2.2 Verify app compiles cleanly without layout regressions
