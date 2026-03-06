# Design Doc: LMS Paid Active User Profile Screen (`lms-profile-paid-active`)

## Context

The Profile screen is the personal dashboard for paid active users. It should feel rewarding, informative, and easy to scan. The design is based on the Figma reference for this user type and is broken into five distinct sections arranged vertically.

## Goals / Non-Goals

**Goals:**
- Implement all five sections of the profile page as defined in the Figma reference.
- Use the app's design token system throughout — no fixed colours, sizes, or spacing.
- Pull user data from existing providers wherever possible.

**Non-Goals:**
- Building the destination screens linked from Account & Preferences (Edit Profile, Notifications, Certificates, App Settings). Those are separate changes.
- Backend API integration — mock data only for this change.

## Decisions

### 1. Profile Header
The header is a centered card showing the user's avatar, full name, and a line indicating how long they've been learning (e.g., "Learning with us since August 2025"). A small edit button sits in the top-right corner of the card. The avatar image comes from the user data provider; the card uses the standard shadow card style from the design system.

### 2. Learning at a Glance
A single card titled "Your learning at a glance" contains two parts:
- A three-column stats row (Lessons finished / Tests attempted / Assessments done) separated by thin vertical dividers.
- Two side-by-side insight chips below: one for the user's strongest subject (green tint) and one for the subject needing more attention (amber tint).

Stats values map to fields already in `StudyMomentumDto`.

### 3. Active Courses Carousel
A horizontally scrolling list of course cards, each showing a course icon, name, chapter count, duration, and a progress bar with percentage. The section header includes a "View All" link. Cards are sized to peek at ~1.15 cards so the user knows more are available.

### 4. Recent Learning Activity
A horizontal list of up to five recent activity cards. Each card shows what type of content was consumed (video, test, lesson, assessment), the title, whether it was completed or in progress, and supporting detail (score or progress percentage, time since activity). A new mock provider supplies this data.

### 5. Account & Preferences
A vertically stacked list of settings rows inside a card: Edit Profile, Notifications, Your Certificates, App Settings, and Logout. Each row has an icon, a label, and a right-pointing chevron. The Logout row uses the error (red) colour to distinguish it from the rest.

## Risks / Trade-offs

- **Image loading**: Profile avatars load from a URL. The widget falls back gracefully to the user's initials if no image is available.
- **Dark mode**: All colours use the design token system, so dark mode adaptation is automatic.
