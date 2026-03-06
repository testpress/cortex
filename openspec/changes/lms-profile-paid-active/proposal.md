# Proposal: LMS Paid Active User Profile Screen (`lms-profile-paid-active`)

## Why

The Profile tab in the bottom navigation currently shows a placeholder screen. Paid active users need a personal dashboard where they can see who they are in the app, track their learning progress at a glance, quickly jump back into their active courses, review recent study activity, and manage their account settings — all in one place.

## What Changes

- Add a **Profile Header** showing the user's photo, name, and how long they've been learning.
- Add a **Learning at a Glance** card with three key stats (lessons, tests, assessments) and two insight chips (strongest subject, subject needing focus).
- Add an **Active Courses** horizontal carousel so users can quickly see their enrolled courses and progress.
- Add a **Recent Learning** section showing the last few pieces of content the user engaged with.
- Add an **Account & Preferences** section with links to Edit Profile, Notifications, Certificates, App Settings, and Logout.

## Capabilities

### New Capabilities
- `profile-view`: A full personal dashboard for paid active users, showing identity, stats, courses, activity, and settings access.

### Modified Capabilities
- Navigation: The "Profile" tab now routes to this new screen for paid active users (was a placeholder).

## Impact
- **Packages**: `packages/courses` — new screen and supporting widgets.
- **Data**: Uses existing mock providers; one new provider needed for recent activity.
- **Navigation**: `app_router.dart` updated to route Profile tab to the new screen.
