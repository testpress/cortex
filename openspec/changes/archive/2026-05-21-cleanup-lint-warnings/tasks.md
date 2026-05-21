## 1. AppHtml Cleanup

- [x] 1.1 Remove the unreferenced private method `_updateHeight` from `app_html.dart`.
- [x] 1.2 Remove the unnecessary braces in string interpolation (`${txCss}` -> `$txCss`) at line 220 in `app_html.dart`.

## 2. HttpDataSource Cleanup

- [x] 2.1 Remove the unnecessary import of `../../network/api_endpoints.dart` at line 3 in `http_data_source.dart`.
- [x] 2.2 Replace the null-checking `if` statement for `tags` with a null-aware collection element (`'tags': ?tags`) at line 30 in `http_data_source.dart`.

## 3. AskDoubtFormScreen Cleanup

- [x] 3.1 Implement actual doubt submission logic using `DoubtRepository` and local `AppDatabase` in `_handleSubmit` inside `ask_doubt_form_screen.dart` to resolve the linter warning of the pending TODO.

