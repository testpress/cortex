## 1. Localizations & AI Tab Adaptations

- [x] 1.1 Add PDF AI greeting string (`pdfAiGreeting`) to `packages/core/lib/l10n/` ARB files and run l10n generation if needed.
- [x] 1.2 Update `AITab` in `packages/courses/lib/widgets/lesson_detail/ai_tab.dart` to use `pdfAiGreeting` when `lesson.type == LessonType.pdf`.

## 2. PDF AI Bottom Sheet

- [x] 2.1 Implement `PdfAiBottomSheet` in `packages/courses/lib/widgets/lesson_detail/pdf_ai_bottom_sheet.dart` with drag handle, title, close button, keyboard inset management, and embedded `AITab`.
- [x] 2.2 Integrate `PdfAiBottomSheet` with `AppBottomSheet` container in `LessonDetailOrchestrator`.

## 3. PDF Viewer Integration in Lesson Detail Orchestrator

- [x] 3.1 Calculate AI availability in `LessonDetailOrchestrator` for PDF lessons based on `isAiEnabled`, `canEnableLearnlensAi`, and `learnlensAssetStatus == 'completed'`.
- [x] 3.2 Implement `PdfActionsFab` supporting a unified circular sparkles FAB with an expandable action menu (Ask AI (PDF) + Ask Doubt) and close toggle state.
- [x] 3.3 Connect the AI action to present `PdfAiBottomSheet` via `AppBottomSheet` and the doubt action to doubt creation.

## 4. Testing & Verification

- [x] 4.1 Add unit/widget tests for `PdfAiBottomSheet` verifying proper presentation and dismissal.
- [x] 4.2 Add widget tests for `PdfActionsFab` and `LessonDetailOrchestrator` verifying single FAB menu expansion, action dispatch, and direct triggers.
- [x] 4.3 Run `flutter test` across `packages/courses` and `packages/core` to ensure zero regressions.

