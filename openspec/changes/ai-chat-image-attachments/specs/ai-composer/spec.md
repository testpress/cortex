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
