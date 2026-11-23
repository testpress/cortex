## Context

Generic AI chat in `packages/core` communicates with the LearnLens backend. Previously, the mobile chat interface supported text-only queries and rendered incoming image attachments inside a single enclosed container. This change adds image capture and gallery picking via a bottom sheet, image cropping via `AppImageCropper`, immediate background upload to the attachments API, and web-aligned message bubble layout.

## Goals / Non-Goals

**Goals:**
- Allow learners to select images from camera or gallery and crop them before staging.
- Upload image bytes immediately in the background on selection to retrieve `attachment_id` and signed CDN URL.
- Display staged attachment thumbnail preview chips in `AiComposer` with a deletion action that calls `DELETE /generic/attachments/{attachment_id}/`.
- Submit `attachment_ids` in `startConversation` and `sendFollowUpMessage` payloads and reset staged state.
- Decouple `AiUserMessageBubble` to render image attachment cards above an independent text bubble on the trailing side.
- Maintain existing 48dp touch targets, token-driven colors, and localization across all supported locales.

**Non-Goals:**
- Non-image attachments (PDFs, audio, etc.).
- Multi-image bulk picker (images are selected/captured and cropped one at a time up to 4 total).
- Response stream cancellation ("Stop" generation action).
- Modifying conversation history drawer, auth session, or institute policy gating.

## Decisions

### Decision 1: Attachment source selection and cropping integration
Tapping the composer plus (`+`) action opens an `AppBottomSheet` offering Camera on top ("Take photo") and Gallery on the bottom ("Attach image"). Upon selection, the image is passed to `AppImageCropper` for cropping and rotation before being staged.
- *Rationale*: A bottom sheet keeps the composer uncluttered with a clean 48dp trigger. Running `AppImageCropper` immediately lets students crop diagrams or problem text before initiating upload.
- *Alternatives considered*: Dedicated camera and gallery buttons directly in the composer bar were rejected to preserve horizontal space for the text field and send button.

### Decision 2: Immediate background upload on selection
When an image is confirmed from cropping, `stageAttachment` immediately initiates `uploadAttachment` in the background rather than delaying until turn dispatch.
- *Rationale*: Immediate upload returns the backend `attachment_id` and signed CDN URL upfront, enabling instant cached thumbnail display and ensuring turn dispatch is instantaneous without waiting for file uploads.
- *Alternatives considered*: Deferring upload until message send was rejected because it introduces significant latency between the user tapping send and the turn starting.

### Decision 3: Standalone image card above user prompt bubble
`AiUserMessageBubble` renders attached images as distinct rounded cards (`ClipRRect` with 16dp radius) aligned to the trailing side, with the user prompt in an independent rounded pill bubble directly underneath.
- *Rationale*: Wrapping both images and text inside a single background card looked cluttered and diverged from the web design. Separating them creates clean visual hierarchy matching web inspect specifications.

## Risks / Trade-offs

- **[Risk]** Unsent uploaded attachments consume backend storage if the user deletes a chip or clears the composer. → **Mitigation**: Tapping the chip close button immediately invokes `LearnLensRepository.deleteAttachment(attachmentId)` to free server resources.
- **[Risk]** High-resolution camera captures could introduce upload latency or exceed payload limits. → **Mitigation**: Images are compressed with `imageQuality: 85` on capture and crop before upload.
