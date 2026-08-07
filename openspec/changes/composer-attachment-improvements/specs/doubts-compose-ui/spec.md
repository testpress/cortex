## MODIFIED Requirements

### Requirement: Rich Text Editor
The system SHALL provide a rich-text editor for the doubt content to support structured questions.
- **Formatting**: The editor SHALL support bold, italic, bulleted lists, and code blocks.
- **Media**: The editor SHALL support picking up to 3 images from the photo library/gallery or capturing directly from the device's camera.
- **Inline Embedding**: Any selected or captured images SHALL be uploaded to the doubt image endpoint and embedded inline as `<img src="..." />` tags within the description HTML.
- **Validation**: The validation of the description field SHALL allow submission if either the plain-text representation is not empty or at least one image attachment is selected.

#### Scenario: Applying formatting
- **WHEN** the user selects text and taps the "Bold" toolbar action
- **THEN** the selected text SHALL be rendered in bold weight

#### Scenario: Attaching images from gallery
- **WHEN** the user taps the image toolbar button and selects images
- **THEN** the system SHALL show the images in the attachment preview list

#### Scenario: Capturing image from camera
- **WHEN** the user taps the camera toolbar button and captures a photo
- **THEN** the system SHALL add the captured photo to the attachment preview list

#### Scenario: Submitting with images only
- **WHEN** the user has provided a title, selected a category, and selected at least one image attachment without any text description
- **THEN** the system SHALL enable the submit button
