## Context

The app allows users to binge-watch video lessons. Currently, when a video ends, the user must manually click "Next" to navigate to the next lesson. We want to implement an "AutoPlay next session" feature controlled by the `autoPlayNext` user setting.

## Goals / Non-Goals

**Goals:**
- Automatically navigate to the next lesson when a video finishes, if the `autoPlayNext` setting is enabled.
- Always navigate to the next lesson if the current is a video, regardless of the next lesson's type.

**Non-Goals:**
- Automatically navigating when non-video lessons (e.g., articles, exams) are completed.
- Changing the global `autoPlayNext` setting defaults or the UI to toggle it.

## Decisions

- **Triggering AutoPlay**: The video player emits a completion event. The lesson orchestrator will listen to this. Once completed, it reads the `autoPlayNext` setting from `SettingsProvider`. If true, it triggers the same sequential navigation as the "Next" button. We do not need to inspect the next lesson type.

## Risks / Trade-offs

- **[Risk]** None significant, as we are reusing the existing sequential navigation logic that the "Next" button uses.
