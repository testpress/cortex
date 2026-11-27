---
description: Build mobile app screens from approved HTML designs
alwaysApply: true
---

# Building UI from an approved design

Approved mobile designs are standalone HTML prototypes (a link, or a file the designer shares). The HTML shows the screen inside a phone frame, with a side panel to switch theme and states. That HTML is the source of truth for layout, text, order, colours and every state.

## 1. Get the design

- If the developer gave you the HTML file, use it. If they gave a link, save it, never print it: `curl -sL <design url> -o /tmp/design_<screen>.html`. Then read the whole file, including the `<style>` and `<script>`.
- Never work from a screenshot, PRD, description or memory of the old screen.
- Read every state: the side panel's buttons and the script's data and render functions show each one (list, in progress, empty, loading, error, sheets, dialogs).
- Ignore the parts that are only for the preview: the page around the phone, the side panel, the device frame, the status bar and home bar. A `data-toast` on an element means "this navigates to or triggers X", not "show a toast".

## 2. Find this app's design system first

Before writing UI code, find and list (file paths) this project's:

- colour tokens for light and dark (e.g. a Flutter theme or design config class, Compose `MaterialTheme` / `colors.xml`, an iOS asset catalog or `Color` extension, a React Native theme)
- spacing, corner radius and typography scales
- shared UI components (buttons, cards, bottom sheets, dialogs, error and empty views, toasts)
- the icon set, and how strings are localised
- how neighbouring screens are structured (header, scroll body, fixed bottom bar)

Then map the design onto it:

- Each CSS colour variable in the design names a role (`--card`, `--textSecondary`, `--primary` …). Use the app's token for that role. Light and dark come from the same tokens. Never branch on theme in the screen.
- px spacing, radius and font sizes → the app's matching scale values.
- Each piece of UI → the app's existing component for it.
- Every visible text → the app's string resources, with the design's exact wording.

If a value has no matching token, or a piece has no matching component, stop and list it for the designer. Don't pick the nearest value and don't hard-code it.

## 3. Commit 1: build the screen as designed

- Build every state from the design with the design's sample data (a local mock is fine).
- Add the route and the way in (button, app bar action) exactly where the design puts them.
- Commit with the message `Build approved design: <design link or file name>`.

## 4. Commit 2: wire the data

Only these changes are allowed:

- sample data → the app's existing state management, repository and API models
- the design's loading, empty and error states driven by real data state
- taps → the app's real navigation and actions

Never:

- change, add, remove or reorder any element, text, icon, colour, spacing or radius
- replace the design's pieces with an older component that looks "close enough"
- hard-code a colour, font size or padding
- drop a state the design shows (empty, loading, error, in progress, sheet, dialog)

If the design needs data or behaviour the API doesn't have, stop and ask. Don't remove it or invent a substitute.

## 5. Finish

Tell the developer:

1. the design system files you found (step 2)
2. the two commit hashes
3. every change in commit 2 outside the allowed list (should be none)
4. every token or component that was missing, anything you couldn't match, and why
5. a reminder to post side-by-side screenshots (design | app) at the design's phone size in the task's to-do: light, dark, and every state

