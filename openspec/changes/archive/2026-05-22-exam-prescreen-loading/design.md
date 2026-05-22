## Context

Currently, when entering the exam pre-screen, we show a shimmer skeleton only for the question count, duration, and marks. While the metadata is still loading in the background, the user can still click the "Start Exam Online" button. This can cause issues or errors because the actual exam details have not finished loading yet.

## Goals / Non-Goals

**Goals:**
- Provide a unified, high-fidelity loading skeleton where the title, metadata, and "Start Exam Online" action button shimmer together in a cohesive experience.
- Block premature interaction on the "Start Exam Online" button by checking the loading state in its tap handler.
- Eliminate layout jumps by keeping the exact same widget layout structure during both loading and loaded states.

**Non-Goals:**
- Modifying Riverpod providers or repository loading flows.

## Decisions

### 1. Unified Skeletonizer Wrap
Instead of selectively enabling `Skeletonizer` only on the metadata row, we will wrap the entire `Column` inside the main options padding with a `Skeletonizer` widget, controlled by `isMetadataLoading`.

**Rationale**:
- **Aesthetic Premium Experience**: Shimmering the entire card—including the action button and the title—looks incredibly polished and is the standard UX pattern in the rest of the application (e.g., lesson card lists).
- **Zero Layout Shift**: Because the exact same widgets are rendered in both loading and loaded states, there is absolutely zero layout shift when the metadata is fetched.

### 2. Block Tap Interactions via loading guard
In the `GestureDetector` for the "Start Exam Online" button, we will check `isMetadataLoading`. If it is true, the tap handler will exit early (or do nothing), preventing the user from launching the exam attempt prematurely.

```dart
onTap: () async {
  if (isMetadataLoading) return;
  ref.read(examAttemptProvider.notifier).reset();
  await widget.onStartAttempt();
},
```

### 3. Lesson Skeleton Subtitle Integration
To ensure the lesson list shimmer cards under the Video/Lesson filters perfectly mirror loaded layout heights and look as high-fidelity as the chapter cards under the 'All' filter, we will add a non-null, non-empty placeholder string for the `chapterTitle` property of `LessonDto` inside `_skeletonLessons` definition.

### 4. Hide Duration in Filtered Views
In `LessonListItem`, we will completely hide the duration caption widget. This keeps the design aligned with a clean visual layout and prevents showing duration beneath the chapter subtitle line in filtered views, keeping both loaded and skeleton states uniform.




## Risks / Trade-offs

### Risk: Accidental Clicks on Shimmering State
- **Risk**: A user might click the shimmering button and expect something to happen, but nothing does because the interaction is blocked.
- **Mitigation**: The shimmering aesthetic clearly signals to the user that the content is in a loading state, which is standard across iOS and Android apps.
