## Context

The repo already defines a generic `Profile` experience and a shared navigation shell, but the supplied JSX reference introduces a client-specific variant where the fifth tab changes from `Profile` to `Info` and opens a curated learning-resource flow. This is a cross-cutting change because it touches both navigation selection and a profile-adjacent screen that only a subset of clients should see. The implementation also needs to respect the SDK-first package boundaries and keep the default app behavior unchanged for every client that does not opt in.

## Goals / Non-Goals

**Goals:**
- Add a client-controlled switch that leaves the standard profile flow untouched by default.
- Define an Info resource flow that matches the JSX design intent: course catalog, course drill-in, and external video launch.
- Keep the implementation package-safe so the shell can decide between Profile and Info without hardcoding one-off behavior in `app/`.
- Implement Info as a dedicated package (`packages/client_info`) to maintain domain isolation and navigation flexibility.

**Non-Goals:**
- Defining a backend-managed CMS or remote configuration pipeline for Info content.
- Replacing the generic Profile screen for all clients.
- Implementing in-app video playback, download support, or progress tracking for Info videos.

## Decisions

### 1. Use explicit client configuration instead of implicit user-type logic
The JSX reference swaps to Info for a specific paid-active mode, but in this codebase the real requirement is tenant-specific behavior. The Flutter implementation should therefore use an explicit client capability flag or config switch rather than inferring the experience from learner state. This keeps the rollout predictable and prevents accidental exposure for unrelated clients.

### 2. Keep Info as a distinct capability and swap it in at the shell edge
The generic `lms-profile` spec already owns the default profile hub. Instead of overloading that capability, the Info flow should live as its own feature and the shell should choose between the default profile destination and the Info destination. This preserves the current architecture, keeps specs easier to reason about, and avoids turning the shared profile package into a tenant-specific grab bag.

### 3. Start with curated/mock resource data behind a stable domain model
The JSX file hardcodes a list of courses and videos. The first implementation should mirror that with a local model/provider abstraction so UI work can land without blocking on a content service. Using a stable domain model now reduces future churn when the resource list moves to client-managed data.

### 4. Launch videos externally instead of embedding playback
The design clearly signals external YouTube-style destinations from the course-detail rows. Keeping that behavior in Flutter avoids new playback dependencies and keeps the client-specific page lightweight. The implementation should preserve shell state so returning from the external app or browser drops the user back into the same Info context.
### 4. Implementation in a dedicated package
To prevent the profile package from becoming a "utility drawer" and to ensure domain isolation, the Info feature will be implemented in `packages/client_info`. This allows the feature to be toggled at the shell level without coupling the "User Identity" domain with the "Learning Resource Catalog" domain.

## Risks / Trade-offs

- [Risk] Client gating could leak into unrelated code paths if checked ad hoc in multiple widgets. → Mitigation: centralize the enablement decision in a dedicated config/provider and have the shell consume a single source of truth.
- [Risk] Putting the Info screen in the wrong package could violate SDK boundaries or create awkward imports. → Mitigation: use a dedicated `client_info` package to maintain clear domain boundaries and prevent pollution of the profile package.
- [Risk] Mock content can drift from eventual client-managed content needs. → Mitigation: define a small typed resource model now and keep the provider boundary separate from widget code.
- [Risk] External URL launch failures can create a dead tap experience. → Mitigation: require explicit handling for launch errors and keep the user on the Info screen when a URL cannot be opened.

## Technical Configuration

The Info experience is toggled at compile-time using Flutter's tool-chain defines. This ensures zero code overhead in the production bundle for clients that do not use this feature.

### 1. Enablement Flag
To enable the Info tab and landing page, use the `ENABLE_INFO_PAGE` environment define:
```bash
flutter run --dart-define=ENABLE_INFO_PAGE=true
```

### 2. Source of Truth
The flag is consumed in `packages/core/lib/data/config/app_config.dart` and exposed via the `clientInfoPageEnabledProvider` for use in navigation logic and routing.

## Migration Plan

1. Introduce the client capability/config surface with a default value of disabled.
2. Create the `packages/client_info` package.
3. Implement Info landing page, models, and providers in the new package.
4. Update the navigation shell so the fifth destination resolves to Profile or client_info's landing page based on config.
5. Verify that default clients still see `Profile`, while enabled clients see `Info` and can open external videos.

- Should the Info tab use a generic info icon or a client-branded icon if design assets differ from the JSX reference?
- Will the resource content eventually move to a dynamic fetch from a client-specific API endpoint?
