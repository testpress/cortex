## 1. Data Models & Schema Persistence

- [x] 1.1 Update `LessonDto` in `packages/core/lib/data/models/lesson_dto.dart` to parse `can_enable_learnlens_ai`, `learnlens_asset_id`, and `learnlens_asset_status`.
- [x] 1.2 Update `LessonsTable` in `packages/core/lib/data/db/tables/lessons_table.dart` to persist the new LearnLens fields in Drift DB.
- [x] 1.3 Create `LearnLensChatResponseDto` and `LearnLensQuizResponseDto` in `packages/core/lib/data/models/learnlens_dto.dart` and export them via `data.dart`.

## 2. Network Client & Session Management

- [x] 2.1 Add endpoints (`createAiSession`, `learnLensChat`, `learnLensQuiz`) to `ApiEndpoints` in `packages/core`.
- [x] 2.2 Refactor `LearnLensNetworkClient` to consume `ApiEndpoints`, use non-nullable `userId`, and return typed `Dto` models.
- [x] 2.3 Refactor `LearnLensRepository` to aggregate `LearnLensNetworkClient` and `DataSource`, exposing typed methods with `difficulty` and `questionCount` parameters.
- [x] 2.4 Update `learnlensSessionProvider` in `packages/courses/lib/providers/learnlens_provider.dart` to enforce non-nullable user authentication.

## 3. UI Structure & Tab Orchestration

- [x] 3.1 Update `VideoLessonViewer` to evaluate `is_ai_enabled`, `can_enable_learnlens_ai`, and `learnlens_asset_status == "Completed"`.
- [x] 3.2 Add conditionally rendered tabs for AI Chat and AI MCQ in the video subtabs view.
- [x] 3.3 Update `AITab` widget to fetch session token via `learnlensSessionProvider` and use `LearnLensRepository`.

## 4. LearnLens Chat Integration

- [x] 4.1 Connect `AITab` text input to `LearnLensRepository.submitChat`.
- [x] 4.2 Render markdown responses returned by the Chat API in the chat UI.
- [x] 4.3 Implement custom HTML tag parsing for `<span class="video-timestamp">` tags to make them clickable and seek the video player.

## 5. LearnLens MCQ Integration

- [x] 5.1 Create `VideoMcqTab` widget in `packages/courses/lib/widgets/lesson_detail/`.
- [x] 5.2 Trigger `LearnLensRepository.fetchQuiz` on tab initialization with difficulty and count parameters.
- [x] 5.3 Render interactive questions, options, hints, and explanations.
- [x] 5.4 Display an appropriate "No questions generated" empty state when the API returns an empty list.

## 6. Verification & Sync

- [x] 6.1 Run `dart analyze` across the monorepo to ensure zero lint errors.
- [x] 6.2 Run `build_runner` to sync generated Drift database and Riverpod provider code.
