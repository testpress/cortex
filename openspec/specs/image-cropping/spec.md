# image-cropping Specification

## Purpose
TBD - created by archiving change add-image-cropping. Update Purpose after archive.
## Requirements
### Requirement: Image Cropping Service
The system SHALL provide a programmatic service API (`AppImageCropper`) to invoke the image cropping interface and manage output file retrieval.
- **Input**: The service SHALL accept an optional `ImageCropper` instance for dependency injection and testing, and its `crop` method SHALL accept a `BuildContext` and a valid source image file path (`imagePath`).
- **Validation**: If the source file at `imagePath` does not exist, the service SHALL return `null`.
- **Theming**: The cropper SHALL apply a dedicated dark photo studio theme with accessible high-contrast colors (`#18181B` surface, `#FAFAFA` text), status and navigation bar brightness handling, and brand primary accent (`Design.of(context).colors.primary`).
- **Error Handling**: If an unexpected exception occurs during cropping, the service SHALL capture the exception to Sentry with a `component: app_image_cropper` tag and return `null`.
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

#### Scenario: Platform or plugin exception captured to Sentry
- **WHEN** `AppImageCropper().crop(context, imagePath: path)` encounters an unhandled platform or plugin exception
- **THEN** the exception is captured to Sentry with the `component: app_image_cropper` tag and the method safely returns null

