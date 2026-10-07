## Why

The current search bar primitive across the application (most notably on the Study screen and store/discussions search inputs) lacks a clear (`x`) button. When learners type a query to search for courses, lessons, or topics, they have to repeatedly press the backspace key to clear their query and restore unfiltered results. Adding a dedicated clear button directly into the `AppSearchBar` primitive will streamline navigation, improve UX efficiency, and maintain consistent accessibility standards across all app screens.

## What Changes

- Update the core `AppSearchBar` primitive to support a dynamic trailing clear icon button (`LucideIcons.x`).
- Automatically toggle clear button visibility based on text content (hidden when empty, visible when non-empty).
- Clear the input text, invoke `onChanged('')`, and trigger an optional `onClear` callback upon tapping the clear button.
- Ensure the clear button complies with WCAG accessibility guidelines by providing a 48dp touch width (`minWidth: 48`) and accessible semantics (`AppSemantics.button` with `excludeFromSemantics: true` on the inner gesture).
- Provide localized accessibility labels (`commonClearSearchSemantic`) with support for custom overrides via `clearSemanticLabel`.
- Manage internal and external controller lifecycles cleanly without memory leaks during widget updates.

## Capabilities

### New Capabilities
- `search-bar-clear-action`: Automatic trailing clear button integration with touch target handling, accessible screen reader announcements, and search reset callbacks in `AppSearchBar`.

### Modified Capabilities
- `core-primitives`: Enhances `AppSearchBar` with clear button support, localized semantic strings, and controller lifecycle safety.

## Impact

- `packages/core`: `AppSearchBar` widget, localization ARBs (`app_en.arb`, `app_ta.arb`, `app_ml.arb`, `app_ar.arb`), generated localizations, and unit/widget test suite.
- `packages/courses`: `StudyScreen` and `StorePage` automatically gain clear button functionality.
- `packages/discussions`: Discussion search inputs automatically gain clear button functionality.
- `packages/exams`: Exam search inputs automatically gain clear button functionality.
