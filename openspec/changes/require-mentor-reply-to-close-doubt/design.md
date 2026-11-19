## Context

In `packages/discussions/lib/screens/doubt_detail_screen.dart`, students view an active doubt thread and its replies. The screen header currently shows a three-dots menu whenever `doubt.status != DoubtStatus.closed`. Tapping this opens an `AppBottomSheet` containing a single action: "Close doubt".

`DoubtReplyDto` already exposes `isMentor: bool`, which is determined based on the author vs. reporter ID or API payload. Currently, no check is performed on the reply list before allowing the user to open the menu and close the doubt.

## Goals / Non-Goals

**Goals:**
- Restrict the doubt closure action so it is only accessible when the doubt has at least one reply where `isMentor == true`.
- Ensure clean UI behavior when no mentor reply is present (hide or disable the action).
- Add automated widget test coverage verifying the close action visibility based on mentor replies.

**Non-Goals:**
- Modifying backend API endpoints or database schemas (validation is client-side in the discussions UI; backend API endpoints already handle closing).
- Changing mentor reply author resolution logic or AI bot tagging.

## Decisions

### Decision 1: Derive `hasMentorReply` from `repliesAsync`
- In `DoubtDetailScreen`, `repliesAsync` (`ref.watch(doubtRepliesProvider(widget.doubtId))`) is already watched at the root of `build`.
- Check:
  ```dart
  final hasMentorReply = repliesAsync.valueOrNull?.any((r) => r.isMentor) ?? false;
  ```
- Rationale: Since replies are already reactively streamed / cached by Riverpod, this check is instant, declarative, and requires no extra network calls.

### Decision 2: Guard the header action menu and action sheet
- In `AppHeader`, only display the `moreVertical` action if `doubt.status != DoubtStatus.closed && hasMentorReply`.
- In `_buildActionSheet`, also verify `hasMentorReply` before showing/executing the close action as defense-in-depth.
- Rationale: Currently "Close doubt" is the only option in the 3-dots menu. Showing an empty or disabled menu provides unnecessary friction. Hiding the menu until a mentor replies keeps the UI clean and directly fulfills the requirement.

## Risks / Trade-offs

- **[Risk]** If replies are still loading when the screen opens, `repliesAsync.valueOrNull` is null, so `hasMentorReply` is false.
  → **Mitigation**: Once replies load, `repliesAsync` automatically updates the widget via Riverpod and reveals the menu if a mentor reply exists. This is the desired behavior.
