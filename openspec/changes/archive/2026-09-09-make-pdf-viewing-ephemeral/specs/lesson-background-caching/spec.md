## REMOVED Requirements

### Requirement: Silent Background Caching for PDFs
**Reason**: Silent background downloading of full PDF files during metadata fetch leads to accidental offline access and fills device storage without user consent.
**Migration**: PDF files for online viewing are streamed/downloaded ephemerally on demand. Persistent offline caching is strictly managed via explicit user downloads in `DownloadsProvider`.
