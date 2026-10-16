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
      expect(settings.forceStudentData, isFalse);
    });

    test('parses force_student_data correctly', () {
      final json = {'name': 'Test Institute', 'force_student_data': true};

      final settings = InstituteSettings.fromJson(json);

      expect(settings.forceStudentData, isTrue);
    });

    test('parses enable_ai_chatbot correctly and defaults to false', () {
      final jsonDefault = {'name': 'Test Institute'};
      expect(InstituteSettings.fromJson(jsonDefault).enableAiChatbot, isFalse);
      expect(InstituteSettings.fromJson(jsonDefault).enableAiTab, isFalse);

      final jsonEnabled = {'name': 'Test Institute', 'enable_ai_chatbot': true};
      final settings = InstituteSettings.fromJson(jsonEnabled);
      expect(settings.enableAiChatbot, isTrue);
      expect(settings.enableAiTab, isTrue);
      expect(settings.toJson()['enable_ai_chatbot'], isTrue);
    });
  });
}
