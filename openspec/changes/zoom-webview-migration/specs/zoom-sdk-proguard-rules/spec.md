## REMOVED Requirements

### Requirement: Zoom SDK ProGuard Preservation
**Reason**: Replaced by in-app Zoom WebView integration (`zoom-webview-join`), rendering native Zoom SDK binaries and custom R8 preservation rules obsolete.
**Migration**: Live classes join via in-app WebView (`ZoomVideoConferenceScreen`), requiring no native Zoom or WebRTC binary keep rules in `app/android/app/proguard-rules.pro`.
