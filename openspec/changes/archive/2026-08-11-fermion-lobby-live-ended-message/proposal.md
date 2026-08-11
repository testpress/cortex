## Why

When a Fermion live stream has ended (`status == "Completed"`) and there is no recording available (`show_recorded_video == false`), the Fermion lobby displays the metadata card but shows no action button and no message explaining why. This leaves a blank space and creates a dead-end experience for the user.

## What Changes

- Update the Fermion lobby screen to display a clear notice explaining that the live session has ended and no recording is available.
- Define new localized strings for this notice.
- Implement a styled notice box inside the metadata card when in the "ended" state.

## Capabilities

### New Capabilities

*(None)*

### Modified Capabilities

- `live-stream/fermion-provider`: Update the requirement for completed sessions without recording to specify that a clear notice (icon + title + message) must be displayed on the lobby card.

## Impact

- `fermion_lobby_view.dart`: Update `FermionLobbyView` to render the notice box when `action == _LobbyAction.ended`.
- `app_en.arb`: Add localization strings for the ended notice status and details.
