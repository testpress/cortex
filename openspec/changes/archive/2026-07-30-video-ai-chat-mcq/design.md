## Context

We need to provide an interactive learning experience inside video lessons by integrating LearnLens AI Chat and MCQ generation. This requires authenticating via an AI session endpoint, maintaining session token state, and communicating with LearnLens APIs using an `X-Session-Token`. The video player UI needs to display new AI-related tabs conditionally, based on API flags indicating that AI processing for the asset is complete.

## Goals / Non-Goals

**Goals:**
- Extend `LessonDto` and `LessonsTable` to parse and persist `is_ai_enabled`, `can_enable_learnlens_ai`, `learnlens_asset_id`, and `learnlens_asset_status`.
- Implement clean DTO models (`LearnLensChatResponseDto`, `LearnLensQuizResponseDto`) in `packages/core`.
- Implement state management to create and persist an AI session token across the lifecycle of a single video lesson.
- Build a dedicated network client (`LearnLensNetworkClient`) and repository (`LearnLensRepository`) that handles LearnLens HTTP requests with `X-Session-Token` and `learner_id`.
- Extend the `VideoLessonDetailScreen` to conditionally render the AI Chat and MCQ subtabs depending on `is_ai_enabled: true`, `can_enable_learnlens_ai: true`, and `learnlens_asset_status == "Completed"`.
- Parse HTML `video-timestamp` tags from the Chat API to allow users to seek to specific points in the video.
- Build `VideoMcqTab` to display generated MCQs interactively with hints and explanations.

**Non-Goals:**
- Caching AI chat history locally (it relies on server-provided state or remains ephemeral).
- Supporting AI features on non-video lesson types in this change.
- Fixing backend LearnLens algorithms (e.g., handling server-side generation delays).

## Architecture & Data Flow

```
[Video Lesson Detail API Response]
           │
           ▼
     [LessonDto] ──(persisted)──► [LessonsTable (Drift DB)]
           │
  (Checks flags: is_ai_enabled, can_enable_learnlens_ai, status == 'Completed')
           │
           ▼
[VideoLessonDetailScreen]
           │
           ├──► [aiSessionProvider] ──(POST /ai-sessions/create/)──► [Testpress API]
           │                                                                 │
           │                                                           (Session Token)
           │                                                                 │
           ├──► [AITab] ─────────┐                                           │
           │                     ├──► [LearnLensRepository] ◄────────────────┘
           └──► [VideoMcqTab] ───┘           │
                                             ▼
                                 [LearnLensNetworkClient]
                                             │ (X-Session-Token, learner_id)
                                             ▼
                                    [LearnLens Backend]
```

## Decisions

- **Data Models**: Place LearnLens DTOs (`LearnLensChatResponseDto`, `LearnLensQuizResponseDto`) in `packages/core/lib/data/models/learnlens_dto.dart` so they are accessible across all packages.
- **Database Persistence**: Extend `LessonsTable` to persist LearnLens asset ID and status flags so offline/cached lessons retain AI visibility logic.
- **Session Management**: Use Riverpod (`learnlensSessionProvider`) to handle session creation. It manages `session_token` and `expiresAt` state.
- **LearnLens Networking**: `LearnLensRepository` aggregates `LearnLensNetworkClient` (for specialized AI endpoints) and `DataSource` (for session creation).
- **UI Architecture**: Add `VideoMcqTab` widget in `packages/courses/lib/widgets/lesson_detail/` alongside `AITab`.

## Risks / Trade-offs

- **Risk:** Session expiry mid-playback.
  - **Mitigation:** Check `expiresAt` timestamp before making requests to LearnLens. If expired, trigger a re-authentication to fetch a new token.
- **Risk:** The Quiz API returns an empty array for some videos.
  - **Mitigation:** The UI for `VideoMcqTab` handles empty states gracefully with a visual placeholder.
