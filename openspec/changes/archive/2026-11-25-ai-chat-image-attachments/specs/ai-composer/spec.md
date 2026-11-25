## ADDED Requirements

### Requirement: Attachment Picking and Thumbnail Management
The composer SHALL display a plus icon (`+`) attachment trigger action and horizontal thumbnail chips for staged images with a removal control.

#### Scenario: Plus icon triggers attachment selection
- **WHEN** attachments are enabled and less than the maximum limit of 4
- **THEN** composer SHALL display a plus icon (`+`) leading the input text field that triggers `onAttachImage`.

#### Scenario: Maximum attachment limit reached
- **WHEN** 4 attachments are currently staged
- **THEN** composer SHALL hide or disable the plus icon attachment trigger.

#### Scenario: Display staged image preview chips
- **WHEN** one or more images are staged
- **THEN** composer SHALL render image thumbnail previews above the text input field, each with a close/delete button.
- **AND** individual thumbnail previews SHALL be encapsulated in the dedicated `AiAttachmentThumbnail` widget.
- **AND** the thumbnail close button SHALL be visually anchored to the top-trailing corner of the thumbnail while preserving a minimum 48dp touch target.

#### Scenario: Staged image upload failure display
- **WHEN** an attachment upload fails
- **THEN** composer SHALL mark the thumbnail with an error indicator and accessible localized failure label without hardcoding English strings in the provider.

#### Scenario: Tap to retry failed attachment upload
- **WHEN** the user taps an attachment thumbnail in an error state
- **THEN** the composer SHALL invoke the retry callback for that attachment's local identifier.

#### Scenario: Guard input text on keyboard submit with attachment error
- **WHEN** the user submits via keyboard while any staged attachment has an error
- **THEN** composer SHALL not clear the input text or dispatch the send callback.
