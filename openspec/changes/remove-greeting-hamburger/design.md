## Context

Currently, the `PaidActiveHomeScreen` displays two hamburger menu icons when the `InstituteBanner` is present:
1. One inside the `InstituteBanner` (the header banner).
2. One inside the `DashboardHeader` (next to the greeting).

This duplication is visually incorrect and should be resolved by hiding the one next to the greeting when the banner is active.

## Goals / Non-Goals

**Goals:**
- Eliminate the duplicate hamburger menu next to the greeting on the home screen.
- Ensure the drawer navigation still functions properly when the banner is not present.

**Non-Goals:**
- Altering drawer functionality or navigation structure.
- Modifying drawer behavior on other screens.

## Decisions

- **Conditional Menu Callback**: On `PaidActiveHomeScreen`, the `DashboardHeader`'s `onMenuPressed` callback will be conditionally evaluated. If `isBannerPresent` is true, we will pass `null` to `onMenuPressed`. Since the callback is `null`, `DashboardHeader` will not render the duplicate menu icon. If `isBannerPresent` is false, it will continue to pass the drawer open callback.

## Risks / Trade-offs

- [Risk] Hiding the menu icon might leave a landscape layout without any drawer menu triggers. → Mitigation: `InstituteBanner` handles the trigger on the home screen, and when `isBannerPresent` is false, the header menu trigger is preserved.
