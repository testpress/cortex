## Why

The current radio button rendering in the app settings screen is inconsistent, pixelated, and uneven. The outer circle does not render as a clean circle, showing visual artifacts (uneven thickness and gaps) on standard and small sizes due to subpixel alignment clipping and stroke joint rasterization.

## What Changes

Improve the visual quality and consistency of `_RadioIndicator` by:
- Redesigning the indicator to render using a `CustomPainter` with concentric filled circles (`PaintingStyle.fill`) instead of border strokes, bypassing Skia stroke rendering joint gaps.
- Implementing subpixel rounding/snapping for center offsets and radii to align drawings exactly to the device physical pixel grid.
- Aligning layout sizing to Figma specifications: standard size to `20.0` logical pixels (`design.iconSize.md`) and small size to `16.0` logical pixels (`design.iconSize.sm`).

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `app-settings`: Improve the visual design, consistency, and rendering of radio indicators in theme, quality, and text size options.

## Impact

Modifies the `_RadioIndicator` widget and adds a new `_RadioPainter` class inside `packages/profile/lib/screens/app_settings_screen.dart`.
