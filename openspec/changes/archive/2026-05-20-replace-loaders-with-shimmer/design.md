## Context

The app currently mixes a custom indeterminate spinner (`AppLoadingIndicator`), structural skeletons via `Skeletonizer`, and real progress indicators for downloads. For this change we are only keeping the Study tab course list as a skeleton example because its layout is stable and the loading state benefits from preserving that shape.

## Goals / Non-Goals

**Goals:**
- Keep the Study tab course list as a skeleton placeholder where the final layout is known.
- Preserve `AppLoadingIndicator` for compact indeterminate states, button loading, and short overlays.
- Preserve determinate progress indicators for real percentage-based tasks.
- Avoid expanding shimmer to other screens in this change.
- Keep the migration safe without changing data contracts.

**Non-Goals:**
- Redesigning screen layouts beyond the Study course list loading state.
- Rewriting data providers or backend loading semantics.
- Replacing every loader in the app with shimmer regardless of context.
- Changing download behavior or file-transfer progress reporting.

## Decisions

1. Use the existing `skeletonizer` package as the structural placeholder system.
   - Rationale: it is already present in the repo, supports layout-matching skeletons, and fits the current design system for the Study course list.
   - Alternatives considered:
     - Add the pub.dev `shimmer` package: simpler API, but it would require manual placeholder layout and add another dependency.
     - Build a custom shimmer with `ShaderMask`: maximum control, but more implementation and maintenance cost.

2. Define three loading classes instead of one universal loader.
   - Structural loading: use skeletons when the screen has a known content layout.
   - Indeterminate loading: use `AppLoadingIndicator` for short waits, buttons, and small inline states.
   - Determinate progress: keep `LinearProgressIndicator` or equivalent for percentage-based operations.
   - Rationale: each class communicates different user intent, and mixing them creates confusion.
   - Alternatives considered:
     - Convert every loader to skeletons: not appropriate for actions with no stable final layout.
     - Keep the spinner everywhere: easy, but weakens perceived responsiveness on large screens.

3. Migrate at the screen/component level, not through provider changes.
   - Rationale: skeletons are a presentation concern, and the current state providers already expose loading/empty/error signals. For this change, only the Study course list presentation changes.
   - Alternatives considered:
     - Push skeleton placeholder objects into providers: rejected because it couples UI shape to data sources.

4. Let Skeletonizer derive the Study loading state from the real course card layout.
   - Use the real `CourseCard` structure as the loading source.
   - Use sliver-level skeletonization for the list and pagination loading states.
   - Use annotations like `Skeleton.replace` only where a specific shape needs guidance.
   - Rationale: this stays closer to Skeletonizer's intended workflow and avoids maintaining a separate manual skeleton tree.
   - Alternatives considered:
     - Keep a manual skeleton widget layer: rejected because it duplicates the real layout and increases divergence.

5. Keep motion and accessibility rules unchanged.
   - Skeletons must respect existing motion preferences where animations are involved.
   - Loading UI must not reduce touch targets or remove semantic clarity for controls.
   - Alternatives considered:
     - Add special-case motion behavior for loading states: unnecessary because the existing design system already handles motion gating.

## Risks / Trade-offs

- [Risk] The Study list skeleton can still feel too broad if applied outside its stable list area. → Mitigation: keep the shimmer boundary limited to the course cards.
- [Risk] Other screens may still use spinners, which is acceptable for this narrower change. → Mitigation: leave their current loading patterns untouched.

## Migration Plan

1. Keep the shared loading primitive intact for buttons and inline actions.
2. Keep the Study tab course list skeletonized.
3. Leave all other screens on their existing loading patterns.
4. Verify the Study course list retains stable height and does not shimmer the section header.

## Open Questions

- None for this narrowed scope.
