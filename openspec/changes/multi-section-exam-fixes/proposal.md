## Why

Multi-section exams with sectional locks (`hasSectionalLock == true`) strictly enforce per-section timers on the server. However, the mobile app currently allows learners to manually attempt to advance to the next section (either by tapping inactive section tabs or tapping "Next Section" on the last question of a section), bypassing section lockdown and triggering server rejection errors.

Additionally, in singleSelect and exam questions, once an option is selected, learners cannot deselect it to return the question to an unattempted state, creating penalties in negative-marking competitive exams.

## What Changes

- **Lock Inactive Section Tabs**: Keep inactive section tabs disabled in `SectionsTabBar` when `hasSectionalLock` is true.
- **Disallow Manual Early Section Advancement**: On the last question of a section with an active sectional lock, disable the forward/next transition until the section timer actually completes (`00:00`).
- **Add Clear Response Action**: Provide an explicit "Clear Response" button when an answer is selected, allowing learners to clear their selection and return the question to an unattempted state.

## Capabilities

### Modified Capabilities
- `exam-player-sections`: Disallow manual section switching (via tabs or last question next button) when sectional lock is active, ensuring section transition only occurs upon timer expiration. Provide a clear response action to clear answers on active questions.

## Impact

- `packages/exams/lib/widgets/test_detail/sections_tab_bar.dart`
- `packages/exams/lib/screens/test_detail_screen.dart`
- `packages/exams/lib/widgets/test_detail/test_question_card.dart`
- `packages/exams/lib/widgets/test_detail/test_navigation_actions.dart`
- `packages/core/lib/l10n/` (localization for Clear Response)
