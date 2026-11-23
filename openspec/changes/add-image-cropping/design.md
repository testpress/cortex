## Context

Cortex currently lacks a standardized image cropping component in the platform SDK. Various features—including student doubts, discussion forums, profile pictures, and AI camera input—require the ability to crop images before upload.

This design introduces a reusable image cropping service (`AppImageCropper`) in `packages/core` to provide standard image cropping functionality across all clients and flows.

## Goals / Non-Goals

**Goals:**
- Provide a standardized image cropping service (`AppImageCropper`) in `packages/core`.
- Apply Cortex design tokens (`Design.of(context)`) to platform crop UI settings (toolbar colors, active control widgets, title).
- Support freeform rectangular cropping, pan, zoom, cancel, and confirm actions.
- Automatically return the sanitized cropped file path (`String`), or `null` if cancelled.
- Fully localize toolbar titles using `L10n.of(context).cropImage`.

**Non-Goals:**
- Wiring the cropper into specific domain screens (domain adoption will follow in separate changes).
- Advanced photo editing tools (filters, stickers, annotations).
- Multi-image simultaneous batch crop UI.

## Decisions

### 1. Unified Service in `packages/core`
- **Decision**: Place `AppImageCropper` in `packages/core/lib/widgets/image_cropper/` and export through `packages/core/lib/core.dart`.
- **Rationale**: `packages/core` is the platform SDK. Putting the cropper in `core` makes it available to all domain packages (`discussions`, `courses`, `profile`, `exams`) with zero cross-domain coupling.

### 2. Platform UI Theming & Media Studio Palette
- **Decision**: Configure a dedicated dark photo studio theme on Android (`#18181B` surface, `#FAFAFA` text, `#09090B` canvas, `#8A000000` dimmed overlay) matching media editing standards (Google Photos, iOS TOCropViewController). Override native Android uCrop resources (`res/values/colors.xml` and `res/drawable/ucrop_wrapper_controls_shape.xml`) to eliminate hardcoded white and navy blocks. Retain brand primary accent from `Design.of(context).colors.primary`.
- **Rationale**: Provides consistent high-contrast, distraction-free photo evaluation across both light and dark app modes while maintaining full localization.

### 3. File System, Error Handling & Cancellation Semantics
- **Decision**: If the user cancels the crop screen, `AppImageCropper.crop` returns `null`. If confirmed, it returns the cropped file path. If the source file does not exist, it safely returns `null`. Any unexpected platform/plugin exceptions are captured to Sentry with tag `component: app_image_cropper` before returning `null`.
- **Rationale**: Prevents swallowed exceptions from hiding platform integration bugs while keeping the service fail-safe for caller UI widgets.

## Risks / Trade-offs

- **[Trade-off] Native Cropper Activity**: Uses platform activities (`UCropActivity` on Android). Requires AndroidManifest activity declaration without fixed portrait orientation to support tablets and landscape, plus `appcompat` dependency in `app/android`.
