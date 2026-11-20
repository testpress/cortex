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

### 2. Platform UI Theming
- **Decision**: Configure Android and iOS UI settings using runtime design tokens from `Design.of(context)` (surface color, text primary, brand primary) and localized titles via `L10n.of(context).cropImage`.
- **Rationale**: Keeps native toolbar appearance aligned with the Cortex theme while ensuring full localization across Arabic, English, Malayalam, and Tamil.

### 3. File System & Cancellation Semantics
- **Decision**: If the user cancels the crop screen, `AppImageCropper.crop` returns `null`. If confirmed, it returns the cropped file path. If the source file does not exist, it safely returns `null`.

## Risks / Trade-offs

- **[Trade-off] Native Cropper Activity**: Uses platform activities (`UCropActivity` on Android). Requires AndroidManifest activity declaration and appcompat dependency in `app/android`.
