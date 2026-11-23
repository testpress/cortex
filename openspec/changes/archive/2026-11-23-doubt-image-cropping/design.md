## Context

`AskDoubtFormScreen` allows students to compose and submit academic doubts with text formatting, topic selection, and up to 3 image attachments selected from the device photo gallery or captured via the camera. Previously, images were attached directly to the form without an opportunity for users to crop out extraneous content.

Integrating image cropping requires coordinating the cropping lifecycle with the form's state: managing visual loading states during native activity transitions and handling multi-image selection flows gracefully when a user cancels.

## Goals / Non-Goals

**Goals:**
- Integrate `AppImageCropper` into image selection workflows for both camera and gallery sources.
- Coordinate processing state with an `AppLoadingIndicator` overlay while images are being cropped.
- Provide a clean exit path in multi-image selection by terminating the sequence if a user cancels cropping.
- Enforce the 3-image attachment ceiling across batch operations.

**Non-Goals:**
- Modifying `AppImageCropper` platform integration or core package implementations.
- Altering the backend doubt creation API contract or attachment upload payloads.

## Decisions

### 1. Sequential Cropping with Immediate Exit on Cancel
- *Decision*: In multi-image selection, process images sequentially through `AppImageCropper.crop`. If the user cancels (`croppedPath == null`), immediately terminate the loop.
- *Rationale*: When selecting multiple images, launching consecutive native crop dialogs after the user cancels one creates an inescapable modal loop. Exiting immediately respects the user's intent to dismiss the flow.
- *Alternatives considered*: Prompting the user with a confirmation dialog before cancelling remaining images. Rejected as it introduces unnecessary UI friction.

### 2. State-Driven Loading Overlay
- *Decision*: Introduce `_isProcessingImage` boolean state in `_AskDoubtFormScreenState` that wraps the picking and cropping flow in a `try/finally` block.
- *Rationale*: Cropping involves launching an external native activity and asynchronous file processing. A full-screen semi-transparent overlay prevents double-taps and signals that the system is processing the media.

## Risks / Trade-offs

- [Risk: Cancelling one crop in a multi-image batch skips remaining uncropped images] → Mitigation: Students can easily re-open the gallery to pick any remaining images. Aborting on cancel prevents modal entrapment, which is a significantly worse UX failure.
