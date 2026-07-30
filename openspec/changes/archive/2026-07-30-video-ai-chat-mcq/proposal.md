## Why

We need to provide an interactive and engaging learning experience inside video lessons by integrating the LearnLens AI. This allows students to ask conceptual questions about the video they are watching and practice with automatically generated multiple-choice questions, all without leaving the video player context.

## What Changes

- Update `LessonDto` and `LessonsTable` database schema to parse and persist LearnLens AI flags: `is_ai_enabled`, `can_enable_learnlens_ai`, `learnlens_asset_id`, and `learnlens_asset_status`.
- Add DTO models (`LearnLensChatResponseDto`, `LearnLensQuizResponseDto`) to `packages/core` to parse LearnLens API payloads.
- Add API handling for AI session creation (`/ai-sessions/create/`) when loading AI-enabled video lessons.
- Create `LearnLensNetworkClient` and `LearnLensRepository` to handle AI chat and quiz API calls using the `X-Session-Token`.
- Ensure the AI features are only rendered if the lesson API flags indicate `is_ai_enabled: true`, `can_enable_learnlens_ai: true`, and `learnlens_asset_status == "Completed"`.
- Integrate the LearnLens Chat API in the existing AI tab to let users ask video-specific questions and receive timestamped answers.
- Add a new "MCQ" subtab inside the video lesson view that fetches and renders AI-generated questions interactively.

## Capabilities

### New Capabilities
- `video-ai-chat`: LearnLens AI Chat integration inside the video player AI tab to process user queries.
- `video-ai-mcq`: A new MCQ subtab in the video player that fetches and renders AI-generated questions using the LearnLens Quiz API.

### Modified Capabilities
- `video-lesson-viewer`: Modified to parse LearnLens metadata, orchestrate AI session creation, and manage the visibility of AI-related tabs based on API flags.

## Impact

- `packages/core`: Add `LearnLensChatResponseDto` & `LearnLensQuizResponseDto` to `models/learnlens_dto.dart`, update `LessonDto` and `LessonsTable` to store LearnLens metadata, and update `ApiEndpoints`.
- `packages/courses`: `LearnLensNetworkClient`, `LearnLensRepository`, `learnlens_provider.dart`, `VideoLessonDetailScreen`, `AITab`, and new `VideoMcqTab`.
