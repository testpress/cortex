## Context

The `PaidActiveHomeScreen` currently uses `isBannerPresent` (derived from whether a logo URL is configured) as a "God Flag" to fork the entire dashboard widget list into two completely separate branches. This results in:
- Duplicated widget declarations (`lessonCardsSection`, `topLearnersSection`, etc. appear in both branches)
- A hardcoded URL string hack (`isBrilliantPala`) to hide `StudyMomentum` for one client
- Inconsistent widget ordering between branches (Updates & Announcements comes before Top Learners in the banner branch but after in the standard branch)
- The user's name always visible in headers regardless of whether a Profile tab exists

## Goals / Non-Goals

**Goals:**
- Collapse the `if/else` widget fork into one single, unified, ordered list of widgets
- Remove the `isBrilliantPala` hack; always show Study Momentum for all clients
- Standardize widget order: Contextual Hero → Today's Schedule → Lesson Cards → Updates & Announcements → Study Momentum → Top Learners → Quick Access
- Hide the user's name in `InstituteBanner` and `HomeGreetingSection` when `AppConfig.showProfileTab` is `true`
- Show the actual institute name (from `InstituteSettings.current?.name`) as the header title when no banner logo is configured

**Non-Goals:**
- Not changing the header/banner selection logic (i.e., `isBannerPresent` still controls which top widget is shown — `InstituteBanner` vs `DashboardHeader`)
- Not adding new `AppConfig` flags for individual widget visibility (widgets self-hide when data is empty)
- Not changing data sources, providers, or API contracts

## Decisions

### D1: Keep `isBannerPresent` only for the header slot, not for the body layout
`isBannerPresent` will continue to decide whether `InstituteBanner` or `DashboardHeader` appears at the top. It will no longer control the scroll body widget list at all.

*Alternative considered*: Remove `isBannerPresent` entirely and use `AppConfig.instituteLogoUrl` inline — rejected because it would spread logo URL logic across multiple widgets.

### D2: Show Study Momentum for all clients
Remove the `!isBrilliantPala` check. `StudyMomentum` widget already handles empty/error states by returning `SizedBox.shrink()`, so showing it for all clients is safe. The data provider will simply return no data for clients that don't have the feature enabled server-side.

### D3: Pass `showName` bool to `HomeGreetingSection` and gate username in `InstituteBanner`
Rather than making the widgets read `AppConfig` directly (which increases coupling), the parent screen passes `showName: !AppConfig.showProfileTab` down. This keeps the widgets reusable and testable.

*Alternative considered*: Have each widget read `AppConfig.showProfileTab` internally — rejected to keep widget API clean and testable.

### D4: Institute name fallback for header title
`DashboardHeader` title = `InstituteSettings.current?.name` if non-empty, else fall back to `L10n.of(context).homeHeaderTitle`. This is computed in `PaidActiveHomeScreen.build()` before passing to the header widget.

## Risks / Trade-offs

- **[Risk] Study Momentum shown on new clients**: If a client doesn't configure study momentum server-side, the widget returns `SizedBox.shrink()` — safe by design, zero visual impact.
- **[Risk] `InstituteSettings.current` is null on first load**: The fallback to `L10n.of(context).homeHeaderTitle` covers this. No crash risk.
- **[Risk] `HomeGreetingSection` may not accept `showName`**: If the parameter doesn't exist yet, it needs to be added. This is the only file outside the dashboard that requires modification.

### D5: Widget Modularization (Newspaper Metaphor)
The `PaidActiveHomeScreen` had become a "God Widget", housing logic for the main layout as well as 10 distinct sections inside inline private classes within the same file. To improve readability, testability, and maintainability, the screen was refactored using a "Newspaper Metaphor". The main screen now acts strictly as the layout (the newspaper page), while each section (the articles) is extracted into its own standalone public widget file inside `widgets/`. This encapsulates state (`ref.watch`) locally per section, preventing full-page rebuilds and keeping files small.
