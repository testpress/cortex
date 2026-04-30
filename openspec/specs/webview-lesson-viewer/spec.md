# webview-lesson-viewer Specification

## Purpose
TBD - created by archiving change integrate-lesson-detail-ui. Update Purpose after archive.
## Requirements
### Requirement: Single-Root HTML Rendering
All rich-text and embed contents MUST be rendered through a unified `WebView` to ensure layout fidelity for iframes and complex HTML.

#### Scenario: Rendering HTML Notes
- **WHEN** A lesson has type `notes`
- **THEN** The content is rendered inside a WebView with CSS injected to match the app's primary typography.

#### Scenario: Rendering Video Embeds
- **WHEN** A lesson has type `embedContent`
- **THEN** The WebView player is used instead of the native DRM player.

