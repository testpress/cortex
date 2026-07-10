# video-player-pause Specification

## Purpose
TBD - created by archiving change pause-video-on-ask-doubt. Update Purpose after archive.
## Requirements
### Requirement: Video Player Lifecycle on Ask Doubt

The player MUST properly finalize and restore video state when navigating to Ask Doubt.

#### Scenario: Navigating to Ask Doubt
- When the user taps "Ask Doubt"
- Then the `onBeforeNavigate` callback MUST be invoked
- And `CustomVideoPlayerState.finalizePlayback()` MUST finalize the interval, save the current position, and force sync the video attempt
- And the player widget MUST be unmounted (`_isPlayerDestroyed = true` returning `SizedBox.shrink()`)

#### Scenario: Returning from Ask Doubt
- When the user returns from Ask Doubt
- Then the `onResumeVideo` callback MUST be invoked
- And `CustomVideoPlayerState.restorePlayback()` MUST clear the destroyed state
- And the player MUST be recreated and seek to the saved position

