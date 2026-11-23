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

### Requirement: Attachment Source Selection Sheet
The AI chat screen SHALL present a bottom sheet when the composer attachment action is tapped, offering camera and gallery sources, and invoke `AppImageCropper` prior to staging.

#### Scenario: Present camera and gallery source options with cropping
- **WHEN** the user taps the composer attachment action
- **THEN** an `AppBottomSheet` is displayed with Camera on top ("Take photo") and Gallery on the bottom ("Attach image").
- **AND** selecting an image from either source invokes `AppImageCropper` for freeform cropping and rotation.
- **AND** confirming the crop stages the cropped image attachment.
- **AND** cancelling the crop discards the selection without staging.
