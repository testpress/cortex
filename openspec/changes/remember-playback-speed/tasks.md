## 1. Core Settings Layer

- [x] 1.1 Add `rememberPlaybackSpeed` (bool, default true) and `globalPlaybackSpeed` (double?, nullable) to `PlaybackSettings` + `AppSettingsDefaults` in `settings_models.dart`.
- [x] 1.2 Add columns to `AppSettingsTable`: `rememberPlaybackSpeed` (bool, default true), `globalPlaybackSpeed` (real, nullable).
- [x] 1.3 Regenerate drift schema and add defaults to the singleton row insert/read fallback in `app_database.dart`.
- [x] 1.4 Add DAO helpers: read toggle + global speed, update toggle, update global speed.

## 2. Playback Speed Restore & Persist

- [x] 2.1 Resolve effective speed on load: toggle off → 1x; on → global speed or 1x fallback.
- [x] 2.2 In `CustomVideoPlayer._onPlayerCreated`, call `controller.setPlaybackSpeed(effectiveSpeed)` right after watermark setup.
- [x] 2.3 Persist on user speed change via rate inference (Δposition/Δwall-time) during steady playback; quantize to standard speeds; write global speed when toggle is on.
- [x] 2.4 Show temporary non-blocking snackbar ("Playing at 3x · Reset") when restored speed > 1x; auto-dismiss.
- [x] 2.5 Reset action: set current video to 1x immediately and persist 1x as the remembered speed.

## 3. App Settings UI

- [x] 3.1 Add Remember Playback Speed toggle to the playback preferences section, reusing the `_buildToggleOption` pattern.
- [x] 3.2 Wire toggle to the persisted setting; changes apply to subsequently opened videos.

## 4. Verify

- [x] 4.1 Toggle on: set 2x in one video → next video starts at 2x.
- [x] 4.2 Toggle off: speed change not persisted; saved speed ignored, videos start at 1x.
- [x] 4.3 Toggle and speed survive app restart.
- [x] 4.4 Restore does not delay playback and shows the non-blocking notification with working Reset.
- [x] 4.5 `flutter analyze` and relevant unit/widget tests pass.
