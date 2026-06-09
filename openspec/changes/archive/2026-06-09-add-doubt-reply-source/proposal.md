## Why

To clearly distinguish between human responses and automated AI responses in doubt threads. This gives users immediate context on the origin of the answer, improving trust and setting appropriate expectations for the reply.

## What Changes

- Add a new `source` text field to `DoubtRepliesTable` to store the API response source (e.g. "Bot" or "Human").
- Update the API parsing logic to extract the `source` field.
- **UI Modification**: If `source` is "Bot" (or AI equivalent), force the display name to "AI Bot Response".
- **UI Modification**: If `source` is "Bot" and `isMentor` is true, display the mentor label as "Bot".

## Capabilities

### New Capabilities
<!-- Leave empty as we are modifying existing capabilities -->

### Modified Capabilities
- `doubts-core`: Update data models and parsers to handle the new `source` attribute from the helpdesk endpoint.
- `doubt-thread-detail`: Update the reply card UI to conditionally render the "AI Bot Response" name and "Bot" badge based on the source field.

## Impact

- Database schema update for `DoubtRepliesTable` (requires Drift migration/generation).
- API parser for Doubt Replies.
- UI components displaying doubt reply author details.
