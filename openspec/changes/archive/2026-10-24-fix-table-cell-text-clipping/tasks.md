## 1. HTML Sanitization for Tables

- [x] 1.1 Strip restrictive inline height and line-height properties (`height`, `min-height`, `max-height`, `line-height`) from table elements in `AppHtmlV2._sanitizeHtml()`
- [x] 1.2 Strip legacy HTML `height` attributes from `<table>`, `<tr>`, `<td>`, and `<th>` elements in `AppHtmlV2._sanitizeHtml()`

## 2. Table Layout and Verification

- [x] 2.1 Verify `customStylesBuilder` table styling retains dynamic sizing and appropriate padding
- [x] 2.2 Add widget tests in `packages/core/test/widgets/app_html_v2_table_test.dart` for tables with inline height styles and attributes, verifying no text clipping occurs
