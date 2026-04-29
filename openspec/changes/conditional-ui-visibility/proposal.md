# Proposal: Conditional UI Visibility based on Client Configuration

## Problem
Currently, the LMS Home and Study screens have fixed layouts that display all sections (Schedule, Quick Access, Category buttons) regardless of the client/institute configuration. Some clients require a more streamlined UI where certain features are hidden. Additionally, there is a requirement to display custom institute branding (banners) in the top app bar for specific subdomains, which is currently not implemented.

## What Changes
- Introduction of feature-gating logic to show/hide UI sections based on client configuration.
- Implementation of a custom `InstituteBanner` widget with support for local assets and adaptive dark mode.
- Unique scrolling behavior for specialized institutes (Sticky Banner + Scrolling Header).
- Custom dashboard section prioritization (Brilliant Pala specific order).
- Domain-specific layout adjustment using `customTopPadding` in the core dashboard header.

## Capabilities

### New Capabilities
- `institute-banner`: Implementation of a client-specific branding banner with local asset support and adaptive themes.
- `domain-specific-scrolling`: A layout engine that differentiates between sticky banners and fixed headers based on client type.

### Modified Capabilities
- `lms-home-paid-active`: Full section reordering and gating support.
- `study-curriculum-list`: Conditional visibility for category shortcut buttons.

## Impact
- **Packages**: `packages/testpress` (Layout & ordering), `packages/core` (Branding & Global Header), `packages/courses` (Study UI gating).
- **Architecture**: Zero impact on other subdomains due to flag-gated isolation.
