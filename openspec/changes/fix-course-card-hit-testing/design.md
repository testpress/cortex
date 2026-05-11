## Context

The `AppFocusable` utility widget provides keyboard navigation support and accessible focus state wrappers for UI elements. It internally uses a `GestureDetector` to handle touch taps for the associated `onTap` callback.

Users have reported that `CourseCard` (which consumes `AppFocusable`) is only interactive when tapping specific rigid child components (text, icons, images) and fails to detect taps in empty space or padding areas between them.

## Goals / Non-Goals

**Goals:**
- Ensure `AppFocusable` components respond to tap gestures anywhere within their complete rendered boundaries.
- Avoid regression in child interactivity (prevent hijacking existing interactive nested children if any).

**Non-Goals:**
- Refactoring the entire hit testing approach for the framework.
- Modifying specific margin/padding layout behaviors.

## Decisions

### 1. Update AppFocusable GestureDetector HitTestBehavior
We will modify the `GestureDetector` inside `AppFocusable` to use `behavior: HitTestBehavior.opaque`.

**Rationale:**
The default `deferToChild` behavior of `GestureDetector` requires a child render object to explicitly declare a hit. Depending on theme configurations or container composition, background decorations might not be correctly recognized as opaque hits by Flutter's hit-tester. Explicitly setting `HitTestBehavior.opaque` guarantees the entire bounding box of the `GestureDetector` intercepts hit tests, resolving the dead-zone issue.

**Alternatives Considered:**
- Pass `onTap` explicitly to `AppCard` inside `CourseCard`: Dismissed because `AppCard` is just one consumer; we want *all* focusable components (buttons, chips, list items) to have robust hit testing.

## Risks / Trade-offs

- **[Risk]** Over-broad hit areas covering siblings → Mitigation: `AppFocusable` size follows its child bounding box identically, so it won't overlap neighbors inappropriately.
