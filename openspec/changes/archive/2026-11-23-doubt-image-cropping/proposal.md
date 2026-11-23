## Why

When students capture photos of physical textbooks or take screenshots on mobile to ask a doubt, the images often contain extraneous margins, headers, or multiple unrelated questions on a single page.

Allowing students to crop images before attaching them ensures that mentors and AI can focus on the specific problem statement or diagram without confusion.

## What Changes

- **Image Cropping on Attachment**: Automatically launch the image cropper when images are captured from the camera or selected from the device gallery in the doubt composition form.
- **Batch Cropping Flow**: Sequentially present the cropper for each image selected in a multi-image batch, cleanly aborting remaining crops if the user cancels.
- **Processing Feedback**: Display a loading indicator overlay while images are being cropped or processed.

## Capabilities

### Modified Capabilities
- `doubts-compose-ui`: Update media attachment requirements to include cropping before attaching images and feedback during processing.

## Impact

- `packages/discussions`: Updates `AskDoubtFormScreen` attachment flow and corresponding tests.
