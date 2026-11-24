## 1. DTOs and Data Models

- [x] 1.1 Add `AiAttachmentDto` and `AiAttachmentUploadResponseDto` to `packages/core/lib/data/models/learnlens_dto.dart`
- [x] 1.2 Update `AiMessageDto` and turn response DTOs to parse attachment lists
- [x] 1.3 Update `GenericAiChatMessage` view model to include attachments

## 2. API Endpoints & Networking

- [x] 2.1 Add endpoint for generic attachments (`/generic/attachments/`) in `api_endpoints.dart`
- [x] 2.2 Implement `uploadAttachment` and `deleteAttachment` in `LearnLensNetworkClient` and `LearnLensRepository`

## 3. State Management & Provider

- [x] 3.1 Extend `GenericAiChatState` with staged attachments and upload progress tracking
- [x] 3.2 Implement `stageAttachment`, `removeAttachment`, and unsent attachment deletion in `GenericAiChat` provider
- [x] 3.3 Update message send actions to submit `attachmentIds` and clear staged attachments

## 4. UI Widgets & Interactions

- [x] 4.1 Update `AiComposer` to add attachment picker action with plus (`+`) icon and staged image thumbnail preview chips with `(X)` delete button
- [x] 4.2 Refactor `AiUserMessageBubble` to render image attachment cards above an independent text message bubble (web-aligned layout)
- [x] 4.3 Update `AiScreen` to show camera/gallery source bottom sheet (camera top, gallery bottom) on attachment trigger
- [x] 4.4 Delegate picked images through `AppImageCropper` before staging in `AiScreen`
- [x] 4.5 Wire attachment staging and chip deletion callbacks
- [x] 4.6 Anchor staged attachment thumbnail delete button to top-trailing corner with 48dp touch target and non-clipping preview container

## 5. Tests & Verification

- [x] 5.1 Add unit tests for attachment upload and deletion in network client and repository tests
- [x] 5.2 Add unit tests for `GenericAiChat` provider covering staging attachments and turn submission
- [x] 5.3 Add widget tests for `AiComposer` (staged chips, delete action) and `AiUserMessageBubble` (web-aligned layout)
- [x] 5.4 Run analyzer and test suite to verify no regressions
