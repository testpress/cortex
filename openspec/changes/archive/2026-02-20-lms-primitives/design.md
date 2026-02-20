## Context

The LMS app requires a set of foundational UI primitives that guarantee visual consistency across the entire application while minimizing code duplication. Currently, the new UI components defined in the design specs (such as badges, search bars, tab navigation, and filter chips) need to be ported to the Flutter SDK. We recently established our core design tokens (`card`, `border`, `SubjectColors`, `BadgeColors`); these new primitives will serve as the first major consumers of those tokens within `packages/core`.

## Goals / Non-Goals

**Goals:**
- Implement `AppBadge` to display statuses (Live, Completed, Locked) and roles using the `DesignStatusColors` tokens.
- Implement `AppSearchBar` as a standardized text input tailored for search queries.
- Implement `AppTabBar` to provide bottom navigation routing (Home, Study, Explore, Profile).
- Implement `AppSubjectChip` as an interactive filter toggle leveraging `DesignSubjectPalette`.
- Ensure all components are strictly presentation-layer (dumb components) that rely on external state and callbacks.

**Non-Goals:**
- Handling business logic or API calls within these components.
- Implementing the actual routing logic (that belongs in the app-level router, not inside `AppTabBar`).
- Building out the complex screens that will eventually consume these primitives.

## Decisions

**1. "Dumb" Presentation Components**
*Decision*: All primitives will be stateless widgets (or stateful only for internal animation) that accept data via properties and emit events via callbacks (`VoidCallback`, `ValueChanged<String>`).
*Rationale*: This decouples UI from state management (Riverpod), ensuring the components remain highly reusable across different contexts (e.g., the Search Bar can be used in both Study and Explore screens without being tied to a specific data provider).

**2. Direct Consumption of Design Tokens**
*Decision*: The components will directly access the inherited design system via `Design.of(context)` to style themselves, rather than accepting hardcoded Flutter `Color` or `TextStyle` objects as parameters.
*Rationale*: This forces strict adherence to the design system and ensures the components instantly react to Light/Dark mode transitions or theme changes. For example, `AppBadge` will derive its colors directly from `design.statusColors`.

**3. Custom `AppTabBar` vs Flutter's `BottomNavigationBar`**
*Decision*: We will build `AppTabBar` from scratch using rows and columns rather than extending Flutter's default `BottomNavigationBar`.
*Rationale*: The design has very specific active/inactive states (stroke width changes, specific typography) that are notoriously difficult to mimic exactly using the rigid constraints of the built-in Material widget.

**4. External Icon Library: `lucide_icons`**
*Decision*: We will integrate `lucide_icons` as a centralized dependency exclusively within `packages/core`, exporting it through the core design system API (barrel file).
*Rationale*: Centralizing the icon font ensures downstream consumer packages (`courses`, `app`) do not need redundant dependencies, natively adopting the thin-outlined `lucide` aesthetic strictly through the design provider.

**5. AppBadge Extensions (`isPill` and `icon`)**
*Decision*: The `AppBadge` component will be extended to accept an optional `IconData? icon` parameter and a boolean `isPill` flag (which sets `borderRadius` to `rounded-full` instead of `rounded-md`).
*Rationale*: This was discovered during implementation as necessary to support "New" pill-shaped badges and Leaderboard/Blog tags that feature icons natively, closely mirroring the `ExplorePage` design.

**6. AppTabBar `activeIcon` State Management**
*Decision*: `AppTabItem` will accept an `IconData icon` and an optional `IconData? activeIcon` to orchestrate distinct visual weights natively.
*Rationale*: Since font stroke variations cannot be dynamically altered natively via CSS `stroke-[x]` in Flutter like they can in web frameworks, providing an explicitly distinct active vs inactive icon data resolves the visual requirement seamlessly.

## Risks / Trade-offs

- **Risk: Extensibility Constraints** → As screens become more complex, these primitives might lack specific niche properties (like a custom suffix icon on the search bar).
  - *Mitigation*: Design the components with sensible defaults but expose optional overrides (e.g., an optional `Widget? suffixIcon` parameter on `AppSearchBar`).
- **Risk: Performance on Re-renders** → Custom components reading from InheritedWidgets (`Design.of`) can trigger full re-builds if not careful.
  - *Mitigation*: Ensure `const` constructors are used wherever possible and internal build methods are kept lightweight.
