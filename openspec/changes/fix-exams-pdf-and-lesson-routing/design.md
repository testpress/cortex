## Context

Exams courses often contain mixed curriculum types, including PDFs, videos, and notes. Currently, these non-exam items (like PDF lessons) fail to open when browsed under the Exams tab (`/exams`). This is because:
1. The `ExamsRoutes` GoRouter configuration lacks a `lesson/:id` subroute definition.
2. The `onLessonClick` handler in the `ChapterDetailPage` route only supports `LessonType.test` and `LessonType.assessment`, returning `null` (doing nothing) for all other types.

## Goals / Non-Goals

**Goals:**
- Enable full-screen viewing of PDF, video, and notes lessons inside the Exams tab navigation context (`/exams/lesson/:id`).
- Ensure that clicking "Back" from a lesson detail screen inside the Exams tab returns the user to the Exams chapter/detail stack.
- Redirect exam-type lessons (tests/assessments) accessed via `/exams/lesson/:id` to their corresponding `/exams/test/:id` or `/exams/assessment/:id` routes.

**Non-Goals:**
- Changing navigation paths or behavior under the Study tab (`/study`).
- Modifying UI components like `LessonDetailOrchestrator` or `ChapterDetailPage`.

## Decisions

### 1. Register `/exams/lesson/:id` Route under `ExamsRoutes`
We will define a new route `GoRoute(path: 'lesson/:id', parentNavigatorKey: rootNavigatorKey)` under the `/exams` base route. This will wrap the builder with a `Consumer` to fetch `lessonDetailProvider(id)` and return `LessonDetailOrchestrator`.

### 2. Implement `_ExamLessonRedirector`
Similarly to `_LessonRedirector` in `study_routes.dart`, we will implement a private `_ExamLessonRedirector` widget. It will monitor the resolved lesson's type and redirect to `/exams/test/${lesson.id}` or `/exams/assessment/${lesson.id}` if they are loaded under `/exams/lesson/:id`.

### 3. Update `onLessonClick` Fallback
In `ExamsRoutes.routes`, update the click handler on `ChapterDetailPage` to fall back to `/exams/lesson/${lesson.id}` for any non-exam content types.

## Risks / Trade-offs

- **Risk**: Redundant redirector code between `study_routes.dart` and `exams_routes.dart`.
  - **Mitigation**: While some logic is duplicated, it keeps the two navigation stacks independent and ensures proper, clean tab-specific routing without tight cross-tab coupling.
