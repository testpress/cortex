## Why

To support the full exam attendance flow, we need a complete pre-exam experience. This includes showing the user's past attempts, exam details/metadata, standard/MathJax instructions, and routing with dynamic state and arguments between course lessons and the exam player.

## What Changes

- Add `examAttemptsProvider` inside `packages/exams/lib/providers/exam_providers.dart`.
- Create `ExamPrescreen` at `packages/exams/lib/screens/exam_prescreen.dart` to display attempts history, duration, question count, and retake/start CTAs.
- Export the new screen in `packages/exams/lib/exams.dart`.
- Wire routes and state mappings inside `packages/testpress/lib/navigation/app_router.dart`.

## Capabilities

### New Capabilities
- `exam-attendance-flow`: Provides a pre-exam attendance flow including overview panels, previous attempt tables, instructions presentation, and unified routing.

### Modified Capabilities

## Impact

- Upgraded the `/study/test/:id` and `/exams/test/:id` routes in the routing shell to launch overview boards first and delegate player loading to nested `/player` child paths.
