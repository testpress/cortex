## Context

Currently in the Store tab, non-enrolled users browsing a course's curriculum see all contents in `StoreContentTile` labeled unconditionally as "Buy to Unlock". In Testpress API, sample/preview lessons provide unlock flags (`is_locked: false` or preview metadata). Users should be able to identify and play free preview lessons directly from the curriculum view.

## Goals / Non-Goals

**Goals:**
- Detect free preview eligibility from `LessonDto` (`!isLocked` or `hasFreePreview == true`).
- Display distinct "Free Preview" badge styling with play/unlock cues and accessible touch targets.
- Propagate `onPreviewTap` callback up through `StoreContentTile` -> `StoreChapterTile` -> `ProductExpandableCourseCard` to `ProductDetailScreen`.
- Navigate to `LessonDetailOrchestrator` with the selected preview `LessonDto`.
- Ensure full accessibility (WCAG touch targets >= 48dp and descriptive semantic announcements).

**Non-Goals:**
- Modifying playback capabilities or DRM handling within `LessonDetailOrchestrator`.
- Offline downloading or persistent caching of preview contents.
- Changing the checkout or plan selection bottom sheet flows for locked items.

## Decisions

### Decision 1: Explicit Callback Plumbing and Router Navigation
- **Choice:** Thread `onPreviewTap(LessonDto lesson)` through widget constructors (`StoreContentTile`, `StoreChapterTile`, `ProductExpandableCourseCard`) up to `ProductDetailScreen`, then navigate using `LessonRouter.navigateToLesson(..., isPreview: true)`.
- **Rationale:** Keeps presentational curriculum widgets decoupled from routing, while ensuring `ProductDetailScreen` routes through `LessonRouter` so that `lessonDetailProvider` fetches the complete lesson content. Passing `isPreview: true` injects `preview=true` into route query parameters, allowing `study_routes` (combined with `activeLesson.isFreePreview`) to nullify `onNext`, `onPrevious`, and student capabilities, preventing users from advancing into un-enrolled lessons while ensuring non-preview lessons never silently lose actions if deep-linked.

### Decision 2: Dual Badge Rendering in `StoreContentTile`
- **Choice:** Conditionally render either:
  - Free Preview: `design.colors.success` / primary tint with `LucideIcons.playCircle` and action label "Free Preview", invoking `onPreviewTap`.
  - Locked Content: Accent2 tint with `LucideIcons.lock` and label "Buy to Unlock", invoking `onBuyTap`.
- **Rationale:** Visual clarity for prospective buyers, directly indicating that this item is playable immediately without payment.

### Decision 3: Single Preview Property in `LessonDto`
- **Choice:** Define preview availability using a single field `isFreePreview` on `LessonDto` (parsing backend `free_preview` / `has_free_preview`).
- **Rationale:** Avoids redundant `hasFreePreview` vs `isFreePreview` dual naming, aligning with other boolean fields in `LessonDto` (`isLocked`, `isRunning`, `isUpcoming`, `isScheduled`).

### Decision 4: Inversion of Control via Capability Props on `LessonDetailOrchestrator`
- **Choice:** Add optional capability flags to `LessonDetailOrchestrator` (`enableBookmarks`, `enableCompletion`, `enableDownloads`, `enableHelpdesk`, all defaulting to `true`).
- **Rationale:** Keeps `LessonDetailOrchestrator` presentational and decoupled from business rules or "preview" concepts, mirroring `LessonDetailShell`. In `study_routes.dart`, when `preview=true` is present, pass `false` for these flags to hide student-only actions.

### Decision 5: Bypassing Lock Evaluation for Free Previews in `LessonDetailOrchestrator`
- **Choice:** Resolve locked state in `LessonDetailOrchestrator` as `final isLocked = lesson.isLocked && !lesson.isFreePreview;`.
- **Rationale:** For unpurchased courses, the backend curriculum API populates `locked_contents` with all un-enrolled lesson IDs. If a lesson also has `free_preview: true`, evaluating `isLocked` blindly causes the orchestrator to render the sequential lock screen ("Access Denied: Complete previous content to unlock") instead of playing the preview content.

### Decision 6: Architectural Scope Boundary of Preview UI Restrictions
- **Choice:** Preview mode UI capability restrictions are enforced on lesson routes handled by `LessonDetailOrchestrator` (`video`, `pdf`, `notes`, `attachment`, `embedContent`, `liveStream`, `assignment`). Exam content types (`test`, `assessment`) route to `ExamPrescreen` and defer attempt authorization to the backend exam attempt API (which returns 403 for un-enrolled users).
- **Rationale:** Exams have independent lifecycle engines that lack lesson-level actions (bookmarks, mark-as-completed, sequential next/previous).

### Decision 7: Preserving Preview Flag Across Detail Loading and Merging
- **Choice:** Maintain `isFreePreview` in `LessonDto.mergeWith` using `isDetailFetched ? isFreePreview : (isFreePreview || other.isFreePreview)` and carry forward `extraLesson.isFreePreview` in `study_routes.dart` when `lessonDetailProvider` resolves.
- **Rationale:** Detail fetch responses with `isDetailFetched: true` act as the authoritative source of truth (honoring administrative revocations where `free_preview: false`), while summary and cached curriculum merges retain preview eligibility via the OR fallback.

## Risks / Trade-offs

- **[Risk]** Deep navigation stack when exiting preview back to store:
  - *Mitigation:* Push `LessonDetailOrchestrator` on top of the current route; normal pop returns user seamlessly to their position in the store curriculum.
- **[Risk]** Small touch targets on inline badges:
  - *Mitigation:* Ensure badge container or surrounding tap target complies with `kMinTouchTargetSize` (48dp) and semantics labeling includes action hints.
