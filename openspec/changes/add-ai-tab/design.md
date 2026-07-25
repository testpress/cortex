## Context

The app currently lacks a dedicated space for AI-assisted learning. Users typically ask doubts through the `AskDoubtFormScreen`. We want to introduce a top-level AI tab in the navigation bar to bring AI capabilities to the forefront.

## Goals / Non-Goals

**Goals:**
- Add an AI tab to the main bottom navigation bar.
- Introduce `AiScreen` for the new tab.
- Allow `AskDoubtFormScreen` to be used in "Ask AI" mode, sending doubts to the AI service rather than the traditional forum.

**Non-Goals:**
- Changes to the backend AI logic or existing AI models.
- Modifications to the existing forum submission flow (except for adding the new AI option).

## Decisions

- **Navigation**: Update `AppRouter` and `NavTab` to include `ai` as a new destination, controlled by `AppConfig.showAiTab`.
- **UI Adjustments**: Introduce a `backgroundColor` parameter in `AppHeader` to give AI-related screens a distinct look. Update `AskDoubtFormScreen` to have an `isAskAi` boolean flag, adapting its submission flow to use `DoubtQueryType.ai`.

## Risks / Trade-offs

- [Risk] AI tab visibility logic may conflict with existing user settings. -> Ensure `AppConfig.showAiTab` integrates cleanly with existing feature flags.
