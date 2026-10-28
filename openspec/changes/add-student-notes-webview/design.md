## Context

Testpress provides a student notes diary feature on the web (`/student-diary/my-notes/`) where learners can create notes with rich text (TipTap), organize notes into folders, tag concepts, and attach images. When queried with `?testpress_app=1`, the web interface hides portal navigation and renders an edge-to-edge view tailored for mobile.

Cortex embeds this interface using `AppWebView`, authenticated via single-use presigned SSO tokens (`userRepo.getAuthenticatedSsoUrl()`). This connects the mobile app to the existing notes service with zero duplicate editor maintenance.

## Goals / Non-Goals

**Goals:**
- Provide full access to Testpress Student Notes within Cortex via an authenticated `AppWebView`.
- Authenticate the WebView automatically using single-use presigned SSO tokens via `userRepo.getAuthenticatedSsoUrl()`.
- Add a clean navigation entry point in `DashboardDrawer` gated by `InstituteSettings.studentNotesEnabled`.
- Provide a native `AppHeader` matching Cortex UI guidelines, with back navigation support.
- Support device back gestures and hardware back buttons to navigate web history before exiting the screen.
- Ensure camera and storage permissions are available to the WebView for note attachments/images.
- Delegate external links and document downloads to the device's system browser.

**Non-Goals:**
- Offline note caching or background SQLite replication (WebView delegates persistence to the web app's local storage and backend sync).

## Decisions

### 1. Reuse Authenticated SSO URL Builder in UserRepository
* **Decision**: Use `UserRepository.getAuthenticatedSsoUrl(nextPath: '/student-diary/my-notes/?testpress_app=1', domainUrl: settings?.domainUrl)` to resolve the notes URL.
* **Rationale**: Reuses the tested SSO pattern established in student messaging, ensuring consistent domain fallback and path encoding.

### 2. State & Provider Management with Riverpod Codegen
* **Decision**: Define `@riverpod Future<String> studentNotesUrl(Ref ref)` in `packages/testpress/lib/screens/student_notes_screen.dart`.
* **Rationale**: Conforms to Cortex architectural rules (prefer `@riverpod` codegen for application-state providers). Automatically requests fresh SSO tokens on re-entry.

### 3. Screen Structure and PopScope History Handling
* **Decision**: Wrap `StudentNotesScreen` in `PopScope` checking `controller.canGoBack()`.
* **Rationale**: If a student navigates into a folder, views note details, or enters an edit view, pressing the back button navigates back within the web view rather than unexpectedly popping out of the screen.

### 4. Client-Side Soft Keyboard Inset Adaptation
* **Decision**: Apply `MediaQuery.viewInsetsOf(context).bottom` padding to the `Column` hosting `AppWebView` inside `AppShell`.
* **Rationale**: Resizes the native WebView platform view when the software keyboard opens, allowing the note editor toolbar and cursor to stay visible above the keyboard.

## Risks / Trade-offs

- **[Risk] Soft Keyboard Overlap**: The virtual keyboard might obscure note editing on some devices.
  - *Mitigation*: Apply `MediaQuery.viewInsetsOf(context).bottom` padding directly to the `AppWebView` container in `StudentNotesScreen`.
- **[Risk] Session Expiration**: If the user remains idle on the screen for hours, the web session could expire.
  - *Mitigation*: Re-entry or error retries re-trigger `studentNotesUrlProvider` with a freshly generated SSO URL, and show `AppErrorView` on load failures.
- **[Risk] External Links Trapping**: Clicking an external link within notes could trap the user inside the embedded WebView.
  - *Mitigation*: Use `onNavigationRequest` to detect non-institute hosts and open them externally with `url_launcher`.
