## MODIFIED Requirements

### Requirement: Rich Text Editor
The system SHALL provide a rich-text editor for the doubt content to support structured questions.
- **Formatting**: The editor SHALL support bold, italic, bulleted lists, and code blocks.
- **Media**: The editor SHALL support picking up to 3 images from the photo library/gallery or capturing directly from the device's camera.
- **Image Cropping**: Selected or captured images SHALL be cropped using `AppImageCropper` prior to attachment. If cropping succeeds, the cropped image SHALL be added to the attachment list. If cropping is cancelled, the image SHALL NOT be attached.
- **Sequential Multi-Crop UX**: When multiple images are selected from the photo gallery, each image SHALL be cropped sequentially. If the user cancels cropping for an image, the system SHALL abort cropping the remaining images in the batch.
- **Processing Feedback**: While an image is being processed or cropped, the system SHALL display an `AppLoadingIndicator` overlay.
- **Inline Embedding**: Any selected or captured images SHALL be uploaded to the doubt image endpoint and embedded inline as `<img src="..." />` tags within the description HTML.
- **Validation**: The validation of the description field SHALL allow submission if either the plain-text representation is not empty or at least one image attachment is selected.

#### Scenario: Applying formatting
- **WHEN** the user selects text and taps the "Bold" toolbar action
- **THEN** the selected text SHALL be rendered in bold weight

#### Scenario: Attaching images from gallery with cropping
- **WHEN** the user taps the image toolbar button and selects images
- **THEN** the system SHALL present the cropper for each selected image sequentially
- **AND** the system SHALL add successfully cropped images to the attachment preview list

#### Scenario: Capturing image from camera with cropping
- **WHEN** the user taps the camera toolbar button, captures a photo, and completes cropping
- **THEN** the system SHALL add the cropped photo to the attachment preview list

#### Scenario: Cancelling image crop
- **WHEN** the user picks or captures an image but cancels the crop operation
- **THEN** the system SHALL NOT add the image to the attachment preview list

#### Scenario: Aborting subsequent crops on cancel in batch
- **WHEN** the user selects multiple images from the gallery and cancels cropping on one of the images
- **THEN** the system SHALL abort the remaining crop operations in that batch
- **AND** the system SHALL NOT launch croppers for any remaining images

#### Scenario: Showing loading overlay during crop processing
- **WHEN** an image selection or crop operation is in progress
- **THEN** the system SHALL display an `AppLoadingIndicator` overlay until processing completes or is cancelled

#### Scenario: Submitting with images only
- **WHEN** the user has provided a title, selected a category, and selected at least one image attachment without any text description
- **THEN** the system SHALL enable the submit button
