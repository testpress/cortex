/// Utility class to parse HTML and extract asset URLs (like images) for offline caching.
class HtmlAssetExtractor {
  /// Extracts all image `src` URLs from the provided HTML content using Regex.
  /// This avoids needing a heavy HTML parsing dependency just to find images.
  static List<String> extractImageUrls(String htmlContent) {
    if (htmlContent.isEmpty) return [];

    final urls = <String>[];

    // Matches <img ... src="url" ...> or JSON-escaped <img ... src=\"url\" ...>
    final imgRegExp = RegExp(
      r'<img[^>]+src=\\?["\u0027]([^\\"\u0027]+)\\?["\u0027]',
      caseSensitive: false,
    );
    final matches = imgRegExp.allMatches(htmlContent);

    for (final match in matches) {
      if (match.groupCount >= 1) {
        final src = match.group(1);
        // Only extract valid HTTP/HTTPS URLs (ignore base64 or relative paths for now)
        if (src != null && src.isNotEmpty && src.startsWith('http')) {
          urls.add(src);
        }
      }
    }

    return urls;
  }
}
