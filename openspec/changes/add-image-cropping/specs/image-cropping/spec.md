## ADDED Requirements

### Requirement: Image Cropping Service
The system SHALL provide a programmatic service API (`AppImageCropper`) to invoke the image cropping interface and manage output file retrieval.
- **Input**: The service SHALL accept an optional `ImageCropper` instance for dependency injection and testing, and its `crop` method SHALL accept a `BuildContext` and a valid source image file path (`imagePath`).
- **Validation**: If the source file at `imagePath` does not exist, the service SHALL return `null`.
- **Theming**: The cropper SHALL apply surface, text, and active control colors from `Design.of(context)` to platform UI settings.
- **Localization**: The cropper SHALL use `L10n.of(context).cropImage` for toolbar title display.
- **Output**: The service SHALL return a `Future<String?>` containing the path to the cropped image file if confirmed, or `null` if cancelled by the user.

#### Scenario: Programmatic crop invocation succeeds
- **WHEN** `AppImageCropper().crop(context, imagePath: path)` is called with an existing file and the user confirms the crop
- **THEN** the returned future completes with the file path of the cropped image

#### Scenario: Programmatic crop invocation cancelled
- **WHEN** `AppImageCropper().crop(context, imagePath: path)` is called and the user cancels or dismisses the crop screen
- **THEN** the returned future completes with null

#### Scenario: Non-existent source file
- **WHEN** `AppImageCropper().crop(context, imagePath: path)` is called with a path that does not exist on disk
- **THEN** the returned future completes with null without launching the cropper
