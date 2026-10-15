import 'dart:math';

/// Secure RFC 4122 Version 4 UUID generator.
class UuidUtils {
  static final Random _secureRandom = Random.secure();

  /// Generates a cryptographically secure RFC 4122 v4 UUID string.
  /// Example: `f77bd538-2ac2-478a-936c-d76f0ca9cf71`
  static String v4() {
    final bytes = List<int>.generate(16, (_) => _secureRandom.nextInt(256));

    // Version 4 bits (0100xxxx) in byte 6
    bytes[6] = (bytes[6] & 0x0f) | 0x40;

    // Variant 1 bits (10xxxxxx) in byte 8
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }
}
