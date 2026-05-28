## Context

The exam player (`TestDetailScreen`) uses `SectionsTabBar` to let the user switch between exam sections or subjects. Currently, the tab bar has two states:

- **Expanded** — a 50 px tall horizontal `ListView` with pills that have a fixed height, a `ShaderMask` right-fade, and a chevron-up collapse button on the right.
- **Collapsed** — a 32 px tall row showing only the active section name with a chevron-down to re-expand.

This two-state collapse/expand pattern adds interaction complexity and visual weight not found anywhere else in the app. The study page's `ChaptersFilterTabBar` (`packages/courses/lib/widgets/chapters_filter_tab_bar.dart`) uses a much simpler, always-visible, horizontally-scrollable pill row that is consistent with the app design system.

## Goals / Non-Goals

**Goals:**
- Match the pill visual style of `ChaptersFilterTabBar` / `_FilterTab` exactly: `surfaceVariant` background for inactive pills, `textPrimary` background for active pills, `card` / `onPrimary` foreground text, `design.radius.pill` rounding, `AppText.label` text style, `AppFocusable` + `AppSemantics.button` wrappers, `AnimatedContainer` for smooth state transitions.
- Remove the collapse/expand toggle — the filter row is always visible.
- Remove the `ShaderMask` and replace with a plain `SingleChildScrollView` (horizontal).
- Remove `isExpanded` / `onExpandChanged` props from `SectionsTabBar` and clean up all call sites in `TestDetailScreen`.
- Container wraps to pill content height rather than a fixed `50 px`.

**Non-Goals:**
- Adding icons to the section pills (the sections/subjects are dynamic strings from the API).
- Changing any data-layer, routing, or business logic.
- Altering the collapsed-state display in any other widget.

## Decisions

### Decision 1: Align pill style with `_FilterTab`, not `ContentTypeFilterChip`

`ChaptersFilterTabBar` uses `_FilterTab` (pill shape, `radius.pill`, no border, two-colour scheme). The study screen also has `ContentTypeFilterChip` (rounded rectangle, border, per-type accent colours). For the exam player the sections/subjects are plain strings with no type-specific colour — `_FilterTab`'s simpler two-colour scheme is the right match.

**Alternative considered**: Reuse `ContentTypeFilterChip` — rejected because it requires per-item colour tokens that don't exist for arbitrary section names.

### Decision 2: No reusable shared component

The restyled `SectionsTabBar` is exam-specific (wraps `ExamAttemptState`, handles section vs. subject logic). Extracting a shared filter pill into `packages/core` is out of scope for this change. The implementation stays inside `packages/exams`.

**Alternative considered**: Extract a generic `FilterPillBar` into `core` — valid future refactor, not needed here.

### Decision 3: Drop collapse/expand entirely

The collapse affordance was added to save vertical space. With the pill row auto-sizing to content height (~40 px), the space saving from collapsing to 32 px is negligible and the toggle adds cognitive load. Removing it simplifies both widget API and parent state.

## Risks / Trade-offs

- **Risk**: Exams with many sections may have the pill row overflow horizontally — **Mitigation**: `SingleChildScrollView` (horizontal) already handles this; same pattern used in `ChaptersFilterTabBar`.
- **Risk**: Removing `isExpanded` / `onExpandChanged` is a breaking prop change for `SectionsTabBar` — **Mitigation**: The widget is private to `packages/exams` and has only one call site (`TestDetailScreen`), so both are updated atomically.

## Migration Plan

1. Update `SectionsTabBar`: remove collapsed branch, remove `isExpanded` / `onExpandChanged` params, restyle pill using `_FilterTab` visual tokens.
2. Update `TestDetailScreen`: remove `_isSectionsTabBarExpanded` state field and the two removed props from `SectionsTabBar(...)`.
3. No database, API, or routing changes required. No feature flags needed.
