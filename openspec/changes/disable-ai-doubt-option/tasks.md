## 1. Configuration & Core Flag

- [x] 1.1 Add `"ENABLE_AI_DOUBT": false` to `config/elearn_brilliantpala.json`.
- [x] 1.2 Define `static const bool enableAiDoubt` in `packages/core/lib/data/config/app_config.dart` with `defaultValue: true`.

## 2. Discussions UI Updates

- [x] 2.1 Update `AskDoubtFormScreen` in `packages/discussions/lib/screens/ask_doubt_form_screen.dart` to submit directly to `DoubtQueryType.mentor` when `!AppConfig.enableAiDoubt`, bypassing `_SubmitOptionsSheet`.
- [x] 2.2 Update `DoubtsListScreen` in `packages/discussions/lib/screens/doubts_list_screen.dart` to hide the filter chips bar completely when `AppConfig.enableAiDoubt` is false.
- [x] 2.3 Update `DoubtsListScreen` to ignore `widget.initialFilter` and reset `doubtTypeFilterProvider` to `null` when `!AppConfig.enableAiDoubt`.
- [x] 2.4 In `AskDoubtFormScreen`, gate `isAskAi` behind `AppConfig.enableAiDoubt`, ensuring submission defaults to mentor when disabled.

## 3. Verification & Testing

- [x] 3.1 Add/update unit and widget tests in `packages/discussions/test/` to verify submission direct routing and filter chip bar hiding based on `enableAiDoubt`.
- [x] 3.2 Add widget test verifying that `initialFilter` is ignored and `doubtTypeFilterProvider` is reset to `null` when `enableAiDoubt` is false.
- [x] 3.3 Run package tests in `packages/discussions` and `packages/core` to ensure no regressions.
- [x] 3.4 Add test verifying that when `enableAiDoubt` is false, `isAskAi: true` routes directly to `DoubtQueryType.mentor`.



