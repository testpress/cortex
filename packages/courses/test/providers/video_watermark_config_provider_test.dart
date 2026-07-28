import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';
import 'package:courses/providers/video_watermark_config_provider.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('VideoWatermarkConfigFactory', () {
    const watermarkText = 'test_user';

    test('returns null for null type', () {
      final config = VideoWatermarkConfigFactory.create(
        null,
        VideoWatermarkPosition.topLeft,
        'user123',
        14.0,
      );
      expect(config, isNull);
    });

    test('maps dynamic type correctly', () {
      final config = VideoWatermarkConfigFactory.create(
        VideoWatermarkType.dynamic,
        null,
        watermarkText,
        14.0,
      );
      expect(config, isNotNull);
      expect(config!.text, watermarkText);
      expect(config.textSize, 14.0);
      expect(config.y, 50);
      expect(config.animation, isNotNull);
      expect(config.animation!.type, WatermarkAnimationType.pingPong);
    });

    test('maps static type and positions correctly', () {
      final positionMappings = {
        VideoWatermarkPosition.topLeft: [10, 10],
        VideoWatermarkPosition.topRight: [90, 10],
        VideoWatermarkPosition.bottomLeft: [10, 90],
        VideoWatermarkPosition.bottomRight: [90, 90],
        VideoWatermarkPosition.middle: [50, 50],
      };

      for (final entry in positionMappings.entries) {
        final config = VideoWatermarkConfigFactory.create(
          VideoWatermarkType.static,
          entry.key,
          watermarkText,
          14.0,
        );
        expect(config, isNotNull);
        expect(config!.text, watermarkText);
        expect(config.x, entry.value[0]);
        expect(config.y, entry.value[1]);
        expect(config.animation, isNull);
      }
    });

    test('maps static type with null position to middle default', () {
      final config = VideoWatermarkConfigFactory.create(
        VideoWatermarkType.static,
        null,
        watermarkText,
        14.0,
      );
      expect(config, isNotNull);
      expect(config!.x, 50);
      expect(config.y, 50);
    });
  });
}
