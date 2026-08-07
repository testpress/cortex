## Why

The client requested camera photo capture in the Ask Doubt composer. We also standardized the Doubt Detail Reply composer (switching from `FilePicker` to `ImagePicker` to show the media library) and enabled general document/file picker attachments for the Forum Post Create screen to allow attaching PDFs, docx, and txt files.

## What Changes

- Add native camera capture option next to the gallery option in the Ask Doubt composer toolbar.
- Refactor Doubt Detail Reply composer to use `ImagePicker` instead of `FilePicker` to align with other media-oriented composers.
- Enable general File Picker on the Forum Post Create form to support uploading non-image attachments such as PDFs, docx, and text files.
- Update the attachment preview thumbnails to dynamically render file type icons (like a PDF icon or generic file icon) for non-image files.

## Capabilities

### Modified Capabilities
- doubts-compose-ui: Support device camera photo capture and uniform photo gallery selectors.
- forum-create-ui: Support general file picker attachments (PDF, docx, txt) in addition to images.

## Impact

- `packages/discussions/lib/screens/ask_doubt_form_screen.dart`
- `packages/discussions/lib/screens/doubt_detail_screen.dart`
- `packages/discussions/lib/screens/forum_post_create_screen.dart`
- `packages/discussions/lib/widgets/forum_composer.dart`
