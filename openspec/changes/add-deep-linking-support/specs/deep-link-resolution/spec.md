## ADDED Requirements

### Requirement: External and Notification URL Normalization
The system SHALL provide a `DeepLinkHandler` to parse incoming URLs (from push notifications or external deep links) and normalize them into valid internal application routes before dispatching navigation.

- **URL Sanitization**: The handler SHALL handle both absolute URLs (e.g. `https://demo.testpress.in/dashboard?source=fcm`) and relative URI paths (e.g. `/dashboard`), stripping query strings, fragments, and trailing slashes.
- **Malformed Input Protection**: If an empty, null, or malformed URL string is provided, the handler SHALL safely return the default route `/home`.

#### Scenario: Parsing absolute URL with query parameters
- **GIVEN** a push notification payload contains URL `https://staging.testpress.in/exams/chapter_content/2054/?content_detail_v2=true&use_htmx_for_partial_views=true`
- **WHEN** the URL is passed to `DeepLinkHandler.resolve(url)`
- **THEN** query parameters and host SHALL be discarded
- **AND** the handler SHALL return `/study/lesson/2054`

#### Scenario: Parsing empty or invalid URL
- **GIVEN** a null or empty URL string
- **WHEN** passed to `DeepLinkHandler.resolve(url)`
- **THEN** the handler SHALL return `/home`

---

### Requirement: Route Normalization Mapping
The system SHALL map legacy web endpoints and notification destination patterns to matching Cortex internal routes using a declarative list of pattern-to-target rules.

- **Declarative Rule Table**: URL patterns SHALL be defined declaratively (e.g., `/courses/:courseId/contents/:id` → `/study/lesson/:id`) and evaluated by a path pattern matcher.
- **Dashboard / Home**:
  - Paths `/dashboard`, `/learn`, `/leaderboard`, or root `/` SHALL map to `/home`.
- **Authentication**:
  - `/login` SHALL map to `/login`.
  - `/activate` or `/register` SHALL map to `/signup`.
- **Courses & Lessons (Video / PDF / Notes)**:
  - `/courses/:courseId/contents/:contentId` SHALL map to `/study/lesson/:contentId`.
  - `/courses/:courseId/:chapterId/:contentId` SHALL map to `/study/lesson/:contentId`.
  - `/chapters/:chapterId/:contentId` SHALL map to `/study/lesson/:contentId`.
  - `/exams/chapter_content/:contentId` SHALL map to `/study/lesson/:contentId` (intentional: legacy exam chapter content is rendered by the unified study lesson player).
  - `/courses/:courseId/chapters/:chapterId` SHALL map to `/study/course/:courseId/chapters/:chapterId`.
  - `/courses/:courseId/chapters` SHALL map to `/study/course/:courseId/chapters`.
  - `/courses` SHALL map to `/study`.
- **Store & Products**:
  - `/products/:slug` or `/store/product/:slug` SHALL map to `/store/product/:slug`.
  - `/products` or `/store` SHALL map to `/store`.
- **Exams**:
  - `/exams`, `/exams/available`, `/exams/upcoming`, `/exams/history` SHALL map to `/exams`.
- **Discussions / Forum**:
  - `/p/:slug` or `/posts/:slug` or `/discussions/forum/posts/:slug` SHALL map to `/home/discussions/forum/posts/:slug`.
  - `/discussions/forum` or `/posts` or `/p` SHALL map to `/home/discussions/forum`.
  - `/discussions/doubts/:id` SHALL map to `/home/discussions/doubts/:id`.
  - `/discussions/doubts` SHALL map to `/home/discussions/doubts`.
- **Profile**:
  - `/profile/:sub` or `/user/:sub` (for notifications, edit, settings, login-activity, certificates) SHALL map to `/profile/:sub`.
- **AI**:
  - `/ai/:sub` (for chat, history) SHALL map to `/ai/:sub`.

#### Scenario: Deep linking to chapter content / lesson
- **GIVEN** incoming URL `/exams/chapter_content/2054`
- **WHEN** resolved by `DeepLinkHandler`
- **THEN** the returned route SHALL be `/study/lesson/2054`

#### Scenario: Deep linking to dashboard
- **GIVEN** incoming URL `/dashboard`
- **WHEN** resolved by `DeepLinkHandler`
- **THEN** the returned route SHALL be `/home`

#### Scenario: Deep linking to product
- **GIVEN** incoming URL `/products/upsc-test-series-2026`
- **WHEN** resolved by `DeepLinkHandler`
- **THEN** the returned route SHALL be `/store/product/upsc-test-series-2026`

#### Scenario: Deep linking to forum post
- **GIVEN** incoming URL `/p/important-exam-guidelines`
- **WHEN** resolved by `DeepLinkHandler`
- **THEN** the returned route SHALL be `/home/discussions/forum/posts/important-exam-guidelines`

---

### Requirement: Feature and Tab Availability Validation
The system SHALL validate resolved routes against active tabs and feature flags before navigating, falling back to safe alternate routes or `/home` if a feature or tab is disabled for the current institute build or configuration.

- **Exams Tab**: If a route targets `/exams` and `AppConfig.showExamTab` is false, it SHALL fall back to `/study`.
- **Profile Tab**: If a route targets `/profile` or `/profile/*` and `AppConfig.showProfileTab` is false, it SHALL fall back to `/home`.
- **Store Tab**: If a route targets `/store` or `/store/*` and `settings?.storeEnabled` is false, it SHALL fall back to `/home`.
- **AI Tab**: If a route targets `/ai` or `/ai/*` and `settings?.enableAiChatbot` is false, it SHALL fall back to `/home`.
- **Certificates**: If a route targets `/profile/certificates` and `AppConfig.showCertificate` is false, it SHALL fall back to `/profile`.

#### Scenario: Navigating to disabled store link
- **GIVEN** an institute with `storeEnabled == false`
- **WHEN** a store notification deep link `/store/product/upsc` is dispatched
- **THEN** navigation SHALL fall back to `/home`

#### Scenario: Navigating to disabled exams link
- **GIVEN** an institute build where `AppConfig.showExamTab == false`
- **WHEN** an exam notification deep link `/exams` is dispatched
- **THEN** navigation SHALL fall back to `/study`

#### Scenario: Navigating to disabled profile link
- **GIVEN** an institute build where `AppConfig.showProfileTab == false`
- **WHEN** a profile notification deep link `/profile/settings` is dispatched
- **THEN** navigation SHALL fall back to `/home`

---

### Requirement: Safe Navigation Fallback
The system SHALL NOT fail with unhandled route exceptions (`GoException: no routes for location: ...`) when receiving unsupported or unknown web URLs.

- **Fallback Destination**: Any path that does not match a recognized route pattern SHALL fall back to `/home`.
- **Logging**: The system SHALL log an informative debug message indicating the unsupported deep link was redirected to fallback.

#### Scenario: Unrecognized URL path
- **GIVEN** incoming URL `https://staging.testpress.in/unknown/feature/path`
- **WHEN** resolved by `DeepLinkHandler`
- **THEN** the handler SHALL return `/home`
- **AND** GoRouter SHALL navigate smoothly to the home screen without error
