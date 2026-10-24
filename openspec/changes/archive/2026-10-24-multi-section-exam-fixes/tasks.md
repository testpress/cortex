## 1. Live Exam Section Tab Lockdown

- [x] 1.1 Update `SectionsTabBar` to support disabled tab interaction when sections are locked
- [x] 1.2 Disallow switching inactive section tabs in `TestDetailScreen` when `attempt.hasSectionalLock == true`
- [x] 1.3 Add test coverage verifying inactive section tabs are non-interactive during sectional locks

## 2. Preemptive Section Ending Configuration

- [x] 2.1 Add `allowPreemptiveSectionEnding` to `ExamDto` (defaulting to `false`) and parse `allow_preemptive_section_ending` from JSON
- [x] 2.2 Wire `allowPreemptiveSectionEnding` in `TestDetailScreen` so that forward advancement and final submission are blocked only when `allowPreemptiveSectionEnding == false`
- [x] 2.3 Verify with unit and widget tests that `ExamDto` parses the flag and `TestDetailScreen` enables/disables navigation accordingly

## 3. Clear Question Response Action

- [x] 3.1 Add localization strings for "Clear Response" in `core/lib/l10n` arb files
- [x] 3.2 Add `onClearResponse` and `hasAnswer` to `TestNavigationActions` and `TestQuestionCard` with a dedicated "Clear Response" button
- [x] 3.3 Wire `onClearResponse` in `TestDetailScreen` to clear selected options and persist empty answers to repository
- [x] 3.4 Add unit/widget tests verifying "Clear Response" appears when answered, clears selection on tap, and updates state
