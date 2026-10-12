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
- **Rationale:** Keeps presentational curriculum widgets decoupled from routing, while ensuring `ProductDetailScreen` routes through `LessonRouter` so that `lessonDetailProvider` fetches the complete lesson content. Passing `isPreview: true` injects `preview=true` into route query parameters, allowing `study_routes` to nullify `onNext` and `onPrevious` to prevent users from advancing into un-enrolled lessons or triggering auto-play trap.

### Decision 2: Dual Badge Rendering in `StoreContentTile`
- **Choice:** Conditionally render either:
  - Free Preview: `design.colors.success` / primary tint with `LucideIcons.playCircle` and action label "Free Preview", invoking `onPreviewTap`.
  - Locked Content: Accent2 tint with `LucideIcons.lock` and label "Buy to Unlock", invoking `onBuyTap`.
- **Rationale:** Visual clarity for prospective buyers, directly indicating that this item is playable immediately without payment.

### Decision 3: Fallback Logic for Preview Determination in `LessonDto`
- **Choice:** Define preview availability using `hasFreePreview || !isLocked`.
- **Rationale:** Handles both older curriculum payloads (where previewable lessons are returned with `is_locked: false`) and modern payloads with an explicit `has_free_preview` field.

### Decision 4: Inversion of Control via Capability Props on `LessonDetailOrchestrator`
- **Choice:** Add optional capability flags to `LessonDetailOrchestrator` (`enableBookmarks`, `enableCompletion`, `enableDownloads`, `enableHelpdesk`, all defaulting to `true`).
- **Rationale:** Keeps `LessonDetailOrchestrator` presentational and decoupled from business rules or "preview" concepts, mirroring `LessonDetailShell`. In `study_routes.dart`, when `preview=true` is present, pass `false` for these flags to hide student-only actions.

## Risks / Trade-offs

- **[Risk]** Deep navigation stack when exiting preview back to store:
  - *Mitigation:* Push `LessonDetailOrchestrator` on top of the current route; normal pop returns user seamlessly to their position in the store curriculum.
- **[Risk]** Small touch targets on inline badges:
  - *Mitigation:* Ensure badge container or surrounding tap target complies with `kMinTouchTargetSize` (48dp) and semantics labeling includes action hints.
