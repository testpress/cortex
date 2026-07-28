## Context

The video player currently does not apply any watermarks to identify users. We need to integrate a watermarking system that reads configuration fields (`type` and `position`) from the backend and overlays the user's username onto the video playback screen. This deters unauthorized recording and distribution of proprietary content.

## Goals / Non-Goals

**Goals:**
- Consume the watermark configuration provided by the backend.
- Implement watermarking natively using the `tpstreams_player_sdk`'s built-in `setWatermarks` API.
- Support `static` (fixed position), `dynamic` (animated/moving), and `hidden` configurations.
- Map the 5 predefined static positions (top left, top right, bottom left, bottom right, and middle) to the SDK's `x` and `y` percentage coordinate system.

**Non-Goals:**
- Implementing custom Flutter UI stacks to render watermarks over the video. We will strictly use the player SDK's capabilities.
- Modifying backend API logic or database schemas (this is purely consuming the frontend data).

## Decisions

- **Watermark Implementation:** We will use `_controller.setWatermarks([WatermarkConfig(...)])` provided by the player SDK. This ensures optimal performance and native integration with the video surface.
- **Dynamic Animation:** If the backend `type` is `dynamic`, we will configure the `WatermarkConfig` with a `WatermarkAnimation` using `WatermarkAnimationType.pingPong` and a reasonable duration (e.g., 5000ms or 10000ms).
- **Static Positioning Mapping:** The 5 backend positions for `static` mode will be mapped to the `x` and `y` properties (0-100 percentage values), using 10% and 90% as padded bounds:
  - Top Left: `x: 10, y: 10`
  - Top Right: `x: 90, y: 10`
  - Bottom Left: `x: 10, y: 90`
  - Bottom Right: `x: 90, y: 90`
  - Middle: `x: 50, y: 50`
- **Opacity and Styling:** We will pass a standard `opacity` (e.g., 0.5) and white `color` (`0xFFFFFFFF`) to keep it visible but unobtrusive.
- **Config Syncing & Reactivity:** The implementation is highly reactive; if the `instituteSettingsProvider` or `userProvider` updates in the background during active playback, the player will instantly apply the new watermark configuration (e.g., updating position, type, or username text). Note: in the rare edge case where a configuration is explicitly disabled (changed to `null`) mid-session, the disable will seamlessly take effect on the next video launch rather than abruptly clearing the active native overlay.

## Risks / Trade-offs

- **Risk:** SDK-specific limitations on watermark styling compared to custom Flutter widgets.
  - **Mitigation:** The native `WatermarkConfig` supports opacity, size, color, and animations, which is sufficient for our security and UI requirements while guaranteeing better performance than a custom Flutter overlay stack.
