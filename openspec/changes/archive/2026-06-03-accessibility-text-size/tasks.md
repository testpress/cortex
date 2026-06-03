## 1. Expose Text Scale Provider

- [x] 1.1 Implement `appTextScaleMultiplierProvider` in `packages/profile/lib/providers/settings_providers.dart` that watches `accessibilitySettingsNotifierProvider` and maps the selected text size to a scale multiplier factor.

## 2. Apply Text Scaling Globally

- [x] 2.1 Update `CortexApp` in `app/lib/main.dart` to watch `appTextScaleMultiplierProvider`.
- [x] 2.2 In `app/lib/main.dart`, wrap the widget tree in the `builder` of `MaterialApp.router` with a `MediaQuery` that scales the system's `textScaler` by the retrieved multiplier factor.

## 3. Verification

- [x] 3.1 Verify that changing the text scale size in the settings panel updates the app's overall text scaling factor instantly.
- [x] 3.2 Run static code analysis to verify no lint errors are introduced.

## 4. Fix Layout Overflows

- [x] 4.1 Scale `contentHeight` dynamically based on `MediaQuery.textScalerOf(context)` in `LessonCardsSectionWidget` to prevent bottom overflows on larger text sizes.
- [x] 4.2 Scale carousel heights dynamically in `SnapshotSection`, `PromotionalBanners`, and `FeaturedCarousel` to prevent clipping and overflows under large font scaling settings.

