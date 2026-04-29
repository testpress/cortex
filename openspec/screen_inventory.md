# Flutter Screen Inventory: LMS Coaching App
## Reference Implementation Source: [LOCAL_PATH_TO_REACTJS_PROJECT]
> **Note to Agent:** This implementation follows a ReactJS project (Figma Make export) as a reference. If the path above is not set, ask the user for the local location of the ReactJS source.
## Mapping: React (Figma Make) → Cortex Flutter SDK

This is a **JEE/NEET coaching institute LMS** with three user states and 5 nav tabs.
Each screen will be one OpenSpec change, implemented one at a time.

---

## App Overview

| Dimension | Detail |
|---|---|
| **App Type** | Mobile-first LMS (Learning Management System) |
| **Target** | JEE/NEET coaching institute students |
| **User States** | Non-Paid, Paid New User, Paid Active User |
| **Nav Tabs** | Home, Study, Explore, AI Support (Paid Active), Profile + fullscreen sub-screens |
| **Subjects** | Physics, Chemistry, Mathematics, Biology, English |

---

## Design Token Mapping (React → Flutter)

### Colors (existing `DesignColors` → needs extension)

| React Token | Flutter Equivalent | Action Needed |
|---|---|---|
| `bg-primary` (slate-50 / slate-900) | `design.colors.surface` | ✅ Already exists |
| `bg-card` (white / slate-800) | `design.colors.card` | 🔧 Add `card` token |
| `text-primary` (slate-900 / slate-100) | `design.colors.textPrimary` | ✅ Already exists |
| `text-secondary` (slate-600 / slate-400) | `design.colors.textSecondary` | ✅ Already exists |
| `border-primary` (slate-200 / slate-700) | `design.colors.border` | 🔧 Add `border` token |
| Subject colors (purple/emerald/orange/green/pink/blue) | New `SubjectColors` token group | 🔧 Add subject colors |
| Badge colors (completed/pending/locked) | New `BadgeColors` token group | 🔧 Add badge colors |
| Progress bar colors | `design.colors.progressForeground` | ✅ Already exists |

### New Primitives Needed in `packages/core`

| Component | Description |
|---|---|
| `✅ AppBadge` | Status badge (Completed, Pending, Locked, Live) |
| `AppProgressBar` | Standalone progress bar with label |
| `✅ AppSearchBar` | Styled search input field |
| `✅ AppTabBar` | Bottom navigation bar (5 tabs) |
| `✅ AppSubjectChip` | Subject-colored filter chip |
| `AppAvatarImage` | Circular user avatar with fallback |
| `AppBannerCarousel` | Auto-scrolling image banner |

---

## Navigation Structure

```
App Root
├── BottomNavBar (Home / Study / Explore / AI Support / Profile)
│
├── [Home Tab] - 3 variants
│   ├── NonPaidHome → Free trial CTAs + hero
│   ├── PaidNewHome → Onboarding hero + quick setup
│   └── PaidActiveHome → Full dashboard
│
├── [Study Tab] - 3 levels
│   ├── CourseList → course cards + content-type filter
│   ├── ChaptersList → chapter accordion list
│   └── ChapterDetail → individual lesson items
│
├── [Explore Tab] - 2 variants
│   ├── NonPaidExplore → locked content preview
│   └── PaidExplore → full content + study tips
│
├── [AI Support Tab] - Paid Active users only (Sparkles icon)
│   ├── AIAssistantDetailPage → hub: Ask a Doubt, AI Exam, weak topics, recent help
│   ├── AskDoubtScreen → AI chat interface
│   ├── CreatePracticeExamScreen → configure AI practice exam
│   └── Exam execution → TestDetailScreen / QuestionPaperScreen / TestModeExamScreen
│
├── [Profile Tab] - 3 variants
│   ├── NonPaidProfile → sign-up prompt + free preview
│   ├── PaidNewProfile → onboarding checklist
│   └── PaidActiveProfile → stats, courses, badges, certificate
│
└── [Fullscreen Screens] (modal / push navigation)
    ├── LessonDetail (text/PDF lesson reader)
    ├── VideoLessonDetail (video player + notes)
    ├── LiveClassLobby (pre-class waiting room)
    ├── LiveClassScreen (full interactive live class)
    ├── TestDetail (test overview + start)
    ├── AssessmentDetail (in-progress assessment)
    ├── ReviewAnswerDetail (post-exam summary & question review)
    ├── ReviewAnalytics (analytics charts)
    ├── ForumMain (question list per course)
    ├── DiscussionForumDetail (Q&A thread)
    ├── CreateQuestion (forum question composer)
    ├── NotificationsScreen
    ├── CertificatesScreen (certificate list)
    ├── CertificatePreview (certificate viewer)
    ├── EditProfileScreen
    ├── AppSettingsScreen
    └── LogoutDialog (logout confirmation)
```

---

## Screen Queue (Prioritized Implementation Order)

Each screen = one OpenSpec change. Priority is based on user journey criticality.

### Phase 1 — Foundation (Design Tokens + Navigation Shell)
| # | Change Name | Screens | New Tokens/Primitives | Status |
|---|---|---|---|---|
| 1 | `lms-design-tokens` | — | `card`, `border`, `SubjectColors`, `BadgeColors` tokens in `DesignConfig` | ✅ Done |
| 2 | `lms-data-layer` | — | Drift DB, Repositories, Riverpod providers | ✅ Done |
| 3 | `lms-primitives` | — | `AppBadge`, `AppSearchBar`, `AppTabBar`, `AppSubjectChip` | ✅ Done |
| 4 | `lms-navigation-shell` | App shell + BottomTabBar | Route management in `app/` | ✅ Done |

### Phase 2 — Core Paid Active User Flow
| # | Change Name | Screen(s) | Notes | Status |
|---|---|---|---|---|
| 5 | `lms-home-paid-active` | PaidActiveHome | Dashboard with TodaySnapshot, StudyMomentum, QuickAccess | ✅ Done |
| 5.1 | `lms-home-drawer` | MenuDrawer | Home sidebar navigation menu | ✅ Done |
| 6 | `lms-study-course-list` | StudyPage (course list) | Search bar + content filter chips + course cards | ✅ Done |
| 7 | `lms-study-chapters-list` | ChaptersListPage | Chapter accordion, progress per chapter | ✅ Done |
| 8 | `lms-study-chapter-detail` | ChapterDetailPage | Lesson items (video/pdf/assessment/test) | ✅ Done |
| 9 | `lms-lesson-detail` | LessonDetailScreen | Text/PDF lesson reader + doubt chat trigger | ✅ Done |
| 10 | `lms-video-lesson` | VideoLessonDetailScreen | Video player + bookmarks + notes | ✅ Done |

### Phase 3 — Assessment & Testing
| # | Change Name | Screen(s) | Notes | Status |
|---|---|---|---|---|
| 11 | `lms-test-detail` | TestDetailScreen | Test overview, rules, start button | ✅ Done |
| 11.1 | `lms-test-detail-refinement` | — | Refine submission flow (dialogs/overlays) and UI density | ✅ Done |
| 12 | `lms-assessment-detail` | AssessmentDetailScreen | MCQ test flow with timer | ✅ Done |
| 13 | `lms-exam-review` | ReviewAnswerDetailScreen | Post-test summary + Per-question review | ✅ Done |
| 14 | `lms-review-analytics` | ReviewAnalyticsScreen | Charts: subject-wise, time-spent | ✅ Done |

### Phase 4 — Live Classes
| # | Change Name | Screen(s) | Notes | Status |
|---|---|---|---|---|
| 15 | `lms-live-class-lobby` | LiveClassLobby | Pre-class countdown + participant count | ⏳ Pending |
| 16 | `lms-live-class` | LiveClassScreen | Full interactive live class screen | ⏳ Pending |

### Phase 5 — Community & Forum
| # | Change Name | Screen(s) | Notes | Status |
|---|---|---|---|---|
| 17 | `lms-forum-main` | ForumCourseSelection + ForumMainPage | Course selector + question list | ✅ Done |
| 18 | `lms-forum-thread` | DiscussionForumDetailScreen | Thread with replies + reply input | ✅ Done |
| 19 | `lms-forum-create` | CreateQuestionPage | Question composer | ✅ Done |

### Phase 6 — Profile, Settings & Account
| # | Change Name | Screen(s) | Notes | Status |
|---|---|---|---|---|
| 20 | `lms-profile-paid-active` | ProfilePage | Full profile with stats, badges, courses | ✅ Done |
| 21 | `lms-edit-profile` | EditProfileScreen | User profile editing (name, phone, etc) | ✅ Done |
| 22 | `lms-certificates` | CertificatesScreen + CertificatePreview | Certificate PDFs | ✅ Done |
| 23 | `lms-notifications` | NotificationsScreen | Alert list | ✅ Done |
| 24 | `lms-settings` | AppSettingsScreen | App settings, playback, and theme settings | ✅ Done |
| 25 | `lms-logout` | LogoutDialog | Generic logout confirmation dialog | ✅ Done |

### Phase 7 — Upsell & Onboarding Variants
| # | Change Name | Screen(s) | Notes | Status |
|---|---|---|---|---|
| 26 | `lms-home-non-paid` | NonPaidHome | Upsell hero, benefits, limited access | ⏳ Pending |
| 27 | `lms-home-paid-new` | PaidNewHome | Onboarding hero + first lesson CTA | ⏳ Pending |
| 28 | `lms-explore-paid` | ExplorePage | Full explore with study tips & top learners | ✅ Done |
| 29 | `lms-explore-non-paid` | NonPaidExplorePage | Preview with upgrade prompts | ⏳ Pending |
| 30 | `lms-profile-variants` | NonPaidProfile + PaidNewProfile | Onboarding variants | ⏳ Pending |

### Phase 8 — AI Support Tab (Paid Active only)
| # | Change Name | Screen(s) | Notes | Status |
|---|---|---|---|---|
| 31 | `lms-ai-support-hub` | AIAssistantDetailPage | Hub: Ask a Doubt card (green), AI Exam card (orange), weak topics panel, recent help list | ⏳ Pending |
| 32 | `lms-ai-chat` | AskDoubtScreen | AI chat: quick chips (Explain concept, Solve problem, Practice Q's, Study tips), chat history drawer, image upload | ⏳ Pending |
| 33 | `lms-ai-create-exam` | CreatePracticeExamScreen | Configure AI exam: course, scope, chapters/lessons, question source, count, difficulty, attempt mode | ⏳ Pending |
| 34 | `lms-ai-exam-execute` | TestDetailScreen / QuestionPaperScreen / TestModeExamScreen | AI-generated exam execution in Quiz or Test mode | ⏳ Pending |

### Phase 9 — Ask Mentor
| # | Change Name | Screen(s) | Notes | Status |
|---|---|---|---|---|
| 35 | `lms-doubts-list` | DoubtsListScreen | Landing screen — searchable list of doubts, Answered / Unanswered status badges, "Ask a Doubt" CTA | ⏳ Pending |
| 36 | `lms-ask-doubt-form` | AskDoubtFormScreen | Compose doubt: title, rich-text editor (bold/italic/lists/code), category chips, image/PDF upload (max 5 files) | ⏳ Pending |
| 37 | `lms-doubt-detail` | DoubtDetailScreen | Doubt thread: question card, tutor replies with Mentor badge, follow-up reply input | ⏳ Pending |



---

## Mock Data Structure

The React app has rich hardcoded data in `App.tsx`. Key data shapes to model in Dart:

```dart
// Course hierarchy
Course → Subject → Chapter → Lesson(video|pdf|assessment|test)

// Key models
class Course { id, title, subjects[], progress, completedLessons, totalLessons }
class Chapter { id, title, lessonCount, assessmentCount, lessons[] }
class Lesson  { id, title, type, duration, progress, isLocked }
class LiveClass { id, subject, topic, time, faculty, status(completed|live|upcoming) }
class AssessmentQuestion { id, question, options[], correctOption, explanation }
class ForumThread { id, title, description, studentName, timeAgo, status, replies[] }
class Learner  { id, rank, name, points, streakDays, badges[] }
```

These will live in `packages/courses/lib/data/` as mock data files.

---

## Suggested Next Step

Start with change **#1: `lms-design-tokens`** — extend `DesignConfig` with card, border, and subject color tokens. This is the foundation everything else depends on.

Run `/opsx-new` to create the first change.
