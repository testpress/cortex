## 1. Data Layer & Providers

- [x] 1.1 Create `currentUserStatsProvider` to fetch the user's learning metrics.
- [x] 1.2 Ensure mock user data (including avatar URL) is set up correctly.
- [x] 1.3 Create `enrolledCoursesProvider` to supply data for the active courses carousel.
- [x] 1.4 Create `recentActivityProvider` returning a mock list of recent learning activity items.

## 2. Profile Screen Widgets

- [x] 2.1 Build `ProfileHeader` — centered avatar, user name, membership subtext, and a small edit icon in the top-right corner of the card.
- [x] 2.2 Build `ProfileLearningSnapshot` — three-column stats row with dividers, plus strongest-subject and needs-focus insight chips below.
- [x] 2.3 Build `EnrolledCoursesSection` — horizontal course carousel with course icon, name, chapter count, duration, progress bar, and percentage. Include a "View All" link in the header.
- [x] 2.4 Build `RecentActivitySection` — horizontal list of up to five activity cards, each showing type icon, status pill, title, and a context line (score or watch progress + time ago).
- [x] 2.5 Build `AccountPreferencesSection` — vertically stacked rows for Edit Profile, Notifications, Certificates, App Settings, and Logout, styled consistently as a settings card.

## 3. Screen Assembly

- [x] 3.1 Assemble `ProfilePage` with a white sticky title bar and a grey body background.
- [x] 3.2 Connect `currentUserProvider`, `currentUserStatsProvider`, and `enrolledCoursesProvider` with loading and error states.
- [x] 3.3 Connect `recentActivityProvider` and render `RecentActivitySection` in the page.
- [x] 3.4 Add `AccountPreferencesSection` as the final section in `ProfilePage`.

## 4. Navigation & Polish

- [x] 4.1 Export `ProfilePage` and wire it into the router for the Profile tab.
- [x] 4.2 Replace all hardcoded colours and sizes with design tokens throughout all profile widgets.
- [x] 4.3 Final visual check against the Figma reference for spacing, sizing, and typography.
- [x] 4.4 Wire the Home drawer "Profile" menu item to navigate to `ProfilePage`.
