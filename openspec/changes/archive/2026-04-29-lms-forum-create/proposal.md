## Why

Currently, the LMS Forum only supports viewing existing threads and replying to them. To enable active students' engagement and peer-to-peer interaction, users need the ability to start new discussion threads directly from the mobile application. This completes the core forum loop (List -> Read -> Reply -> Create).

## What Changes

- The system SHALL implement a high-fidelity screen for composing new forum posts based on the design reference.
- The system SHALL integrate the custom Trix-aligned rich text editor for post descriptions.
- The system SHALL support picking and UI-only attachment of up to 3 images per post.
- The system SHALL handle the "Post" action by showing a success state or popping the screen.
- The UI SHALL enable the "Create New Post" button in the Forum Main list page.
- The system SHALL model and retrieve categories using generic payload identifiers.
- The UI SHALL follow localized hints and labels for all input fields.
- The composer SHALL support standard rich text formatting operations (Bold, List, Code).

## Capabilities

### New Capabilities
- `forum-create-ui`: Defines the UI and UX requirements for composing new threads, including field validation, rich text editing interaction, and image attachment preview.

### Modified Capabilities
- (None)

## Impact

- **`packages/forum`**: `ForumPostCreateScreen` is added and shared editor components are refactored for cross-screen reuse.
- **`L10n`**: New strings for labels, hints, and UI messages.
