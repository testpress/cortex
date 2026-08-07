## Context

See proposal.md - Why. Currently, the rich text editors across doubts and forums have mismatched capabilities:
1. `AskDoubtFormScreen` lacked attachment support entirely.
2. `DoubtDetailScreen` reply composer used `FilePicker` (document picker) instead of native photo gallery picker.
3. `ForumPostCreateScreen` only allowed picking images.
4. `ForumEditorToolbar` lacked native camera photo capture.

## Goals / Non-Goals

**Goals:**
- Provide camera photo capture for the doubt composition screen.
- Standardize doubts composers to use `ImagePicker` for picking gallery images.
- Transition `ForumPostCreateScreen` to use `FilePicker` to support PDFs, docx, and txt files.
- Enable `ForumAttachmentPreview` to display correct thumbnails for both images and non-image files.

**Non-Goals:**
- Allowing more than 3 attachments.

## Decisions

### Decision: Update ForumAttachmentPreview to handle non-image files
- **Rationale**: Rendering non-image files directly using `Image.file` crashes or renders nothing. Checking the file extension (e.g., `.pdf`) and falling back to Lucide file icons resolves this.
- **Alternatives considered**: None. Necessary for standard file display.

### Decision: Transition ForumPostCreateScreen from ImagePicker to FilePicker
- **Rationale**: The `file_picker` package supports picking both images and document formats, satisfying the client's request for general attachments.
- **Alternatives considered**: Keeping `ImagePicker` and adding a separate file upload. Rejected as too complex UI-wise.

## Risks / Trade-offs

- **[Risk]** Large file uploads → **[Mitigation]** The server limits the file upload size, and we preserve the limit of 3 attachments.
