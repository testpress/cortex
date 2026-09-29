## Why

Learners often prefer watching video lessons at custom speeds (e.g. 1.25x, 1.5x, 2x). While the app provides a global "Remember Playback Speed" setting in App Settings, discovering and navigating to the settings screen introduces friction. Presenting a contextual, non-intrusive prompt directly in the video player when a learner changes speed allows them to immediately persist their preferred speed across all future videos with a single tap.

## What Changes

- Introduce a contextual in-player banner prompt when the user changes playback speed to any non-1x speed while global speed persistence is disabled.
- Allow learners to confirm the prompt ("Yes") to immediately enable "Remember Playback Speed" globally and save their chosen speed.
- Allow learners to dismiss the prompt ("No"), persisting the dismissal preference so they are not prompted again.
- Introduce a dedicated `PlaybackSpeedPromptDismissed` provider in core to manage local prompt dismissal state via `SharedPreferences`.
- Automatically reset the prompt dismissal state if the user manually toggles "Remember Playback Speed" in App Settings.
- Standardize speed multiplier copy across all supported locales (en, ar, ml, ta) to uppercase `X` (e.g. `Playing at {speed}X`, `Remember {speed}X for future videos?`).

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `video-playback-speed`: Add requirements for the contextual in-player prompt when adjusting playback speed, user actions (accept/dismiss), and standardize restored notification copy to uppercase `X`.
- `app-settings`: Extend the "Learning and Playback Preferences" requirement to document that "Remember Playback Speed" can be enabled both via App Settings and the contextual in-player video prompt.

## Impact

- `packages/core/lib/data/providers/playback_speed_prompt_provider.dart`: New Riverpod provider managing prompt dismissal via `SharedPreferences`.
- `packages/core/lib/data/providers/playback_settings_provider.dart`: Add `enableRememberPlaybackSpeedAndSave` method and reset prompt dismissal when toggling settings.
- `packages/core/lib/l10n/`: Standardized speed formatting multiplier `{speed}X` across all locales (`app_en.arb`, `app_ar.arb`, `app_ml.arb`, `app_ta.arb`).
- `packages/courses/lib/widgets/lesson_detail/video_lesson_viewer.dart`: Integrate the in-player prompt banner and wire actions to core providers.
- `packages/courses/test/widgets/video_lesson_viewer_test.dart`: Widget test coverage for prompt display, confirmation, dismissal, and reset flows.
