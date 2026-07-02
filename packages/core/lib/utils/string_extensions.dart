extension StringHtmlExtension on String {
  /// Strips HTML tags and decodes common HTML entities to return plain text.
  /// First, it removes <style> and <script> blocks entirely to prevent CSS/JS from leaking into the text.
  /// Then it removes all remaining HTML tags and decodes entities like &nbsp;, &lt;, &gt;, &amp;, &quot;, and &#39;.
  String stripHtml() {
    return replaceAll(
          RegExp(
            r'<style[^>]*>.*?</style>',
            dotAll: true,
            caseSensitive: false,
          ),
          '',
        )
        .replaceAll(
          RegExp(
            r'<script[^>]*>.*?</script>',
            dotAll: true,
            caseSensitive: false,
          ),
          '',
        )
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }
}
