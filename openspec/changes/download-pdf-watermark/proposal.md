## Why

Currently, users cannot download PDFs directly from the in-app viewer. This change introduces the ability for users to download PDFs when permitted by the backend (`allow_download`). Additionally, it ensures that in-app PDFs are consistently watermarked, and downloaded PDFs are watermarked conditionally based on the new `watermark_before_download` flag.

## What Changes

- Add a download button to the PDF viewer UI.
- The download button will only be visible and enabled if the API response includes `"allow_download": true`.
- When a PDF is downloaded, a watermark is conditionally applied to the saved file based on the `watermark_before_download` flag.
- **Cleanup**: Completely remove the previous backend configuration check (`enableCoursePdfWatermarking`) for in-app watermarks. Watermarks will now always display in the in-app PDF viewer by default.

## Capabilities

### New Capabilities
- `pdf-downloads`: Introduce a conditional download action within the PDF viewer that checks the `allow_download` flag.

### Modified Capabilities
- `pdf-downloads`: The `allow_download` flag logic is implemented to control the visibility and functionality of the download button.
- `pdf-watermarking`: The condition for applying watermarks in-app is removed, meaning in-app watermarking is always on. When a user downloads the PDF, the watermark is conditionally stamped onto the downloaded file based on `watermark_before_download`.

## Impact

- **UI**: PDF viewer screen will gain a new download action button.
- **Watermark Logic**: The condition for applying watermarks in-app is removed. When a user downloads the PDF, the watermark is stamped onto the downloaded file only if `watermark_before_download` is true.
