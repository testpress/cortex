## 1. Rich Editor Layout Changes

- [x] 1.1 Add onCameraPick callback to ForumEditorToolbar and _ToolbarButtons
- [x] 1.2 Render camera button in composer editor toolbar using LucideIcons.camera
- [x] 1.3 Add dynamic file type thumbnail rendering in ForumAttachmentPreview for PDFs and documents

## 2. Ask Doubt Form Screen

- [x] 2.1 Enable camera/image callbacks and attachments state inside AskDoubtFormScreen
- [x] 2.2 Add ForumAttachmentPreview list to the AskDoubtFormScreen layout
- [x] 2.3 Update submit logic to upload attachments to repository and append inline HTML img tags

## 3. Doubt Detail Screen Alignment

- [x] 3.1 Replace FilePicker with ImagePicker in DoubtDetailScreen reply composer
- [x] 3.2 Update image selection logic to use pickMultiImage

## 4. Forum Post Create Screen

- [x] 4.1 Replace ImagePicker with FilePicker in ForumPostCreateScreen
- [x] 4.2 Support picking and previewing multiple file types (PDF, docx, txt)
- [x] 4.3 Fix title text input content padding alignment

## 5. File Upload Pipeline & Error Handling

- [x] 5.1 Implement generic uploadFile method in DataSource, HttpDataSource, and MockDataSource
- [x] 5.2 Differentiate upload pipeline and format links as <a> anchor tags for files in forum providers
- [x] 5.3 Wrap pickers in try-catch blocks to catch PlatformExceptions and surface them via AppToast
- [x] 5.4 Centralize image file extension checks under AttachmentUtils.isImageFile
- [x] 5.5 Rename confusing isFile parameter in editor toolbar to showFileIcon
