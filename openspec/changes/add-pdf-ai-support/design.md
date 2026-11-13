## Context

In Cortex, video lessons provide an interactive AI study companion powered by LearnLens via `AITab`. PDF lessons, however, only offer static document viewing via `AppPdfViewer` and an optional Helpdesk ticket button (`AskDoubtFab`).

The Testpress backend (`testpress_python`) and Cortex data layer already treat `ChapterContent` AI attributes uniformly:
- `is_ai_enabled`
- `can_enable_learnlens_ai`
- `learnlens_asset_id`
- `learnlens_asset_status`

The backend provides the exact same session endpoint `POST /api/v3/contents/{content_id}/learnlens-session/` for PDF chapter contents as for video contents. This design introduces contextual AI assistance into PDF lessons by presenting a bottom-sheet chat interface backed by the existing `AITab` and `LearnLensRepository`.

## Goals / Non-Goals

**Goals:**
- Provide a trigger button in PDF lessons when `lesson.isAiEnabled && lesson.canEnableLearnlensAi && lesson.learnlensAssetStatus == 'completed'`.
- Present a modal bottom sheet (`PdfAiBottomSheet`) hosting `AITab` scoped to the PDF lesson without interrupting the user's PDF reading position.
- Adapt the AI greeting for document context when launched from a PDF lesson.
- Ensure proper keyboard handling, safe areas, and theming consistent with Cortex design tokens.

**Non-Goals:**
- In-document highlight / text-selection AI popups.
- AI MCQ tab for PDFs (reserved for a separate enhancement).
- Changing backend session acquisition or `LearnLensRepository` logic.

## Decisions

### 1. Reusing `AITab` via `PdfAiBottomSheet`
- *Decision*: Host `AITab(lesson: lesson)` inside a specialized modal bottom sheet rather than building a separate chat widget.
- *Rationale*: Avoids code duplication for message bubbles, error retry, markdown parsing, and LearnLens API session coordination.
- *Alternatives considered*: Embedding tabs directly under or beside the PDF viewer. Rejected because PDF viewing requires maximum screen real estate on mobile devices.

### 2. Trigger FAB Placement in `LessonDetailOrchestrator`
- *Decision*: Provide a single circular primary FAB (with `LucideIcons.sparkles`) floating on the PDF viewer.
  - When both AI and Ask Doubt are active: Tapping toggles an actions popup card containing "Ask AI (PDF)" and "Ask Doubt", switching the FAB icon to a close (X) icon.
  - When only AI is active: Tapping directly opens `PdfAiBottomSheet`.
  - When only Ask Doubt is active: Shows the standard `AskDoubtFab`.
- *Rationale*: Eliminates visual clutter by consolidating multiple floating buttons into a single interaction point, preserving document reading area on mobile.

### 3. Contextual Greeting for PDF Lessons
- *Decision*: Check `widget.lesson.type` in `AITab` when displaying the initial welcome message: if `LessonType.pdf`, display `pdfAiGreeting` (or generic study assistant greeting) instead of referencing a "lecture".
- *Rationale*: Prevents confusion when students read documents rather than watching lectures.

## Risks / Trade-offs

- **Keyboard obscuring input field**: When typing in a modal bottom sheet, the software keyboard can obscure the composer.
  - *Mitigation*: Use `resizeToAvoidBottomInset: true` or wrap in `Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))` inside `AppBottomSheet`.
- **Pre-existing session token invalidation**: If token expires during document reading.
  - *Mitigation*: Handled automatically by `LearnLensSessionManager` 401 retry interceptor in `packages/core`.

