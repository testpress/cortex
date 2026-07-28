## Why

We need to protect our proprietary video media from unauthorized distribution and recording. Extending configurable, user-identifying watermarks to the video player provides consistent intellectual property protection.

## What Changes

- Integrate watermarking infrastructure specifically into the video playback system.
- Support dynamic, backend-driven configuration for watermark rendering, handling three main types:
  - `static`: Displayed in one of 5 fixed positions (top-left, top-right, bottom-left, bottom-right, middle).
  - `dynamic`: Animated to move around the screen to prevent easy removal.
  - `hidden`: Disables the watermark entirely.
- Ensure the video player securely overlays the user's username based on these settings without negatively impacting video performance or user experience.

## Capabilities

### New Capabilities
- `video-playback-watermark`: Applies configurable user-specific watermarks over video content during playback.

### Modified Capabilities

## Impact

- Video player UI components (rendering the overlay).
- Data and network models (parsing the `type` and `position` fields from the backend response).
