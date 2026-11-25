# generic-ai-chat-screen Specification

## Purpose
TBD - created by archiving change generic-ai-chat-screen. Update Purpose after archive.
## Requirements
### Requirement: Chat Header Navigation
The system SHALL provide a dedicated header with leading conversation history access, active conversation title display, and trailing action controls.

#### Scenario: User opens history menu from leading button
- **WHEN** the user taps the leading hamburger menu icon in the header
- **THEN** the system triggers the conversation history drawer.

#### Scenario: Active conversation title display
- **WHEN** an active conversation is selected or loaded
- **THEN** the system renders the conversation title beside the hamburger icon with single-line truncation.

#### Scenario: User taps New Chat action
- **WHEN** the user taps the New Chat compose button on the trailing edge of an active conversation header
- **THEN** the system resets the conversation canvas to a clean new chat.

#### Scenario: Empty new chat header actions
- **WHEN** the user is on the clean new chat landing screen
- **THEN** the system displays only the leading hamburger menu and default title without trailing new chat or overflow action buttons.

#### Scenario: User deletes active conversation from header overflow menu
- **WHEN** the user taps the 3-dot overflow menu on an active conversation and confirms deletion
- **THEN** the system permanently deletes the conversation and resets the chat canvas.

### Requirement: Empty Canvas State
The system SHALL render a clean, distraction-free canvas when no conversation messages exist.

#### Scenario: Viewing initial chat screen
- **WHEN** the user opens the AI chat screen with no active messages
- **THEN** the system displays a blank chat canvas with the bottom composer pinned at the bottom.

### Requirement: Message Bubble Layout and Actions
The system SHALL display user messages and assistant responses with formatted timestamps and action controls, rendering user image attachments as standalone cards above the text prompt.

#### Scenario: Rendering user message with image and text
- **WHEN** a user message contains image attachments and text
- **THEN** the screen renders the image preview card on top and a separate text bubble directly below it, without a single enclosing background container around both.

#### Scenario: Rendering user message with only image
- **WHEN** a user message contains image attachments without accompanying text
- **THEN** the screen renders only the standalone image preview card without an empty text bubble.

### Requirement: Inline Send Error Recovery
The system SHALL display an inline retry indicator when sending a message fails, preserving the user message bubble.

#### Scenario: Message send failure
- **WHEN** submitting a user query encounters a transport failure
- **THEN** the user bubble remains visible, and the system displays "Couldn't send message. Tap to retry" in red below the bubble.

### Requirement: Generation Error Recovery
The system SHALL display an actionable error card when AI response generation fails on the service.

#### Scenario: Generation failure response
- **WHEN** AI generation fails for an accepted message
- **THEN** the system renders an "AI Assistant" card with "Couldn't generate a response. Please try again." and a "Try again" action button.

#### Scenario: Retrying failed generation
- **WHEN** the user triggers retry on a failed assistant generation card
- **THEN** the system retrieves the preceding user prompt and regenerates the response using that prompt.

#### Scenario: Retrying while generation is in flight
- **WHEN** AI response generation is already in flight
- **THEN** the system ignores retry triggers to prevent race conditions and interleaved responses.

### Requirement: Bottom Composer Bar
The system SHALL provide a pill-shaped input bar with an adaptive circular send button.

#### Scenario: Composer input state
- **WHEN** the user types text into the input field
- **THEN** the up-arrow send button switches from an inactive/muted visual state to an active visual state.

### Requirement: App Lifecycle Resumption Sync
The system SHALL monitor application lifecycle state changes and trigger canonical conversation state synchronization when returning to the foreground.

#### Scenario: App returns to foreground with active chat
- **WHEN** the host application lifecycle changes to `AppLifecycleState.resumed` while `AiScreen` is mounted
- **THEN** the screen SHALL request the controller to refresh the canonical conversation status and messages.

### Requirement: Stopped Generation Message Display
The system SHALL display an assistant response that was stopped with its retained partial text and clear non-error stopped visual indicator.

#### Scenario: Rendering a stopped response
- **WHEN** an assistant message has generation status `stopped`
- **THEN** the system SHALL render the partial answer Markdown and display a subtle "Stopped" label below the card, omitting error cards and retry prompts.

### Requirement: Assistant Message Card State Modeling
The system SHALL model assistant message visual states using an explicit enum status to prevent conflicting state representations.

#### Scenario: Visual status resolution
- **WHEN** an assistant card renders
- **THEN** it SHALL resolve its rendering mode from an explicit `AiAssistantStatus` (completed, generating, failed, stopped).

### Requirement: Access Restriction Notice Display
The system SHALL display a prominent access restriction card when the learner's policy disallows generation.

#### Scenario: Displaying restricted access card
- **WHEN** learner access policy indicates `can_generate == false`
- **THEN** the system SHALL render a dedicated access card with a lock icon, bold title ("AI chat not available"), explanatory text directing them to contact their administrator, and lock the composer.

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
The AI chat screen SHALL validate that picked images (pre-crop) and cropped images match supported formats (`JPEG`, `JPG`, `PNG`, `WebP`), derive the MIME type from the cropped file extension, and reject unsupported formats before opening the cropper.

#### Scenario: Deriving MIME type from cropped image extension
- **WHEN** an image is cropped
- **THEN** the screen SHALL derive the MIME type from the cropped file (`image/jpeg`, `image/png`, or `image/webp`) and pass it to the controller.

#### Scenario: Rejecting unsupported image formats
- **WHEN** a selected image has an unsupported format (e.g. GIF, HEIC, BMP) either before cropping or after cropping
- **THEN** the screen SHALL display a localized toast (`aiChatUnsupportedImageFormat`) and discard the attachment without staging or launching the cropper.

### Requirement: Attachment Loading Feedback and Failure Toast
The AI chat screen SHALL provide visual loading feedback during cropping transitions and surface error toasts when staged attachment uploads fail.

#### Scenario: Visual indicator during image cropping preparation
- **WHEN** the user initiates image attachment selection
- **THEN** the screen SHALL display an `AppLoadingIndicator` overlay while cropping preparation is in progress.

#### Scenario: Toast notification on attachment upload failure
- **WHEN** an attachment upload fails in the generic AI chat state
- **THEN** the screen SHALL display an error toast (`aiComposerAttachmentUploadFailed`) positioned above the bottom navigation bar.

