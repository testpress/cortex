## Why

Users need a dedicated space to interact with AI features for their learning and doubts. Introducing an AI tab provides a centralized, easily accessible interface for AI-driven assistance across the app.

## What Changes

- Add a new "AI" tab to the main bottom navigation bar.
- Introduce `AiScreen` as the root screen for the new AI tab.
- Modify the existing `AskDoubtFormScreen` to support an "Ask AI" mode, bypassing the standard doubt submission flow in favor of AI processing.
- Update `AppHeader` to support customized background colors for better visual distinction in AI modes.

## Capabilities

### New Capabilities
- `ai-tab`: Introduces a dedicated AI tab in the main navigation shell.
- `ai-doubt-mode`: Enables asking doubts directly to AI via the doubt form screen.

### Modified Capabilities
- `navigation`: Adding the new AI tab to the app router and bottom navigation.

## Impact

- **App Router**: New tab added to `NavTab` and `GoRouter` configuration.
- **Doubt Form**: `AskDoubtFormScreen` now accepts `isAskAi` flag.
- **UI Components**: `AppHeader` modified to accept `backgroundColor`.
