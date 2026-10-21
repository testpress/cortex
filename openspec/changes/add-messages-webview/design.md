## Context

Testpress provides a student messaging feature on the web (`/messages/`) where learners can converse with staff, send attachments, and view thread updates. The web view adapts for embedded mobile display by stripping standard portal headers and sidebars when queried with `?testpress_app=1`.

Cortex embeds this interface using `AppWebView`, authenticated via single-use presigned SSO tokens. This connects the mobile app to the existing messaging service and preserves standard thread, attachment, and session management.

## Goals / Non-Goals

**Goals:**
- Provide access to Testpress student messaging within Cortex via an authenticated `AppWebView`.
- Authenticate the WebView automatically using single-use presigned SSO tokens (`userRepo.getPresignedSsoUrl()`).
- Add clean navigation entry points in `DashboardDrawer` gated by `InstituteSettings.messagesEnabled`.
- Provide a native `AppHeader` matching Cortex UI guidelines, with back navigation support.
- Support device back gestures and hardware back buttons to navigate web history before exiting the screen.
- Ensure camera and storage permissions are available to the WebView for photo/file attachments.
- Delegate external links and attachment downloads to the device's system browser.

**Non-Goals:**
- Offline message caching or background synchronization.
- Modifying backend message delivery and polling protocols.

## Decisions

### 1. Encapsulate Presigned SSO URL Composition in UserRepository
* **Decision**: Encapsulate domain resolution and presigned SSO URL composition in `UserRepository.getAuthenticatedSsoUrl()` in `packages/core` backed by a pure `buildAuthenticatedSsoUrl()` helper.
* **Rationale**: Moves URL parsing, trailing slash normalization, and `next` parameter encoding out of UI screen files into the platform repository layer where it is reusable across all packages and directly unit testable.
* **Alternatives Considered**: Keeping URL string manipulation in the screen file (discarded due to review feedback and business logic leakage); Direct JWT header injection via `AppWebView.buildHeaders` (discarded because Django templates rely on session cookies and CSRF tokens).

### 2. State & Provider Management with Riverpod Codegen
* **Decision**: Define `@riverpod Future<String> messagesUrl(MessagesUrlRef ref)` using Riverpod code generation in `packages/testpress/lib/screens/messages_screen.dart`.
* **Rationale**: Conforms to repository architectural rule 8 (prefer `@riverpod` codegen for application-state providers). Generates `messagesUrlProvider` with autoDispose semantics, requesting fresh SSO tokens on screen re-entry.
* **Alternatives Considered**: Manual `FutureProvider.autoDispose`. Discarded in favor of project standard `@riverpod` annotations.

### 3. Screen Structure and PopScope History Handling
* **Decision**: Wrap `MessagesScreen` in `PopScope` checking `controller.canGoBack()`.
* **Rationale**: If a student clicks on an attachment or navigates deeper within the web view, tapping the back button should take them back to the messages list rather than popping out of `MessagesScreen` to the dashboard drawer.
* **Alternatives Considered**: Letting system back immediately pop. Results in accidental loss of chat context when viewing media or attachments.

### 4. Permission Configuration
* **Decision**: Pass `permissions: [Permission.camera, Permission.storage, Permission.microphone]` to `AppWebView`.
* **Rationale**: Chat allows students to attach documents or capture photos from camera. `AppWebView` already configures Android's `setOnShowFileSelector` with `FilePicker.pickFiles`.

### 5. Client-Side Soft Keyboard Viewport Adaptation
* **Decision**: Apply `MediaQuery.viewInsetsOf(context).bottom` padding to the `Column` hosting `AppWebView` inside `AppShell`.
* **Rationale**: In Cortex, `AppShell` does not contain Material `Scaffold`'s `resizeToAvoidBottomInset` mechanism. By applying bottom inset padding directly in `MessagesScreen`, the `Expanded` containing `AppWebView` physically shrinks when the software keyboard opens, allowing Android's native WebView platform view to resize and push the chat composer above the keyboard.
* **Alternatives Considered**: Injected JavaScript `scrollIntoView` or CSS manipulation (discarded because the root cause was the Flutter container not resizing the native PlatformView); Material `Scaffold` (forbidden by Cortex design system rules).

## Risks / Trade-offs

- **[Risk] Soft Keyboard Overlap**: The software keyboard might obscure the message input field in the web view on some devices.
  - *Mitigation*: Apply `MediaQuery.viewInsetsOf(context).bottom` padding to the `Column` containing `AppWebView` in `MessagesScreen`.

- **[Risk] SSO Expiration During Long Idle Sessions**: If the user stays idle in the screen for hours, the web session could expire.
  - *Mitigation*: Re-entry or error retries re-trigger `messagesUrlProvider` with a freshly generated SSO URL, and show `AppErrorView` on load failures.
- **[Risk] External Links Trapping**: Clicking an external link within the chat (e.g. an external study resource URL posted by a teacher) could stay inside the embedded WebView.
  - *Mitigation*: Use `onNavigationRequest` to detect non-institute hosts and open them externally with `url_launcher`.

