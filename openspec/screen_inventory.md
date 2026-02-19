# Flutter Screen Inventory: LMS Coaching App
## Source: Figma Make React Design → Cortex Flutter SDK

This is a **JEE/NEET coaching institute LMS** with three user states and 5 nav tabs.
Each screen will be one OpenSpec change, implemented one at a time.

---

## App Overview

| Dimension | Detail |
|---|---|
| **App Type** | Mobile-first LMS (Learning Management System) |
| **Target** | JEE/NEET coaching institute students |
| **User States** | Non-Paid, Paid New User, Paid Active User |
| **Nav Tabs** | Home, Study, Explore, Profile + fullscreen sub-screens |
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
| `AppBadge` | Status badge (Completed, Pending, Locked, Live) |
| `AppProgressBar` | Standalone progress bar with label |
| `AppSearchBar` | Styled search input field |
| `AppTabBar` | Bottom navigation bar (5 tabs) |
| `AppSubjectChip` | Subject-colored filter chip |
| `AppAvatarImage` | Circular user avatar with fallback |
| `AppBannerCarousel` | Auto-scrolling image banner |

---

## Navigation Structure

```
App Root
├── BottomNavBar (Home / Study / Explore / Profile)
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
    ├── ExamReview (post-exam review)
    ├── ReviewAnalytics (analytics charts)
    ├── ReviewAnswerDetail (per-question review)
    ├── ForumMain (question list per course)
    ├── DiscussionForumDetail (Q&A thread)
    ├── CreateQuestion (forum question composer)
    ├── NotificationsScreen
    ├── InsightsScreen (learning analytics)
    ├── OverallPerformanceScreen
    ├── SubjectWisePerformanceScreen
    ├── CertificatesScreen (certificate list)
    ├── CertificatePreview (certificate viewer)
    ├── EditProfileScreen
    ├── AppSettingsScreen
    └── StudyTipsDetailScreen
```

---

## Screen Queue (Prioritized Implementation Order)

Each screen = one OpenSpec change. Priority is based on user journey criticality.

### Phase 1 — Foundation (Design Tokens + Navigation Shell)
| # | Change Name | Screens | New Tokens/Primitives |
|---|---|---|---|
| 1 | `lms-design-tokens` | — | `card`, `border`, `SubjectColors`, `BadgeColors` tokens in `DesignConfig` |
| 2 | `lms-primitives` | — | `AppBadge`, `AppSearchBar`, `AppTabBar`, `AppSubjectChip` |
| 3 | `lms-navigation-shell` | App shell + BottomTabBar | Route management in `app/` |

### Phase 2 — Core Paid Active User Flow
| # | Change Name | Screen(s) | Notes |
|---|---|---|---|
| 4 | `lms-home-paid-active` | PaidActiveHome | Dashboard with TodaySnapshot, StudyMomentum, QuickAccess |
| 5 | `lms-study-course-list` | StudyPage (course list) | Search bar + content filter chips + course cards |
| 6 | `lms-study-chapters-list` | ChaptersListPage | Chapter accordion, progress per chapter |
| 7 | `lms-study-chapter-detail` | ChapterDetailPage | Lesson items (video/pdf/assessment/test) |
| 8 | `lms-lesson-detail` | LessonDetailScreen | Text/PDF lesson reader + doubt chat trigger |
| 9 | `lms-video-lesson` | VideoLessonDetailScreen | Video player + bookmarks + notes |

### Phase 3 — Assessment & Testing
| # | Change Name | Screen(s) | Notes |
|---|---|---|---|
| 10 | `lms-test-detail` | TestDetailScreen | Test overview, rules, start button |
| 11 | `lms-assessment-detail` | AssessmentDetailScreen | MCQ test flow with timer |
| 12 | `lms-exam-review` | ExamReviewScreen | Post-test score summary |
| 13 | `lms-review-analytics` | ReviewAnalyticsScreen | Charts: subject-wise, time-spent |
| 14 | `lms-review-answer-detail` | ReviewAnswerDetailScreen | Per-question review with explanation |

### Phase 4 — Live Classes
| # | Change Name | Screen(s) | Notes |
|---|---|---|---|
| 15 | `lms-live-class-lobby` | LiveClassLobby | Pre-class countdown + participant count |
| 16 | `lms-live-class` | LiveClassScreen | Full interactive live class screen |

### Phase 5 — Community & Forum
| # | Change Name | Screen(s) | Notes |
|---|---|---|---|
| 17 | `lms-forum-main` | ForumCourseSelection + ForumMainPage | Course selector + question list |
| 18 | `lms-forum-thread` | DiscussionForumDetailScreen | Thread with replies + reply input |
| 19 | `lms-forum-create` | CreateQuestionPage | Question composer |

### Phase 6 — Profile, Analytics & Settings
| # | Change Name | Screen(s) | Notes |
|---|---|---|---|
| 20 | `lms-profile-paid-active` | ProfilePage | Full profile with stats, badges, courses |
| 21 | `lms-insights` | InsightsScreen + OverallPerformance + SubjectWise | Analytics screens |
| 22 | `lms-certificates` | CertificatesScreen + CertificatePreview | Certificate PDFs |
| 23 | `lms-notifications` | NotificationsScreen | Alert list |
| 24 | `lms-settings` | AppSettingsScreen + EditProfileScreen | Settings, edit profile |
| 25 | `lms-study-tips` | StudyTipsDetailScreen | Article-style study tip reader |

### Phase 7 — Upsell & Onboarding Variants
| # | Change Name | Screen(s) | Notes |
|---|---|---|---|
| 26 | `lms-home-non-paid` | NonPaidHome | Upsell hero, benefits, limited access |
| 27 | `lms-home-paid-new` | PaidNewHome | Onboarding hero + first lesson CTA |
| 28 | `lms-explore-paid` | ExplorePage | Full explore with study tips & top learners |
| 29 | `lms-explore-non-paid` | NonPaidExplorePage | Preview with upgrade prompts |
| 30 | `lms-profile-variants` | NonPaidProfile + PaidNewProfile | Onboarding variants |

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
