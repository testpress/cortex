## Context

The paid-active profile has a certificates entry point but no destination screen. The reference design defines two connected views: a certificates list (with unlocked and locked states) and a certificate preview. This change is limited to paid-active behavior and must keep profile-tab navigation continuity.

## Goals / Non-Goals

**Goals:**
- Deliver a Certificates list screen and Certificate Preview screen with parity to the available Figma references.
- Support locked and unlocked certificate card variants with clear status and actions.
- Wire Profile -> Certificates -> Preview navigation without breaking tab state.
- Use shared design tokens, semantic text roles, and accessibility semantics.

**Non-Goals:**
- Real certificate download generation or file export.
- Share integration with platform share sheets.
- Backend persistence, verification APIs, or certificate issuance logic.
- Redesigning profile architecture or app shell behavior.

## Decisions

### 1. Screen ownership in `packages/courses`
- **Decision**: Implement certificates list/preview UI and supporting state in `packages/courses`.
- **Why**: Certificates are a domain feature launched from profile domain flows.
- **Alternative**: Build in `packages/core`.
- **Why not**: Core remains primitives/tokens, not domain screens.

### 2. Local/mock data for paid-active v1 behavior
- **Decision**: Use local/mock certificate data for paid-active card state, progress, and preview details.
- **Why**: Scope excludes backend integration while requiring interactive behavior.
- **Alternative**: Static non-interactive mock UI.
- **Why not**: Does not meet expected interaction and navigation behavior.

### 3. In-tab profile routing
- **Decision**: Keep certificates navigation inside the profile tab flow.
- **Why**: Preserves user context and matches existing profile navigation behavior.
- **Alternative**: Navigate outside the profile tab flow.
- **Why not**: Creates inconsistent back behavior.

### 4. Tokenized styling and semantic text only
- **Decision**: Match Figma hierarchy using shared spacing/color/radius tokens and semantic typography roles.
- **Why**: Preserves runtime theming and avoids hardcoded constants.
- **Alternative**: Port raw Figma values directly.
- **Why not**: Violates project guardrails and reduces maintainability.

### 5. Action semantics and accessible controls
- **Decision**: Use semantic labels/state for row actions and card actions; preserve touch target minimums.
- **Why**: Required by accessibility rules in core docs.
- **Alternative**: Visual-only icon buttons.
- **Why not**: Fails accessibility standards.

## Risks / Trade-offs

- **[Risk]** Certificates behavior and preview metadata can diverge from expected paid-active data shape.  
  **Mitigation**: Keep paid-active data mapping explicit and test unlocked + locked card states.

- **[Risk]** Route regressions in profile tab stack.  
  **Mitigation**: Add navigation tests for forward and back paths across list and preview screens.

- **[Risk]** Visual drift from Figma due to card complexity.  
  **Mitigation**: Verify spacing/typography/icon hierarchy against the reference before closing tasks.
