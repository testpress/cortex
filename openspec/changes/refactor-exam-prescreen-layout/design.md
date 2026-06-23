## Context

The exam prescreen UI was implemented with brittle nested `LayoutBuilder` wrappers and complex internal state tracking for layout sizes. This caused layout conflicts when keyboard popped up or on smaller devices. Further, the skeleton loading implementation used hardcoded configs and dummy data with an incorrect length (like `--` for marks), forcing `Skeletonizer` to compute inappropriately tiny bones. Finally, the GoRouter routes for exams lacked `parentNavigatorKey: rootNavigatorKey`, resulting in immersive experiences being improperly nested within the bottom navigation shell when launched from dashboard cards.

On the backend, the API has introduced updated schemas (`v2.3`/`v2.4`) for `ExamDto`, `ReviewDto`, and `AttemptDto` featuring improved fields and proper HATEOAS references. The frontend was accumulating technical debt by parsing multiple legacy fields explicitly (e.g. `['date'] ?? ['started_on'] ?? ['date_created']`) and firing duplicate network calls.

## Goals / Non-Goals

**Goals:**
- Eliminate `LayoutBuilder` constraint fighting.
- Extract monolithic UI into dedicated, testable components.
- Fix all skeletonizer rendering issues and theme inheritance.
- Ensure the route is universally immersive across the app.
- Bump and conform to the latest API specs (`v2.4`) to resolve tech debt in `http_data_source.dart`.
- Address V3 API structural changes and isolate section-level timers from legacy heartbeat syncing.
- Safeguard local review state tracking against asynchronous network submissions.

**Non-Goals:**
- We are not changing the exam player (taking the test) behavior itself.
- We are not redesigning the data structure of the Dashboard.

## Decisions

1. **Routing Strategy**: 
   Replace `CustomTransitionPage` overlay hacks with standard `builder` routes, using `parentNavigatorKey: rootNavigatorKey`. This natively enforces full-screen rendering without complex transparent overlays that break lifecycle events.

2. **UI Component Breakdown**: 
   Extract static top statistics into `ExamPrescreenTopStat`, and the massive timeline metadata into `ExamPrescreenTimeline`. By pulling out "Quiz vs Regular mode" selection into an `AppBottomSheet`, we dramatically simplify the scrolling body tree.

3. **Skeleton Loading Mechanism**:
   Rather than overriding `SkeletonizerConfig` locally (which broke theme awareness), we inherit the global app configuration. For sizes to compute correctly, we provide realistic proxy data (e.g., `'120'`, `'+1.0 Marks'`) to strings when `isMetadataLoading` is true.

4. **API Versioning & Debouncing**:
   The `http_data_source.dart` is upgraded directly to `v2.4`. Debouncing logic is explicitly centralized to mitigate redundant calls to HATEOAS endpoints, ensuring attempts and reviews are efficiently cached.

5. **Heartbeat Syncing Independence**:
   Legacy heartbeat APIs return `0:00:00` for V3 exams. We completely detached local timer syncing from the periodic heartbeat, letting section boundaries dictate exam flow rather than falling back to invalid server times.

6. **Asynchronous State Persistence**:
   During `submitAnswer` cycles, the local `review` and `result` flags are strictly carried over when generating the new `AnswerDto`. This ensures "Mark for Review" status isn't cleared when progressing between questions.

## Risks / Trade-offs

- [Risk] Moving the layout from nested constraints to `SingleChildScrollView` might disrupt deeply nested list views on extremely tall devices.
  - *Mitigation*: We ensure the bottom action area ("Start Exam") is passed into the `LessonDetailShell(bottomBar: ...)` to keep it sticky.
- [Risk] API Bump causes deserialization failures on outdated courses.
  - *Mitigation*: We maintain backward compatibility fallbacks inside `ExamDto.fromJson` for legacy schemas.
