## Why

Learners using the AI chat frequently need to ask questions about visual content like math problems, textbook diagrams, and exam questions. Currently, the mobile chat only supports text input and displays image messages inside a single clunky card rather than the clean web experience where image previews and text prompts appear as separate elements.

Adding camera and gallery image attachments with cropping brings mobile to parity with the web interface and enables multimodal study workflows.

## What Changes

- **Attachment source selection and cropping**:
  - Tapping the composer plus (`+`) action opens a bottom sheet with Camera ("Take photo") on top and Gallery ("Attach image") on the bottom.
  - Selected images pass through `AppImageCropper` for rotation and cropping before staging.
- **Staging and background upload**:
  - Staged images immediately upload in the background to `POST /generic/attachments/` to obtain an `attachment_id` and signed CDN preview URL.
  - Composer displays horizontal thumbnail chips with a delete action that calls `DELETE /generic/attachments/{attachment_id}/` for unsent cleanup.
- **Turn dispatch**:
  - `startConversation` and `sendFollowUpMessage` submit `attachment_ids` in the payload and clear staged attachments.
- **Web-aligned message bubble layout**:
  - `AiUserMessageBubble` renders sent image attachments as standalone rounded cards aligned to the trailing edge.
  - Accompanying prompt text renders in an independent rounded pill bubble directly underneath.

## Capabilities

### New Capabilities
- `ai-chat-attachments`: Capturing or selecting, cropping, staging, uploading, and viewing image attachments in AI chat.

### Modified Capabilities
- `generic-ai-chat-controller`: Maintain staged attachments, background upload state, and submit attachment IDs with turns.
- `ai-composer`: Plus (`+`) attachment trigger and staged image thumbnail chips with deletion.
- `generic-ai-chat-screen`: Source bottom sheet (camera top, gallery bottom), cropper delegation, and decoupled image card / text bubble layout.

## Impact

- `packages/core/lib/screens/ai_screen.dart`: Attachment bottom sheet presentation, `AppImageCropper` invocation, and staged attachment wiring.
- `packages/core/lib/widgets/ai_composer.dart`: Leading plus (`+`) button and horizontal staged thumbnail chip bar.
- `packages/core/lib/widgets/ai_user_message_bubble.dart`: Decoupled vertical column layout for standalone image cards and text pill.
- `packages/core/lib/data/providers/generic_ai_chat_provider.dart`: `stagedAttachments` state, `stageAttachment`, `removeAttachment`, and `attachment_ids` turn submission.
- `packages/core/lib/data/repositories/learnlens_repository.dart` & `packages/core/lib/network/learnlens_network_client.dart`: Attachment upload and deletion endpoints.
- `packages/core/lib/data/models/learnlens_dto.dart`: `AiAttachmentDto`, `AiAttachmentUploadResponseDto`, and attachment list parsing in turn DTOs.
- `packages/core/lib/l10n/*.arb` & generated localizations: Localized strings for camera, gallery, crop, and attachment labels.
- `packages/core/test/`: Unit and widget tests for network client, repository, provider, composer, user bubble, and AI screen.
- No changes to conversation history drawer, auth session, or institute policy gating.
