# Proposal: Home Screen Sidebar Menu (`lms-home-drawer`)

## Problem
The current `DashboardHeader` contains a hamburger menu icon that is not functional. Users need a persistent navigation drawer to access secondary features such as Analytics, Bookmarks, Profile, and Settings, as well as system controls like Theme Switching and Logout.

## Proposed Solution
Implement a high-fidelity `AppDrawer` component in `packages/core` and integrate it with the `DashboardHeader` in `packages/courses`. The drawer will follow the design and section organization defined in the design specifications, ensuring a custom, platform-agnostic look and feel that aligns with the Cortex design system.

## Key Features
- **Sectioned Navigation**: 
  - Section 1: Learning tools (Bookmarks, Posts, Analytics, Forum, Doubts, Custom Exam, Reports).
  - Section 2: Account management (Profile, Settings, Login Activity, Logout).
  - Section 3: App info & System (Privacy, Theme Toggle, Version).
- **Custom Visuals**: Custom backdrop and drawer slide transitions to avoid default platform-specific behaviors.
- **Theme Support**: Full integration with the Design System for light/dark mode variants.
- **Semantic Typography**: Usage of `AppText` roles for labels and headers.

## Impact
- **Packages**: `core` (new widget), `courses` (integration).
- **User Experience**: Provides access to essential navigation items that were previously unreachable through a custom-built, brand-consistent interface.
