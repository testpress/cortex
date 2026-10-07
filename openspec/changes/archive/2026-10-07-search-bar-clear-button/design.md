## Context

`AppSearchBar` is a platform-neutral core primitive used across the Cortex SDK to allow users to filter courses, lessons, store products, and discussions. Currently, `AppSearchBar` only contains a leading search icon and a text field. Users searching for content on screens such as the Study tab must manually delete characters one-by-one to clear their active query.

## Goals / Non-Goals

**Goals:**
- Provide a trailing `x` clear button that appears only when the search field contains text.
- Immediately clear text, reset search queries, and notify listeners (`onChanged('')`, `onClear()`) upon tapping.
- Maintain the sleek, compact visual height of the search bar without layout jumping by locking `height: 48`.
- Provide a comfortable 48×48dp touch target (`BoxConstraints(minWidth: 48, minHeight: 48)`) aligned flush with the trailing edge.
- Ensure full screen reader accessibility via `AppSemantics.button` and multi-language localizations.
- Prevent memory leaks and duplicate listeners during controller swaps in `didUpdateWidget`.

**Non-Goals:**
- Modifying screen-level debounce strategies or remote API schemas.
- Adding custom speech-to-text or voice search to `AppSearchBar`.

## Decisions

### 1. Statefulness & Controller Lifecycle Management
- **Decision**: Convert `AppSearchBar` to a `StatefulWidget` that seamlessly supports either an externally provided `TextEditingController` or an internally managed controller fallback.
- **Rationale**: In `didUpdateWidget`, if the parent swaps from an internal controller to an external controller, the internal controller will be cleanly removed, disposed, and set to `null` to avoid memory leaks.

### 2. Touch Target & Layout Preservation
- **Decision**: Constrain the clear button's touch target to `minWidth: 48, minHeight: 48` and set `height: 48` on `AppSearchBar`.
- **Rationale**: Locks the search bar to a standard 48dp height to eliminate visual jumps when typing, while meeting WCAG 2.5.5 minimum 48×48dp touch target guidelines.

### 3. Accessibility & Localization
- **Decision**: Wrap the clear button in `AppSemantics.button` with `label: clearSemanticLabel ?? l10n.commonClearSearchSemantic`, and apply `excludeFromSemantics: true` to the inner `GestureDetector`.
- **Rationale**: Prevents duplicate tap actions from being announced by screen readers while delivering localized descriptions in English, Tamil, Malayalam, and Arabic.

## Risks / Trade-offs

- [Risk: Focus loss on clear] → Tapping controls can sometimes cause unfocusing on some platforms.
  *Mitigation*: Use an opaque non-focusable `GestureDetector` that does not request separate focus, keeping cursor and keyboard open for uninterrupted typing.
