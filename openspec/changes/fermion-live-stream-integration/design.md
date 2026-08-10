## Context

See `proposal.md – Why` for motivation. The relevant implementation landscape:

- `LessonDto` (in `packages/core`) is the data-layer DTO parsed from API JSON. Live stream lessons are already parsed by `_parseLiveStreamLesson` which reads fields from the `live_stream` nested object. The DTO is then mapped to the `Lesson` domain model in `packages/courses`.
- **`contentUrl` meaning differs by provider**: `_parseLiveStreamLesson` currently assigns `json['uuid']` first. For TpStreams, this UUID is the correct value — `CustomVideoPlayer` passes it as `assetId` to `TestpressPlayer` from the `tpstreams_player_sdk`, which resolves the HLS stream internally. For Fermion, the UUID is meaningless to the WebView; the actual embed URL lives in `liveStream['stream_url']`.
- `LiveStreamViewer` passes `lesson.contentUrl` directly to `CustomVideoPlayer(assetId: ...)`. If we do not fix the parsing, a Fermion session would set `contentUrl` to the UUID (e.g. `"yCklANfvjqx"`), and the WebView would try to load that as a URL — failing immediately.
- `AppWebView` (in `packages/core/lib/widgets/app_webview.dart`) is an existing, fully-featured WebView wrapper with progress bar and error handling — no new WebView plumbing is needed.
- The Fermion `stream_url` is an embed URL (`https://testpress.fermion.app/embed/live-session?...`) — not an HLS manifest. It must load in a WebView, not a video player.

## Goals / Non-Goals

**Goals:**
- Parse `live_stream.provider` and expose it through `LessonDto` → `Lesson`.
- Render a lobby screen (session title + "Join Now") for Fermion sessions.
- Launch a full-screen `AppWebView` on "Join Now".
- Preserve TpStreams (and `null`-provider) behaviour exactly as-is.

**Non-Goals:**
- Chat embed for Fermion (the API shows `chat_embed_url: null` for Fermion; no chat overlay).
- Recorded-video playback after a Fermion session ends (deferred; `show_recorded_video` support for Fermion may differ).
- New routes or screens — the WebView is pushed imperatively from within `LiveStreamViewer`.
- Analytics or completion-tracking for Fermion sessions.

## Decisions

### D1: Provider-aware `contentUrl` assignment in `_parseLiveStreamLesson`

**Decision:** Branch on `liveStream?['provider']` inside `_parseLiveStreamLesson` when computing `contentUrl`:
- **Fermion**: use `liveStream?['stream_url']` (the embed URL the WebView needs)
- **TpStreams / null**: use `json['uuid']` first (the asset ID the TpStreams SDK needs), falling back to `liveStream?['stream_url']`

**Rationale:** The two providers have fundamentally different semantics for `contentUrl`. TpStreams SDK resolves the HLS stream from the asset ID opaquely — passing a raw HLS URL to `TestpressPlayer` is not supported. Fermion requires the embed URL directly in a WebView. The branch is the minimum change that keeps both providers working correctly without introducing a separate field.

**Alternative considered:** Add a separate `liveStreamEmbedUrl` field for Fermion — rejected because it adds model complexity and a new field just to work around the UUID priority order. A clean provider-aware branch in one place is simpler.

---

### D2: Store provider as a plain `String?` rather than an enum

**Decision:** Add `liveStreamProvider` as `String?` on both `LessonDto` and `Lesson`.

**Rationale:** The provider list may grow (e.g. Zoom, YouTube Live) and the SDK (`packages/core`) must not hard-code product-level knowledge. A plain string keeps the core package open to extension without a breaking change. The UI layer checks `liveStreamProvider?.toLowerCase() == 'fermion'` for branching.

**Alternative considered:** `enum LiveStreamProvider { tpstreams, fermion, unknown }` — rejected because it would require a core package change every time a new provider is introduced, coupling the SDK to product-specific data.

---

### D3: Lobby screen lives inside `LiveStreamViewer`, not a new screen

**Decision:** The Fermion lobby is rendered as a conditional branch inside the existing `LiveStreamViewer` widget (using a private `_FermionLobbyView` sub-widget), not as a new route or screen.

**Rationale:** The orchestrator already dispatches to `LiveStreamViewer` for all `LessonType.liveStream` lessons. Adding a branch inside the viewer requires the minimum surface-area change and avoids touch-points in routing, route names, and the orchestrator. The "Join Now" WebView is pushed imperatively with `Navigator.of(context).push(AppRoute(...))` from inside `_FermionLobbyView`.

**Alternative considered:** A separate `FermionLiveStreamScreen` registered as a new route — rejected because it would require new `AppRouteNames`, changes to `LessonRouter`, and the orchestrator, all for a single provider variant.

---

### D4: Use existing `AppWebView` for the Fermion session

**Decision:** Push `AppWebView(url: lesson.contentUrl!)` in a full-screen `AppRoute`.

**Rationale:** `AppWebView` already handles auth headers (attaches JWT only when the host matches `apiBaseUrl`, which a `fermion.app` URL will not, so no credentials are leaked), progress bar, error/retry, and `NavigationDecision.prevent` to block redirects. Reusing it avoids duplicated WebView boilerplate.

**Alternative considered:** Use `LessonWebView` with a `url:` parameter — `LessonWebView` is scoped to lesson HTML content and applies DOM-compaction scripts. Using `AppWebView` is cleaner for a full-session embed.

---

### D5: The lobby screen uses core design primitives only

**Decision:** `_FermionLobbyView` uses `AppText`, `AppButton.primary`, `Design.of(context)`, and `LucideIcons` — no Material/Cupertino widgets.

**Rationale:** Enforced by `ai_context.md` UI rules. Using core primitives ensures the lobby is theme-aware and accessible.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| Fermion embed URL requires cookies / local-storage to authenticate | The token is embedded in the URL query string (JWT param visible in the sample), so no additional auth header is needed. `AppWebView` sets `JavaScriptMode.unrestricted` which allows the Fermion JS session to run fully. |
| `NavigationDecision.prevent` in `AppWebView` blocks Fermion internal routing | Fermion uses a SPA embed — all routing is client-side JS within the same URL; the navigation delegate only fires for top-level page loads. Existing `AppWebView` behaviour is correct. |
| `liveStreamProvider` field absent on older API responses | The field is nullable `String?`; null-provider falls through to existing TpStreams path — backward compatible. |
| `isComplete` check in `Lesson` requires `contentUrl != null` for `liveStream` type | Fermion's `contentUrl` is the embed URL (non-empty string) — the check already passes. No change needed. |
