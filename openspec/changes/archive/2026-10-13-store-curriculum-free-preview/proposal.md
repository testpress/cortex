## Why

Potential learners browsing courses in the Store cannot preview sample lessons prior to purchase because store curriculum content tiles unconditionally render a "Buy to Unlock" badge. Introducing a Free Preview capability allows prospective buyers to experience course content first-hand, directly increasing user confidence and conversion rates.

## What Changes

- Distinguish locked vs. free preview lessons in the Store curriculum view based on content lock status (`is_locked: false` / `has_free_preview`).
- Introduce a "Free Preview" badge (with interactive styling and touch target) in `StoreContentTile` for accessible preview lessons, while retaining "Buy to Unlock" for locked lessons.
- Route preview taps from curriculum components (`StoreContentTile` -> `StoreChapterTile` -> `ProductExpandableCourseCard` -> `ProductDetailScreen`) to launch the lesson viewer orchestrator (`LessonDetailOrchestrator`).
- Provide localized strings and accessible semantics for preview actions.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `store-curriculum`: Update curriculum content display requirements to support free preview badges and launching lesson preview viewers for non-enrolled users alongside locked content tiles.

## Impact

- `packages/courses`: `StoreContentTile`, `StoreChapterTile`, `ProductExpandableCourseCard`, `ProductDetailScreen`, and `LessonDto` / curriculum parsing.
- `packages/core`: Localization strings for free preview.
