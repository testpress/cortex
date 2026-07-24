## Why

Currently, users cannot download PDFs directly from the in-app viewer. This change introduces the ability for users to download PDFs when permitted by the backend (`allow_download`). Additionally, it ensures that all downloaded PDFs and in-app PDFs are consistently watermarked by default.

## What Changes

- Add a download button to the PDF viewer UI.
- The download button will only be visible and enabled if the API response includes `"allow_download": true`.
- When a PDF is downloaded, a watermark is unconditionally applied to the saved file.
- **Cleanup**: Completely remove the previous backend configuration check for watermarks. Watermarks will now always display in the in-app PDF viewer by default.

## Capabilities

### New Capabilities
- `pdf-downloads`: Introduce a conditional download action within the PDF viewer that checks the `allow_download` flag and stamps a watermark on the downloaded file.

### Modified Capabilities
- `pdf-downloads`: The `allow_download` flag logic is implemented to control the visibility and functionality of the download button.
- `pdf-watermarking`: The condition for applying watermarks in-app is removed, meaning in-app watermarking is always on. When a user downloads the PDF, the watermark is unconditionally stamped onto the downloaded file.

## Impact

- **UI**: PDF viewer screen will gain a new download action button.
- **Watermark Logic**: The condition for applying watermarks in-app is removed, meaning in-app watermarking is always on. When a user downloads the PDF, the watermark is unconditionally stamped onto the downloaded file.
