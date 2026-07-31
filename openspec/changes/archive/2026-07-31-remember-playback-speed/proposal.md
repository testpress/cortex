## Why

Learners watching multiple lessons in a course often stick to one playback speed (e.g., 1.5x, 2x, 3x). Today the player resets to 1x on every new video, forcing users to reopen player settings and reselect the speed for each lesson. This repeated interaction increases friction and interrupts continuous learning sessions.

## What Changes

- Add a **Remember Playback Speed** setting under Playback Settings:
  - **On**: the last-used playback speed is remembered globally and restored for every subsequently opened video.
  - **Off**: every video starts at the default speed (1x); playback speed is never persisted.
- Default the setting to **Off** for new users.
- Restore the remembered speed automatically when a video loads, without any confirmation dialog.
- Persist the toggle and the remembered speed across app sessions via the existing app settings storage.
- Show a temporary, non-blocking notification when a remembered speed is restored, with a **Reset** action that immediately returns playback to 1x and updates the remembered speed.
- Apply the selected speed immediately when the user changes it in the player, and persist it while the setting is On.

## Capabilities

### New Capabilities
- `video-playback-speed`: automatic restore and persistence of a single global playback speed across video lessons, governed by a Remember Playback Speed toggle.

### Modified Capabilities
- `app-settings`: extend the "Learning and Playback Preferences" requirement to include the Remember Playback Speed toggle.

## Impact

- `packages/core/lib/data/db/tables/app_settings_table.dart` — new column for the toggle + global speed.
- `packages/core/lib/data/models/settings_models.dart` — extend `PlaybackSettings` with the toggle and speed.
- `packages/core/lib/data/db/app_database.dart` — schema migration + DAO methods.
- `packages/courses/lib/widgets/lesson_detail/custom_video_player.dart` — read remembered speed on load and call `setPlaybackSpeed`, persist on change.
- `packages/profile/lib/screens/app_settings_screen.dart` (app settings UI) — expose the toggle under playback settings.
