## Context

In `AppHtmlV2`, content is rendered natively via `flutter_widget_from_html_core` rather than through an embedded `WebView`. When tables authored in WYSIWYG editors (CKEditor, TinyMCE) or copied from external sources (Word, Excel) contain inline CSS styles like `height: 20px;` or HTML attributes like `height="18"`, `flutter_widget_from_html_core` enforces rigid box constraints (`BoxConstraints.tight`) on `HtmlTable` cells. When combined with cell padding and typography line heights, cell text overflows the constrained height and is clipped at the top of the cell.

## Goals / Non-Goals

**Goals:**
- Eliminate table cell text clipping by allowing cell height to expand intrinsically to fit all text and equations.
- Strip restrictive inline height and line-height properties (`height`, `min-height`, `max-height`, `line-height`) and legacy `height="..."` attributes on `<table>`, `<tr>`, `<td>`, and `<th>` elements during the sanitization pass.
- Maintain consistent padding and border rendering across all table elements in light and dark themes.

**Non-Goals:**
- Reverting to `WebView` for table rendering.
- Re-architecting the `flutter_widget_from_html_core` package layout engine.

## Decisions

### Decision 1: Extend `_sanitizeHtml` to Strip Height and Line-Height on Table Tags
In `_sanitizeHtml`, when parsing `style` attributes on table elements (`table`, `thead`, `tbody`, `tr`, `td`, `th`), remove:
- `height`
- `min-height`
- `max-height`
- `line-height`

*Rationale*: Browsers treat cell `height` as `min-height`, but `flutter_widget_from_html_core` treats it as a rigid tight constraint. Stripping these properties allows Flutter's layout engine to determine cell size from intrinsic content height plus padding.

### Decision 2: Strip Legacy HTML `height` Attributes on Table Tags
WYSIWYG editors frequently output legacy attributes like `<tr height="20">` or `<td height="18">`.
We add a regex pass in `_sanitizeHtml` to strip `height\s*=\s*(["'][^"']*["']|\S+)` from `<table>`, `<tr>`, `<td>`, and `<th>` tags.

*Rationale*: `flutter_widget_from_html_core` parses `height` attributes directly into style dimensions if present. Removing the attribute guarantees clean fallback to content dimensions.

### Decision 3: Keep Intrinsic Cell Padding in `customStylesBuilder`
Maintain `border: 1px solid currentColor` and `padding: 6px` in `customStylesBuilder` for `td` and `th`. Once restrictive heights are removed, the 6px top and bottom padding provides readable breathing room without clipping glyphs.

## Risks / Trade-offs

- **[Risk]** Tables intentionally designed with tiny fixed rows will expand to fit the text.
  → **Mitigation**: In mobile test-taking environments, readable, unclipped question content is strictly preferable to squashed text.
