## Why

For clients like Brilliant Pala releasing with the dedicated AI chat feature, having the older "Ask AI" mode within the Helpdesk doubt workflow creates feature redundancy and user confusion. The application must support conditionally disabling the AI doubt option and its associated filter chip for designated clients while routing submitted doubts directly to mentors, and disabling the comment/reply composer on AI doubts.

## What Changes

- Add a build configuration toggle `ENABLE_AI_DOUBT` (defaulting to `true` in `AppConfig`, and set to `false` for `elearn_brilliantpala.json`).
- When `ENABLE_AI_DOUBT` is false:
  - In `AskDoubtFormScreen`, bypass the "Ask AI vs Ask Mentor" submission bottom sheet when the student taps Next/Submit and route the doubt directly to `DoubtQueryType.mentor`.
  - In `DoubtsListScreen`, hide the doubts type filter chips bar.
- In `DoubtDetailScreen`, disable/hide the follow-up reply composer when viewing doubts of type `DoubtQueryType.ai` (or when AI doubts are disabled).

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `doubts-compose-ui`: Conditionally bypass the submit options sheet and submit directly as a mentor doubt when AI doubt is disabled.
- `doubts-filter-ui`: Conditionally hide the doubts type filter chips bar when AI doubts are disabled.
- `doubt-reply-interaction`: Disable the reply composer for AI doubts.

## Impact

- `config/elearn_brilliantpala.json`: Add `"ENABLE_AI_DOUBT": false`.
- `packages/core/lib/data/config/app_config.dart`: Add `AppConfig.enableAiDoubt` boolean flag.
- `packages/discussions/lib/screens/ask_doubt_form_screen.dart`: Update submit handler to bypass `_SubmitOptionsSheet` when `!AppConfig.enableAiDoubt`.
- `packages/discussions/lib/screens/doubts_list_screen.dart`: Update `doubtFilterOptions` to conditionally omit `DoubtQueryType.ai` when `!AppConfig.enableAiDoubt`.
- `packages/discussions/lib/screens/doubt_detail_screen.dart`: Hide reply composer on AI doubts.
- Tests in `packages/discussions/test/` to verify conditional submission routing, filter chip visibility, and reply composer suppression.
