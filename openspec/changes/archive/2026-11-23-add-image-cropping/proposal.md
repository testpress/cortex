## Why

Currently, images attached to features across Cortex (doubts, forum posts, profile avatars, and upcoming AI camera input) lack an image cropping capability. Adding a reusable image cropping utility (`AppImageCropper`) in `packages/core` establishes a standard platform capability that any domain package can leverage without duplicating cropping configuration or image file lifecycle logic.

## What Changes

- Add a reusable image cropping service (`AppImageCropper`) in `packages/core`.
- Configure underlying cropping platform settings (`AndroidUiSettings`, `IOSUiSettings`) styled with Cortex design tokens (`Design.of(context)`).
- Add localization for `cropImage` across supported locales (`en`, `ta`, `ml`, `ar`).
- Configure Android build and manifest settings (`UCropActivity`, `androidx.appcompat`).
- Provide unit and widget tests for `AppImageCropper` in `packages/core/test/widgets/`.

## Capabilities

### New Capabilities
- `image-cropping`: Platform image cropping interface and service in `packages/core`, providing interactive crop bounding box manipulation, localized UI strings, and theme integration.

## Impact

- **Dependencies**: Adds `image_cropper` dependency to `packages/core/pubspec.yaml`.
- **SDK & Monorepo**: `packages/core` exposes `AppImageCropper` in `lib/widgets/image_cropper/` and exports through `packages/core/lib/core.dart`.
- **Android Configuration**: Adds `UCropActivity` and `androidx.appcompat` dependency in `app/android`.
- **Domain Packages**: No domain package UI changes in this initial capability PR.
