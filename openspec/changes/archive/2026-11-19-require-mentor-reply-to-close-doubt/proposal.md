## Why

Currently, students can mark a doubt as closed/resolved immediately after creating it, even before receiving a response from a mentor. To ensure doubts receive proper academic attention and prevent accidental or premature closure before mentor resolution, students should only be allowed to close a doubt after at least one mentor has replied.

## What Changes

- Condition the ability to close/resolve a doubt in `DoubtDetailScreen` on the presence of at least one mentor reply (`reply.isMentor == true`).
- When no mentor reply exists:
  - Prevent user access to the "Close doubt" action.
  - The menu action is either hidden or inaccessible when no mentor has replied to the doubt.
- When at least one mentor has replied:
  - The close doubt action remains accessible as usual with confirmation.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `doubt-thread-detail`: Restrict the Mark Resolved / Close Doubt action so it is only available when at least one mentor reply exists in the thread.

## Impact

- **Affected Code**: `packages/discussions/lib/screens/doubt_detail_screen.dart` and its related tests.
- **Affected Packages**: `packages/discussions`
- **APIs**: Client-side only by design. No backend schema or API changes made; relies on existing `isMentor` flag on `DoubtReplyDto`. Server-side validation is deferred to backend service if needed.
