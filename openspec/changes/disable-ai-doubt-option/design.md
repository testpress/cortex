## Context

In Cortex, Helpdesk doubts allow students to choose between sending doubts to AI or to a human mentor when submitting queries via `AskDoubtFormScreen`. For clients such as Brilliant Pala who are releasing a dedicated full-featured AI conversational assistant powered by LearnLens, offering AI answers inside the helpdesk form causes redundant interactions and confusion.

Cortex employs compile-time configuration JSONs (`config/<tenant>.json`) populated via `--dart-define-from-file`, with bindings centralized in `AppConfig` within `packages/core`.

## Goals / Non-Goals

**Goals:**
- Provide a clean compile-time toggle (`ENABLE_AI_DOUBT`) that defaults to `true` across the application.
- Disable AI doubt mode for Brilliant Pala by setting `"ENABLE_AI_DOUBT": false` in `config/elearn_brilliantpala.json`.
- In `AskDoubtFormScreen`, automatically submit directly to `DoubtQueryType.mentor` when `!AppConfig.enableAiDoubt`, omitting the `_SubmitOptionsSheet` modal entirely.
- In `DoubtsListScreen`, omit the "AI" filter chip when `!AppConfig.enableAiDoubt` so students only see valid query type filters ("All", "Mentor").
- In `DoubtDetailScreen`, disable/hide the follow-up reply composer on doubts of type `DoubtQueryType.ai` (when AI doubts are disabled).

**Non-Goals:**
- Altering the backend API schema or database models for doubts (the helpdesk API still supports `query_type: 1` and `query_type: 2`).
- Disabling the new dedicated AI chat feature (LearnLens / `AiScreen`) or video-based AI features.
- Modifying how existing AI doubts (if already in database) are rendered in historical lists.

## Decisions

### Decision 1: Compile-time config vs runtime InstituteSettings
- **Choice**: Use a compile-time `--dart-define` flag (`AppConfig.enableAiDoubt`) populated from `config/elearn_brilliantpala.json`.
- **Rationale**: Follows the existing architecture for white-label/tenant UI feature toggles (`SHOW_EXAM_TAB`, `SHOW_PROFILE_TAB`, `SHOW_CERTIFICATE`). This avoids adding new non-standard backend fields unless the API server explicitly provides tenant settings for helpdesk AI.
- **Alternative considered**: Tenant detection via `AppConfig.apiBaseUrl.contains('brilliant')`. A compile-time boolean is cleaner, declarative, and easily reusable by any other institute in the future.

### Decision 2: Submission UX when AI doubt is disabled
- **Choice**: In `AskDoubtFormScreen`, when `!AppConfig.enableAiDoubt`, tapping Submit calls `_submitDoubt(DoubtQueryType.mentor)` immediately without showing `_SubmitOptionsSheet`.
- **Rationale**: When there is only one destination (Mentor), popping up a sheet with a single choice or forcing the user to pick an option is poor UX. Bypassing the sheet creates a direct, seamless submit flow.

### Decision 3: Filter chips in DoubtsListScreen
- **Choice**: Omit the entire filter chip bar when `AppConfig.enableAiDoubt` is `false`.
- **Rationale**: When AI doubts are disabled, all doubts belong to mentors. Displaying filter chips like "All" and "Mentor" is redundant because both filters show identical results. Removing the bar reclaims vertical space and eliminates visual noise.

### Decision 4: Follow-up comment section on AI doubts
- **Choice**: In `DoubtDetailScreen`, suppress `_DoubtReplyComposer` when `doubt.queryType == DoubtQueryType.ai` (when `!AppConfig.enableAiDoubt` or for all AI doubts).
- **Rationale**: Helpdesk AI doubts are one-shot queries and do not support continuous conversational interactions from the bot. Hiding the comment bar prevents user confusion and dead-end submissions, directing students to the dedicated AI chat instead.

## Risks / Trade-offs

- **[Risk] Existing AI doubts in history**: If a student already has doubts submitted as AI doubts, omitting the "AI" chip means they view them under the "All" tab.
  - *Mitigation*: The "All" tab continues to display all doubts regardless of type, and individual doubt cards still render their proper status/author badges.
