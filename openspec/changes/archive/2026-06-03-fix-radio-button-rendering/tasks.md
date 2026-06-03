## 1. Implement Widget Redesign

- [x] 1.1 Redesign `_RadioIndicator` in `packages/profile/lib/screens/app_settings_screen.dart` to use concentric filled circles and pixel snapping.
- [x] 1.2 Verify that both standard (20px) and small (16px) variants render smoothly and animates correctly.

## 2. Verification

- [x] 2.1 Verify app setting screen loads and updates correct theme, quality, and text size options.
- [x] 2.2 Run static code analysis / linter to ensure no errors or warnings are introduced.

## 3. Smooth Selection Transition

- [x] 3.1 Modify `_RadioPainter` to always draw the inner background circle and smoothly interpolate its color from `cardColor` to `fillColor` using `Color.lerp` based on `animationValue`.
- [x] 3.2 Verify that the pop/flash at the end of the selection animation is resolved and transitions smoothly.
