## Why

Some client builds need an Info experience instead of the standard Profile tab so learners can browse externally hosted learning resources. The current Flutter project only defines the generic profile flow, so we need a spec-first way to add this client-specific variant without changing the default experience for every tenant.

## What Changes

- Add a client-specific Info page capability that presents a curated list of learning-resource courses, a per-course video list, and external video launch behavior.
- Add a client configuration rule so the Info experience is hidden by default and only enabled for selected clients.
- Update the navigation shell requirements so the Profile tab can switch label, icon, and destination to Info when the client configuration enables it.
- Preserve the existing Profile experience for all clients that do not opt into the Info page.

## Capabilities

### New Capabilities
- `client-info-page`: Client-gated Info experience for browsing curated learning resources and opening linked external videos.

### Modified Capabilities
- `lms-navigation-shell`: The primary navigation shell needs a client-aware tab variant that keeps `Profile` as the default entry and swaps to `Info` only when the feature is enabled.

## Impact

- **Packages**: Likely `packages/profile` and/or the navigation shell package that owns the profile tab destination.
- **Navigation**: Bottom-tab label, icon, and routing behavior become client-aware.
- **Configuration**: A client-level switch or feature flag is required so the experience stays disabled by default.
- **Data**: Initial implementation can use curated/mock learning-resource data until a client-managed source exists.
