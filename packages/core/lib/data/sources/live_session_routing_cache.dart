/// In-memory cache for live class session routing hints.
///
/// Keeps track of known 1-on-1 session IDs to avoid 404 trial requests,
/// and tracks non-existent IDs (on confirmed 404) to prevent repeated fallbacks.
/// Both sets are capped to prevent unbounded memory growth.
class LiveSessionRoutingCache {
  static const int defaultMaxEntries = 500;

  final int maxEntries;
  final Set<String> _oneOnOneSessionIds = {};
  final Set<String> _nonexistentSessionIds = {};

  LiveSessionRoutingCache({this.maxEntries = defaultMaxEntries});

  bool isKnownOneOnOne(String id) => _oneOnOneSessionIds.contains(id);

  bool isNonexistent(String id) => _nonexistentSessionIds.contains(id);

  void markOneOnOne(String id) {
    if (_oneOnOneSessionIds.contains(id)) return;
    if (_oneOnOneSessionIds.length >= maxEntries) {
      _oneOnOneSessionIds.remove(_oneOnOneSessionIds.first);
    }
    _oneOnOneSessionIds.add(id);
  }

  void markNonexistent(String id) {
    if (_nonexistentSessionIds.contains(id)) return;
    if (_nonexistentSessionIds.length >= maxEntries) {
      _nonexistentSessionIds.remove(_nonexistentSessionIds.first);
    }
    _nonexistentSessionIds.add(id);
  }

  void clear() {
    _oneOnOneSessionIds.clear();
    _nonexistentSessionIds.clear();
  }
}
