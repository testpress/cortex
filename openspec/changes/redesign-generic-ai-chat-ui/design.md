## Context

`AiScreen` and `AiChatHistoryScreen` already render every chat state from `genericAiChatProvider`. The reference images are 2x exports of a 393dp-wide phone, so measurements below are the image pixels halved. The reference palette is Tailwind slate, which maps closely onto existing tokens: `textPrimary` (slate-900), `onSurface` (slate-700), `onSurfaceVariant` (slate-600), `textSecondary` (slate-500), `textTertiary` (slate-400), and `border`/`surfaceVariant` (slate-200).

## Goals / Non-Goals

**Goals:**
- Match the reference layout, spacing, type, color, and icons for the empty, active, and history states.
- Carry the same visual language into states the reference does not show: streaming, send failure, generation failure, init and quota banners, loading, and history errors.
- Keep keyboard, scroll-follow, and safe-area behavior working on small and large phones.
- Reuse core primitives and design tokens; keep 48dp touch targets.

**Non-Goals:**
- Any change to the provider, repository, network client, DTOs, session handling, or institute gating.
- Thumbs up/down, speaker, share, and more actions; subject chips in history (explicitly excluded).
- The app shell tab bar and navigation rail. The reference tab bar is mock chrome and the shell is shared by every tab and by Web.
- The legacy mock `AiChatImmersiveScreen` and the video lesson AI tab.

## Decisions

### Decision 1: Derive the canvas color from tokens
The reference canvas is `#F8FAFC`, which is lighter than `surface` (`#E9EEF4`) and darker than `card`. `aiChatCanvasColor` returns `Color.lerp(card, surface, 0.3)`, which resolves to `#F8FAFC` in light mode and a slightly recessed zinc in dark mode.
- *Rationale*: Using `surface` directly would erase the user bubble (`surfaceVariant`), and using `card` would erase the white assistant card and composer. A derived value keeps both without a hardcoded color.

### Decision 2: Two composer placements, one controller
`AiScreen` owns the `TextEditingController` and `FocusNode` and passes them to `AiComposer`. The empty state renders the composer under the suggestion cards; any other state docks it at the bottom above a divider with the `+` action.
- *Rationale*: Shared state lets suggestion cards prefill and focus the input, and keeps typed text when the layout switches.

### Decision 3: Suggestion cards prefill instead of sending
Tapping a card writes a localized starter prompt (for example "Explain the concept of ") into the composer, moves the caret to the end, and requests focus.
- *Rationale*: The card labels are categories, not questions. Sending them as-is would spend quota on an answer that can only ask the student what they meant.

### Decision 4: `+` starts a new chat
The reference shows `+` only once a conversation exists, and the API guide states `attachments_enabled` is `false` with no attachment endpoint. The button therefore calls `startNewChat()`.
- *Alternatives considered*: An attachment sheet was rejected because nothing could be sent.

### Decision 5: History stays a route, presented as an overlay
`/ai/history` keeps its path and root-navigator placement but uses a non-opaque `CustomTransitionPage`. `AiChatHistoryScreen` draws its own scrim and start-aligned panel (`layout.drawerWidth`, capped at 85% of the width) and animates them from the route animation, honoring `MotionPreferences`.
- *Rationale*: A route keeps system back, `context.pop()`, and the existing callers working, and covers the tab bar as in the reference. `AppDrawer` was not reused because it renders a fixed menu-item list and a `surface` background.

### Decision 6: Touch targets stay 48dp behind smaller visuals
The copy icon (16dp), close icon (20dp), send circle (32dp), `+` circle (36dp), and `New Chat` button (40dp tall) all keep a 48dp hit box. Parents compensate for the invisible inset, following the existing `AiChatHeader` convention, so the visible positions still match the reference.

### Decision 7: History rows show only what the API returns
The list endpoint returns `title` and `updated_at`. Rows show the title and `DateFormatter.formatTimeAgo`; the preview line from the reference is omitted because no preview field exists, and subject chips are excluded by request.

## Risks / Trade-offs

- **[Risk]** Assistant cards capped at 75% width leave less room for tables and math than the previous 88%. → **Mitigation**: The cap is a single constant in `AiAssistantCard`, and block math already scrolls horizontally inside `AppMarkdown`.
- **[Risk]** The reference sets answers at 16dp while `AppMarkdown` defaults to 14dp for lesson content. → **Mitigation**: `AppMarkdown` gains an optional `textStyle`; only the assistant card passes the 16dp body style, so other callers are unchanged.
- **[Risk]** Shared `AiComposer` restyle also changes the legacy immersive screen. → **Mitigation**: New parameters are optional and default to the previous behavior; only colors and metrics change there.
- **[Trade-off]** Relative times keep the shared formatter's wording ("2 hrs ago") rather than the reference's ("2 hours ago", "Yesterday"), since `DateFormatter` is used outside the chat.
