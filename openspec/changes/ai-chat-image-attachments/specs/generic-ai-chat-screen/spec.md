## MODIFIED Requirements

### Requirement: Message Bubble Layout and Actions
The system SHALL display user messages and assistant responses with formatted timestamps and action controls, rendering user image attachments as standalone cards above the text prompt.

#### Scenario: Rendering user message with image and text
- **WHEN** a user message contains image attachments and text
- **THEN** the screen renders the image preview card on top and a separate text bubble directly below it, without a single enclosing background container around both.

#### Scenario: Rendering user message with only image
- **WHEN** a user message contains image attachments without accompanying text
- **THEN** the screen renders only the standalone image preview card without an empty text bubble.

## ADDED Requirements

### Requirement: Attachment Source Selection Popover
The AI chat screen SHALL present a compact anchored popover above the attachment action when tapped, offering camera and gallery sources, and invoke `AppImageCropper` prior to staging.

#### Scenario: Present camera and gallery source options with cropping
- **WHEN** the user taps the composer attachment action
- **THEN** a floating popover is displayed anchored above the attachment button with Gallery on top ("Upload an image") and Camera on the bottom ("Take a photo"), encapsulated in `AiAttachmentPickerSheet`.
- **AND** selecting an image from either source invokes `AppImageCropper` for freeform cropping and rotation.
- **AND** confirming the crop stages the cropped image attachment.
- **AND** cancelling the crop discards the selection without staging.

#### Scenario: Attachment source permission denied or error
- **WHEN** camera or photo library permission is denied when picking an image
- **THEN** the screen SHALL display a localized permission toast informing the user.
- **AND** unexpected failures SHALL be captured to Sentry and surface an error toast.
- **AND** user cancellation SHALL remain silent without toasts.

#### Scenario: Gating attachment action by policy
- **WHEN** the session policy specifies `imageAttachmentsEnabled == false`
- **THEN** the screen SHALL pass `null` for `onAttachImage`, hiding the attachment trigger from the composer.
- **AND** when `imageAttachmentsEnabled == true`, the attachment trigger SHALL be enabled.

### Requirement: Attachment Size Limits and Compression
The AI chat screen SHALL enforce image dimension downscaling (1920x1920 max) and a 5 MB file size cap using cross-platform web-safe APIs (`XFile`).

#### Scenario: Image exceeds file size limit
- **WHEN** a picked and cropped image exceeds 5 MB
- **THEN** the screen SHALL display a localized size exceeded toast (`aiChatAttachmentSizeExceeded`) and discard the attachment without staging.

#### Scenario: Web-safe file reading
- **WHEN** reading cropped image bytes
- **THEN** the screen SHALL use `XFile.readAsBytes()` without importing or relying on `dart:io File`.

### Requirement: Supported Image Format Filtering and MIME Type Derivation
The AI chat screen SHALL validate that picked and cropped images match supported formats (`JPEG`, `JPG`, `PNG`, `WebP`), derive the MIME type from the cropped file extension, and reject unsupported formats.

#### Scenario: Deriving MIME type from cropped image extension
- **WHEN** an image is cropped
- **THEN** the screen SHALL derive the MIME type from the cropped file (`image/jpeg`, `image/png`, or `image/webp`) and pass it to the controller.

#### Scenario: Rejecting unsupported image formats
- **WHEN** a selected image has an unsupported format
- **THEN** the screen SHALL display a localized toast (`aiChatUnsupportedImageFormat`) and discard the attachment without staging.

### Requirement: Attachment Loading Feedback and Failure Toast
The AI chat screen SHALL provide visual loading feedback during cropping transitions and surface error toasts when staged attachment uploads fail.

#### Scenario: Visual indicator during image cropping preparation
- **WHEN** the user initiates image attachment selection
- **THEN** the screen SHALL display an `AppLoadingIndicator` overlay while cropping preparation is in progress.

#### Scenario: Toast notification on attachment upload failure
- **WHEN** an attachment upload fails in the generic AI chat state
- **THEN** the screen SHALL display an error toast (`aiComposerAttachmentUploadFailed`) positioned above the bottom navigation bar.

