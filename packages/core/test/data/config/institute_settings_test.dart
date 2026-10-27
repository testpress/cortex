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

    test(
      'parses messages_enabled and messages_label correctly and defaults properly',
      () {
        final jsonDefault = {'name': 'Test Institute'};
        final defaultSettings = InstituteSettings.fromJson(jsonDefault);
        expect(defaultSettings.messagesEnabled, isFalse);
        expect(defaultSettings.messagesLabel, isNull);

        final jsonEnabled = {
          'name': 'Test Institute',
          'messages_enabled': true,
          'messages_label': 'Support Desk',
        };
        final enabledSettings = InstituteSettings.fromJson(jsonEnabled);
        expect(enabledSettings.messagesEnabled, isTrue);
        expect(enabledSettings.messagesLabel, 'Support Desk');
        expect(enabledSettings.toJson()['messages_enabled'], isTrue);
        expect(enabledSettings.toJson()['messages_label'], 'Support Desk');
      },
    );

    test(
      'parses student_notes_enabled and student_notes_label correctly and defaults properly',
      () {
        final jsonDefault = {'name': 'Test Institute'};
        final defaultSettings = InstituteSettings.fromJson(jsonDefault);
        expect(defaultSettings.studentNotesEnabled, isFalse);
        expect(defaultSettings.studentNotesLabel, isNull);

        final jsonEnabled = {
          'name': 'Test Institute',
          'student_notes_enabled': true,
          'student_notes_label': 'My Notebook',
        };
        final enabledSettings = InstituteSettings.fromJson(jsonEnabled);
        expect(enabledSettings.studentNotesEnabled, isTrue);
        expect(enabledSettings.studentNotesLabel, 'My Notebook');
        expect(enabledSettings.toJson()['student_notes_enabled'], isTrue);
        expect(enabledSettings.toJson()['student_notes_label'], 'My Notebook');
      },
    );
  });
}
