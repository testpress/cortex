## Context

In `packages/discussions/lib/screens/doubt_detail_screen.dart`, students view an active doubt thread and its replies. The screen header currently shows a three-dots menu whenever `doubt.status != DoubtStatus.closed`. Tapping this opens an `AppBottomSheet` containing a single action: "Close doubt".

`DoubtReplyDto` already exposes `isMentor: bool`, which is determined based on the author vs. reporter ID or API payload. Currently, no check is performed on the reply list before allowing the user to open the menu and close the doubt.

## Goals / Non-Goals

**Goals:**
- Restrict the doubt closure action so it is only accessible when the doubt has at least one reply where `isMentor == true`.
- Ensure clean UI behavior when no mentor reply is present (hide the action menu).
- Expose the rule as a testable pure static method `canCloseDoubt` and add automated unit and widget test coverage.

**Non-Goals:**
- Server-side / backend enforcement: Modifying backend API endpoints or server validation. This restriction is enforced strictly on the client side (UI) within the app.
- Changing mentor reply author resolution logic or AI bot tagging.

## Decisions

### Decision 1: Expose `canCloseDoubt` and derive `canClose` via Riverpod selector
- Expose the evaluation rule as a pure, static `@visibleForTesting` method `canCloseDoubt` on `DoubtDetailScreen`.
- In `DoubtDetailScreen.build`, derive `canClose` using Riverpod's `.select()` over `doubtRepliesProvider`.
- Rationale: Isolating the rule into a static method keeps business logic decoupled and directly testable without pumping widgets. Using `.select()` ensures `build()` remains pure with zero mutable state, and only rebuilds when the boolean value transitions.

### Decision 2: Guard the header action menu and action sheet
- In `AppHeader`, only display the `moreVertical` action if the doubt is not closed and `canClose` is true.
- In `_buildActionSheet`, call `_closeMenu()` to dismiss the sheet first, and verify `canClose` before confirmation dialog dispatch.
- Rationale: Dismissing the sheet first avoids leaving it stuck open if the state transitions while open. Hiding the menu until a mentor replies keeps the UI clean and directly fulfills the requirement.

## Risks / Trade-offs

- **[Risk]** Client-only enforcement: This restriction is client-side only by design. If a user bypasses the app and calls the backend API endpoint (`POST /api/v3/helpdesk/<pk>/followup/` with `should_close: true`) directly, the backend will still process the close request unless backend-level validation is added on the server.
  → **Mitigation**: Documented as client-side only by design for this mobile app scope. Full enforcement requires a corresponding validation on the backend service.
- **[Risk]** Initial loading and stream re-sync states:
  → **Mitigation**: On initial load, `async.valueOrNull` is null, so `canClose` evaluates to false until the initial replies arrive. During subsequent background re-syncs, Riverpod preserves the previous value on `AsyncValue`, and `.select()` avoids rebuilding unless the boolean transitions, preventing UI flicker.
