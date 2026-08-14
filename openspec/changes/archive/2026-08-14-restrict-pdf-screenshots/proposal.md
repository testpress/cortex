## Why

Currently, users can take screenshots while viewing PDF materials within the app. To protect intellectual property and prevent unauthorized distribution of premium content, we need to restrict screenshot capabilities when the PDF viewer is active.

## What Changes

- Add the `no_screenshot` package to the project dependencies.
- Wrap the main PDF viewer widget with the `SecureWidget` to automatically block screenshots while the viewer is active.
- Display a secure overlay (managed natively by the package) when the app is backgrounded while viewing a PDF.

## Capabilities

### New Capabilities
- `secure-pdf-viewer`: Protect PDF content by preventing screenshots on supported mobile platforms (Android/iOS).

### Modified Capabilities


## Impact

- **Dependencies**: Adds `no_screenshot` package.
- **Affected Code**: `packages/courses/lib/widgets/lesson_detail/pdf_viewer.dart` (`AppPdfViewer` widget).
- **User Experience**: Users will not be able to take screenshots while viewing a PDF; attempting to do so will result in a blank or protected image, depending on the OS level behavior.
