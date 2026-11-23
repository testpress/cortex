## 1. Dependencies and Platform Configuration

- [x] 1.1 Add `image_cropper` dependency to `packages/core/pubspec.yaml`
- [x] 1.2 Add Android UCropActivity and AppCompat configuration in `app/android`
- [x] 1.3 Add `cropImage` localized string across ARB files (`app_en.arb`, `app_ta.arb`, `app_ml.arb`, `app_ar.arb`) and generated classes

## 2. Core Image Cropping Implementation

- [x] 2.1 Implement `AppImageCropper.crop` service helper in `packages/core/lib/widgets/image_cropper/`
- [x] 2.2 Export `AppImageCropper` in `packages/core/lib/core.dart`
- [x] 2.3 Add unit and widget tests for image cropper in `packages/core/test/widgets/app_image_cropper_test.dart`

## 3. Verification and Quality Checks

- [x] 3.1 Verify core test suite and static analysis

## 4. Review Feedback & Refinements

- [x] 4.1 Refactor `AppImageCropper` with constructor dependency injection and Sentry error logging
- [x] 4.2 Remove fixed portrait orientation from `UCropActivity` to support tablets and landscape
- [x] 4.3 Add native Android uCrop dark theme color and shape overrides in the app shell
- [x] 4.4 Add unit test coverage for the thrown-exception error path
- [x] 4.5 Use `DesignColors.dark()` design tokens for Android cropper UI settings
- [x] 4.6 Define `AppUCropTheme` extending `Theme.AppCompat.NoActionBar` in Android manifest and styles
- [x] 4.7 Wrap `file.exists()` inside the `try` block to capture I/O exceptions in Sentry
