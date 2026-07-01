## Context
The "Offline Exam" feature is being ported from the old Android SDK to the Flutter Cortex SDK. It allows students to download an exam, complete it without an active internet connection, and sync it back to the backend later. This is critical for users in areas with poor connectivity. The architecture relies on heavy local persistence, resilient sync queues, and caching of web assets.

## Goals / Non-Goals

**Goals:**
- Allow users to download any exam for offline use.
- Safely persist exam structure and user attempts locally.
- Sync offline attempts reliably back to the server within the exam's `endDate` + grace period.
- Serve HTML content (including images and scripts) locally when offline.
- Provide clear UI feedback on the prescreen for downloading and starting offline exams.

**Non-Goals:**
- iOS Support. Offline exams are strictly planned for Android only.
- Preventing sophisticated time-tampering at the OS root level (we rely on the backend for final absolute `endDate` validation).
- Supporting video downloads in this specific offline exam change (we are focusing on exam web assets/images for now).

## Decisions

**1. Global Offline Support**
*Decision:* We will assume all exams support offline mode.
*Rationale:* There is no explicit `isOfflineExam` flag in the backend response for the exam details.

**2. Exam Prescreen UI Layout**
*Decision:* Introduce a vertically stacked primary action button above the existing buttons (Start Online, Resume, Retake).
*Rationale:* It explicitly separates the offline workflow from the online one. 
*Flow:* Shows `[ Download Exam ]` initially. Once fully cached in the local DB, it morphs into `[ Start offline exam ]`.

**3. Unified Exam Architecture**
*Decision:* We will abstract the core exam execution logic into an `ExamRepository` interface, with two concrete implementations: `OnlineExamRepository` and `OfflineExamRepository`. The repository implementation will be passed down via route arguments / navigation, avoiding global state. 
*Rationale:* This prevents "leaky abstractions" where offline logic bleeds into the UI or core widgets. It keeps the UI purely focused on rendering state regardless of network status.

**4. Local Persistence Engine**
*Decision:* Use Drift (SQLite) for storing the exam download cache and answers. The tables will be `OfflineExamDownloadsTable` (storing the questions as a JSON blob) and `OfflineExamAnswersTable` (storing individual user answers). No "dummy attempts" will be saved locally.
*Rationale:* The backend offline sync endpoint accepts a self-contained payload. We don't need to emulate online attempt state in the database, only cache the questions and persist the user's answers.

**5. Grace Period Validation**
*Decision:* Use the exam's absolute `endDate` + `graceDurationForOfflineSubmission` for the deadline.
*Rationale:* This prevents us from needing to build complex local timers. The local app will check if `DateTime.now()` is before the deadline to allow syncing. The backend acts as the ultimate source of truth and will reject late syncs.

**6. Background & Foreground Syncing**
*Decision:* Use `connectivity_plus` for foreground syncing and `workmanager` for background syncing. The background worker will act as a fallback and only be scheduled if foreground sync fails.
*Rationale:* Since this is Android-only, WorkManager is highly reliable for background execution when the network returns. Avoiding redundant scheduling prevents duplicated processing.

**7. HTML Asset Caching & Rendering**
*Decision:* Replace image URLs with local `file://` URIs by substituting the paths during repository data fetch.
*Rationale:* This keeps `AppHtml` clean as a pure rendering widget without needing to read domain providers or intercept requests at the widget level.

## Risks / Trade-offs

- **[Risk] Database Schema Migrations** → *Mitigation:* If the app updates and the local DB schema changes while an exam is pending sync, the data could corrupt. We must write strict, non-destructive migration scripts for the offline attempt tables.
- **[Risk] Local Storage Quotas** → *Mitigation:* We will store all assets in the Application Documents Directory (not cache) to prevent the OS from auto-deleting pending exams when storage is low.
