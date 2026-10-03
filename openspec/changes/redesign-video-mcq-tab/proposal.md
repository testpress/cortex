# Proposal

## Why

The previous Video MCQ tab used an unpolished card layout on a grey background, evaluated answers immediately upon tapping without confirmation, and lacked clear progress tracking and direct question navigation.

Redesigning the MCQ tab modernizes the interface, introduces a staged "Check Answer" evaluation flow for better active recall, enhances progress visibility, and provides a quick-access question palette.

## What Changes

- **Layout & Visual Hierarchy**:
  - Unify the quiz screen, opening/initial card (`VideoMcqInitialCard`), and generating/loading state with a clean white background (`card`), eliminating grey card boxing.
  - Confine the subtle grey container background (`surface`) strictly to the docked bottom button container.
- **Header & Progress**: Introduce a streamlined `"Practice Test"` header with a question count pill badge, progress counter (`"Question X of Y"` / `"N answered"`), and an interactive progress bar.
- **Staged Answer Evaluation**:
  - Tapping an option highlights it with a radio indicator without revealing correctness.
  - A prominent **Check Answer** button confirms selection, displays status (correct/incorrect), and reveals the explanation card.
- **Navigation & Question Palette**:
  - Replace chevron icon buttons with prominent **Previous** and **Next** action buttons.
  - Add a **View All Questions** trigger opening a bottom sheet palette (`"Hey! Review Your Answers"`) for grid-based question navigation and review.

## Capabilities

### Modified Capabilities
- `video-ai-mcq`: Updated UI specifications for quiz header, linear progress bar, staged selection with Check Answer evaluation, full-width navigation buttons, and the question palette bottom sheet.

## Impact

- **Affected Packages**: `packages/courses` (`video_mcq_tab.dart`, `mcq/video_mcq_stepper_card.dart`, `mcq/video_mcq_palette_sheet.dart`, `mcq/video_mcq_initial_card.dart`, `video_lesson_viewer.dart`), `packages/core` (localization strings).
- **APIs**: No backend schema changes; evaluation remains client-side with cached quiz DTOs.
