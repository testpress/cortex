## 1. LessonDto Enhancements

- [x] 1.1 Modify `LessonDto._identifyLessonType` in `packages/core` to check if `json['exam'] != null`.
- [x] 1.2 Modify `LessonDto._parseBase` in `packages/core` to fallback to `exam?['duration']`.

## 2. Prescreen UI Cleanup

- [x] 2.1 Remove the "Download PDF" GestureDetector block from `ExamPrescreen` in `packages/exams`.

## 3. High-Fidelity Loading State

- [x] 3.1 Add `skeletonizer: ^2.1.3` dependency to `packages/exams/pubspec.yaml`.
- [x] 3.2 Integrate `Skeletonizer` wrap around ExamPrescreen metadata section driven by `examDetailAsync.isLoading`.
- [x] 3.3 Verify loading state and parsing final result.
