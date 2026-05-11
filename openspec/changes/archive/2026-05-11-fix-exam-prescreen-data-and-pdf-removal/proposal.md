## Why

Exams fail to display metadata (questions count, marks, duration) on first load when accessing them via content details, because the JSON parser depends on an optional top-level `content_type` key to recognize the lesson as an exam and extract its slug. Additionally, the "Download PDF" option is no longer required in the exam prescreen widget.

## What Changes

- **Modified**: Enhance `LessonDto._identifyLessonType` to identify exam content if the `exam` map exists.
- **Modified**: Enhance `LessonDto._parseBase` to fallback to `exam?['duration']` for better metadata population.
- **Modified**: Remove the redundant "Download PDF" row from the `ExamPrescreen` UI.
- **Added**: Introduce `Skeletonizer` support in `ExamPrescreen` to display aesthetic loading states while metadata fetches.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `lesson-exam-metadata`: Formalize that the JSON parser MUST extract slug even without explicit top-level `content_type` by checking the presence of nested maps.

## Impact

- `LessonDto` in `packages/core`
- `ExamPrescreen` in `packages/exams`
