## Context

The backend has introduced an `is_public` boolean flag to the forum comments payload to handle comment moderation. Non-public comments shouldn't be fully hidden from the UI but instead flagged as "Pending Moderation" for the user who posted it or for admins.

## Goals / Non-Goals

**Goals:**
- Store and parse the `is_public` field across data, domain, and presentation layers.
- Display a "Pending Moderation" badge appropriately on the UI if `is_public` is false.

**Non-Goals:**
- Allowing users to toggle the public state from the app (this is moderation handled by admins).
- Creating new backend endpoints.

## Decisions

- **Database Change**: Add `BoolColumn get isPublic => boolean().withDefault(const Constant(true))();` to `ForumCommentsTable`. Using a default ensures older cached rows are treated as public.
- **DTO Mapping**: In `ForumCommentDto`, `isPublic` will map to `is_public` with a fallback to `true`.
- **UI Badge**: In `ForumPostDetailScreen`, conditionally render a badge indicating "Pending Moderation" next to the relative timestamp when `isPublic == false`.

## Risks / Trade-offs

- Requires running `build_runner` for Drift database code generation.
- Defaulting to `true` means that if the API fails to send the field, it assumes it's public. This is generally preferred to avoid incorrectly flagging valid comments as pending moderation.
