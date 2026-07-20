## Why

We need to add a watermark showing the user's username over PDFs in the courses section. This adds a layer of security by making it easier to trace leaked documents back to the source account.

## What Changes

- Create a mechanism to access the current authenticated user's profile globally.
- Overlay a single watermark of the user's username centered diagonally on top of the PDF viewer.
- Ensure the watermark does not block zooming, scrolling, or other touch interactions with the PDF document.

## Capabilities

### New Capabilities

- `pdf-watermarking`: Defines the requirements and constraints for watermarking PDF content in the application.

### Modified Capabilities

- None

## Impact

- **Core Package**: The auth data layer will be updated to expose the current user's profile details natively.
- **Courses Package**: The PDF viewer widget will be updated to include an overlay.
- **UI/UX**: Users viewing PDFs will now see a semi-transparent, single text watermark diagonally across their screen.
