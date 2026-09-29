## Context

Learners frequently adjust video playback speed during study sessions. Although Cortex persists playback speed globally when the "Remember Playback Speed" toggle is active, many learners do not configure this setting in advance. To make speed persistence intuitive and accessible, an in-player banner prompt will appear directly beneath the video player when a learner selects a non-1x speed.

## Goals / Non-Goals

**Goals:**
- Provide a responsive in-player prompt allowing 1-tap activation of global playback speed memory.
- Persist the user's prompt dismissal preference locally via `SharedPreferences`.
- Automatically clear the dismissal state whenever the user explicitly toggles the setting in App Settings.
- Ensure clean separation between player UI and core data providers with full testability.

**Non-Goals:**
- Showing prompts when the user changes speed back to default 1x.

## Decisions

### Decision 1: Preferences-Backed Provider for Prompt Dismissal State
- **Approach:** Implement `PlaybackSpeedPromptDismissed` (`playbackSpeedPromptDismissedProvider`) in `packages/core/lib/data/providers/playback_speed_prompt_provider.dart` using `SharedPreferences`.
- **Rationale:** The prompt dismissal state is a client-side UI flag rather than an account-level setting. Storing it in `SharedPreferences` keeps it lightweight without touching the database schema.

### Decision 2: In-Player Banner Component & Dismissal Flow
- **Approach:** Render a contextual prompt banner in `VideoLessonViewer` when a non-1x speed is selected, `rememberPlaybackSpeed` is disabled, and the prompt has not been dismissed.
- **Rationale:** Keeping the prompt inside the player layout provides high context and instant feedback without interrupting the video stream.

### Decision 3: Atomic Notifier Method for Affirmative Prompt
- **Approach:** Provide `enableRememberPlaybackSpeedAndSave(speed)` on `PlaybackSettingsNotifier` to atomically enable `rememberPlaybackSpeed` and set `globalPlaybackSpeed` in the database in a single operation.

## Risks / Trade-offs

- **[Risk] Prompt display during rapid speed changes** → **Mitigation:** The pending speed state in `VideoLessonViewer` updates dynamically with each speed change so the prompt always reflects the latest selected speed.
