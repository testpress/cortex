## Context

See [proposal.md](proposal.md) for background and motivation. The AI tab is being revamped to feature a mock conversational chatbot companion instead of outdated static content.

## Goals / Non-Goals

**Goals:**
- Nested navigation subroutes for immersive chat (`/ai/chat`) and history (`/ai/history`).
- Immersive chatbot interface with simulated typewriter responses and auto-scrolling.
- Compliant touch targets and accessibility semantics across all new interactive widgets.
- Mock chat sessions and messages stored in-memory.

**Non-Goals:**
- Real network HTTP data sync or production backend integration.
- Offline database persistence (Drift/SQLite caching layers).

## Decisions

### 1. Navigation Shell & Subroutes
Configure `/ai/chat` and `/ai/history` as child routes nested under the primary `/ai` route in `ai_routes.dart`, using `rootNavigatorKey` as the `parentNavigatorKey` to hide the main bottom navigation bar during chat interactions.
- **Alternatives Considered:** Registering them as separate root-level routes, which breaks logical hierarchy and tab grouping.

### 2. Accessibility & Target Sizing (WCAG 2.5.5)
Refactor custom interactive elements (such as the send button in the composer) to use `AppIconButton` (which natively bakes in 48x48dp dimensions and semantics) rather than small raw `GestureDetector` buttons. Wrap other interactive items (like cards and text links) with `AppSemantics.button()` or configure layout padding to maintain a 48dp target.
- **Alternatives Considered:** Relying on basic 36x36 dp icons, which violates WCAG accessibility requirements.

### 3. Animation and Motion Tokens
Utilize design tokens (`design.motion.*`, `design.motion.normal`, etc.) and verify `MotionPreferences.shouldAnimate(context)` in all custom animations (like the typing indicator), rather than hardcoding durations or curves.
- **Alternatives Considered:** Using hardcoded `Curves.easeInOut` and `Duration(...)` values, which bypasses system preference settings.

### 4. In-Memory Mock Data Layer
Utilize static mock structures (`AiChatSession` and `AiChatMessage`) in `ai_chat_mock_data.dart` to simulate local session fetching and modification.
- **Alternatives Considered:** Building a full Repository/Drift DB pipeline, which is out of scope for this UI redesign experiment.

## Risks / Trade-offs

- **[Risk]** The scroll controller might be disposed before the post-frame callback runs in `_scrollToBottom()`, leading to assertion errors.
  - **Mitigation:** Ensure all accesses to `_scrollController` inside post-frame callbacks are guarded with `if (!mounted) return;`.
- **[Risk]** Heavy custom typewriter states leading to UI lag on low-end devices.
  - **Mitigation:** Run timer intervals at a lightweight 30ms and check user motion preferences to skip animations if needed.
