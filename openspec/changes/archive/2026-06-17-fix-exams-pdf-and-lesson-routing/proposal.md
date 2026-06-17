## Why

Exams courses often contain mixed curriculum types, including PDFs, videos, and notes. Currently, these non-exam items (like PDF lessons) fail to open when browsed under the Exams tab, because the GoRouter Exams configuration lacks a lesson subroute, and the click handler inside `ExamsRoutes` ignores non-exam lesson types.

## What Changes

- **Exams Subroutes**: Register `lesson/:id` under `/exams` routes inside `ExamsRoutes` in `packages/testpress/lib/navigation/routes/exams_routes.dart`.
- **Lesson Redirection**: Support redirecting non-exam lessons (like PDF/video lessons) under the `/exams` branch to a dedicated root-navigator screen (`/exams/lesson/:id`) and render them in `LessonDetailOrchestrator`.
- **Click Handler Update**: Modify `onLessonClick` inside the chapters view in `ExamsRoutes` to fall back to `/exams/lesson/${lesson.id}` for any non-exam lesson types.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `lms-navigation-shell`: Register the lesson subroute under the exams stack to support general content detail viewing.

## Impact

- `packages/testpress/lib/navigation/routes/exams_routes.dart`: Add `lesson/:id` GoRoute and update click redirection.
