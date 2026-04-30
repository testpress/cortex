## 1. UI & Orchestration

- [x] 1.1 Implement `LessonDetailShell` in `core` (consistent Header/Footer)
- [x] 1.2 Create `LessonWebView` with theme injection for Notes/Embeds
- [x] 1.3 Implement `AttachmentViewer` with manual download logic
- [x] 1.4 Implement `LessonDetailOrchestrator` for routing-based switching
- [x] 1.5 Refactor `VideoLessonViewer` and `AppPdfViewer` to work within Orchestrator
- [x] 1.6 Implement `context.pushReplacement` for sequential navigation

## 2. Polish and Verification

- [x] 2.1 Unify DTO and Curriculum identification to prevent "broken types"
- [x] 2.2 Fix auto-download bug by strictly separating renderable PDFs from attachments
- [x] 2.3 Fix duration parsing to handle non-HLS video duration and "0:00:00" cases
- [x] 2.4 Ensure reactivity between detail saving and chapter list via StreamGroup.merge