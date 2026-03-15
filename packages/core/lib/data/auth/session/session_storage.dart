/// Mock Session Storage for UI development.
/// This allows for routing verification without requiring persistent shared preferences.
class SessionStorage {
  SessionStorage._();
  static final instance = SessionStorage._();

  bool _hasSession = false;

  /// Mock state for session availability.
  bool get hasSession => _hasSession;

  /// Mock method to toggle session for UI testing.
  void persistSession() {
    _hasSession = true;
  }

  /// Mock implementation to clear the session.
  void clear() {
    _hasSession = false;
  }

  /// Mock initialization.
  Future<void> initialize() async {
    // No-op for mock
  }
}
