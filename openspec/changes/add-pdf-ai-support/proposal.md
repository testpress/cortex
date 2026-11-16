## Why

Currently, students viewing PDF lessons in Cortex have no contextual AI support, unlike video lessons which provide an AI Tutor tab powered by LearnLens. The Testpress backend already prepares LearnLens assets for PDF materials and exposes AI status flags (`is_ai_enabled`, `can_enable_learnlens_ai`, `learnlens_asset_id`, `learnlens_asset_status`) and session endpoints. Providing AI interaction within PDF lessons enables students to query document concepts and receive instant explanations without leaving the PDF reading flow.

## What Changes

- Add a dedicated AI Assistant action/button in the PDF lesson view when `lesson.isAiEnabled`, `lesson.canEnableLearnlensAi`, and `lesson.learnlensAssetStatus == 'completed'`.
- Introduce a modal bottom sheet container (`PdfAiBottomSheet`) hosting the existing LearnLens AI chat component (`AITab`) scoped to the PDF's content session and asset ID.
- Wire the PDF viewer orchestrator to trigger the AI Assistant bottom sheet and handle seamless chat interaction alongside document viewing.

## Capabilities

### New Capabilities
- `pdf-ai-chat`: Modal bottom sheet and controller hosting contextual AI chat for PDF lessons using LearnLens session and asset scoping.

### Modified Capabilities
- `lesson-pdf-playback`: Conditionally display the AI Assistant entry point in PDF lessons when LearnLens AI prerequisites are fulfilled.

## Impact

- `packages/courses`: `LessonDetailOrchestrator`, `AppPdfViewer` / `_PdfLessonViewer`, and new `PdfAiBottomSheet` widget.
- Reuses existing `AITab` and `LearnLensRepository` without duplicate networking or session logic.

