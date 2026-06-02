## Why
Users need a quick and accessible way to ask questions or clarify doubts while studying course materials. Adding a dedicated floating button directly on the lesson detail pages ensures help is just one tap away, improving the learning experience.

## What Changes
- Add a floating action button (FAB) labeled "Ask Doubt" on specific lesson detail screens (`pdf`, `notes`, `embedContent`, `liveStream`, `attachment`).
- The button will be styled with a pill-shaped background using the primary color and the `LucideIcons.messageCircleQuestionMark` icon.
- Tapping the button will navigate the user to the `/home/discussions/doubts` route.

## Capabilities

### New Capabilities
- `ask-doubt-fab`: Ability to trigger doubt creation directly from lesson detail screens via a floating action button.

### Modified Capabilities

## Impact
- **UI/UX**: Modifies the `LessonDetailOrchestrator` to display an overlay FAB for specific lesson types.
- **Navigation**: Adds a shortcut to the existing doubts screen. No new APIs or backend dependencies are introduced.
