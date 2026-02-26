# Design: Home Screen Sidebar Menu (`lms-home-drawer`)

## Overview
The `AppDrawer` is a custom-built side navigation component. Unlike the standard Material `Drawer`, it is designed to be platform-agnostic, using custom animations and the Cortex design system tokens for all visual attributes.

## Visual Design

### Layering & Layout
- **Backdrop**: A full-screen overlay with a semi-transparent black color (`Colors.black54` or equivalent from tokens).
- **Drawer Container**:
  - **Width**: `design.layout.drawerWidth` (default: `280px`).
  - **Height**: Full screen height (must overlay bottom navigation).
  - **Background**: `design.colors.surface` or `design.colors.card` (consistent with dashboard headers).
  - **Shadow**: `BoxShadow` with large blur radius and high spread to separate it from the content layer.
  - **Border**: 1px solid border on the right edge in light mode for crisp definition.

### Sections & Hierarchy
The drawer is divided into three distinct vertical sections separated by a thin divider (`design.colors.border`).

1. **Section 1: Learning Tools**
   - Items: Bookmark, Posts, Analytics, Forum, Doubts, Custom Exam, Your Report.
2. **Section 2: Account & Settings**
   - Items: Profile, App Settings, Login Activity, Logout (Highlight with `design.colors.error`).
3. **Section 3: App Status & System**
   - Items: Privacy Policy, Theme Toggle (Light/Dark), Version Info (Disabled/Label-only).

### Typography & Iconography
- **Header**: Use `AppText.title("Menu")`.
- **Labels**: Use `AppText.body()` for item labels.
- **Icons**: Use `LucideIcons` (consistent with the rest of the app). Size set to `20px`.
- **Colors**:
  - Labels: `design.colors.textPrimary`.
  - Icons: `design.colors.textSecondary`.
  - Colors (Logout): `design.colors.error`.

## Design Layout Tokens
| Token | Value | Description |
|-------|-------|-------------|
| `drawerWidth` | `280.0` | Base width of the home navigation drawer. |
| `maxDrawerWidth` | `400.0` | Maximum width allowed when using responsive sizing. |

## Interaction & State
- **Trigger**: Tapping the hamburger icon in `DashboardHeader`.
- **Animation**: 
  - Backdrop: Fade-in.
  - Drawer: Slide-in from left.
- **Layering**: The drawer MUST be placed above the `AppTabBar` (bottom navigation) in the widget hierarchy. This is achieved by hosting the drawer in the `AppShell` level.

## Component Integration
- **`AppDrawer` (core)**: Stateless widget that accepts a list of sections.
- **`AppShell` (core)**: Updated to accept an optional `drawer` widget and display it in a `Stack` over the main content and navigation.
- **`appRouter` (testpress)**: Configured to pass the `AppDrawer` into the `AppShell`, using Riverpod to sync state between the `DashboardHeader` and the `AppShell`.
- **`DashboardHeader` (courses)**: Continues to manage the drawer state via `isHomeDrawerOpenProvider`.
