import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/config/institute_settings.dart';

void main() {
  group('InstituteSettings.fromJson', () {
    test('parses video watermark fields correctly', () {
      final json = {
        'name': 'Test Institute',
        'video_watermark_type': 'Dynamic',
        'video_watermark_position': 'top left',
      };

      final settings = InstituteSettings.fromJson(json);

      expect(settings.videoWatermarkType, VideoWatermarkType.dynamic);
      expect(settings.videoWatermarkPosition, VideoWatermarkPosition.topLeft);
    });

    test('handles missing video watermark fields gracefully', () {
      final json = {'name': 'Test Institute'};

      final settings = InstituteSettings.fromJson(json);

      expect(settings.videoWatermarkType, isNull);
      expect(settings.videoWatermarkPosition, isNull);
    });
  });
}
