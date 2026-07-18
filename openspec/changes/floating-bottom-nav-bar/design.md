## Context

The app currently uses a `BottomNavigationBar` (implemented as `AppTabBar` inside `AppShell`) that occupies the full width at the bottom of the screen. The user has requested to make the bottom navigation bar "floating", which means it should not sit flush against the bottom edge or take full width in an unconstrained way, but rather appear as a floating pill or box overlaid on the bottom content, allowing the main content to flow behind or around it.

## Goals / Non-Goals

**Goals:**
- Update `AppTabBar` to be a floating widget with rounded borders, margins, and shadow.
- Update `AppShell` to allow content to scroll underneath the floating nav bar.
- Ensure the floating nav bar looks good on both mobile and tablet.

**Non-Goals:**
- Complete redesign of the navigation rail for landscape layouts.
- Changing the actual routing logic or navigation items.

## Decisions

1. **Floating Layout Strategy in `AppShell`**:
   - *Alternative 1*: Keep the `Column` but add padding around `bottomNavigationBar`. This won't allow content to flow underneath the bar (the floating effect).
   - *Alternative 2*: Use a `Stack` in `AppShell` for portrait mode where `child` takes up the full screen and `bottomNavigationBar` is positioned at the bottom center.
   - *Decision*: Go with **Alternative 2**. We will place the `bottomNavigationBar` inside an `Align(alignment: Alignment.bottomCenter)` within the `Stack`. This creates the true floating effect.

2. **Styling `AppTabBar`**:
   - Instead of a `Border(top: ...)` and full width, we will use a `BoxDecoration` with `borderRadius`, `boxShadow`, and background color.
   - We will wrap `AppTabBar` with padding (e.g., `margin: EdgeInsets.all(16)`) to separate it from the edges.

3. **Content Obscuration Mitigation**:
   - The `child` inside `AppShell` will now go behind the floating nav bar. 
   - *Decision*: We will update `AppShell` to position the nav bar over the child using a `Stack`. For screens that need to account for this padding, they typically rely on `SafeArea` or scroll view padding. We will adjust `AppShell` to inject a bottom padding if necessary or let the floating bar just overlap the content (which is standard for floating bars, often handled by adding bottom padding to `ListView`s).

## Risks / Trade-offs

- **Risk**: Content in existing screens might get hidden behind the floating nav bar.
  - **Mitigation**: We will need to ensure that the bottom padding of the `SafeArea` or lists accounts for the height of the floating nav bar. We can inject an extra bottom padding in `AppShell` for the child to ensure the bottommost content is reachable.

- **Risk**: Tablet layout (landscape) breaking.
  - **Mitigation**: The floating change primarily affects the portrait layout (`Column` replaced by `Stack`). Landscape uses `navigationRail`, which remains unaffected.
