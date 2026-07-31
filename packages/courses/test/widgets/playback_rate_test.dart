import 'package:courses/widgets/lesson_detail/playback_rate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('quantizePlaybackSpeed', () {
    test('maps exact standard speeds', () {
      expect(quantizePlaybackSpeed(0.5), 0.5);
      expect(quantizePlaybackSpeed(1.0), 1.0);
      expect(quantizePlaybackSpeed(2.0), 2.0);
      expect(quantizePlaybackSpeed(3.0), 3.0);
    });

    test('maps near-standard speeds within tolerance', () {
      expect(quantizePlaybackSpeed(1.04), 1.0);
      expect(quantizePlaybackSpeed(1.45), 1.5);
      expect(quantizePlaybackSpeed(1.95), 2.0);
    });

    test('returns null for noisy rates', () {
      expect(quantizePlaybackSpeed(0.3), isNull);
      expect(quantizePlaybackSpeed(0.0), isNull);
      expect(quantizePlaybackSpeed(4.0), isNull);
    });

    test('maps boundary values at the tolerance edge', () {
      expect(quantizePlaybackSpeed(0.4), 0.5);
      expect(quantizePlaybackSpeed(2.25), 2.0);
    });
  });
}
