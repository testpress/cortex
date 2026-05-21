import 'package:flutter_test/flutter_test.dart';
import 'package:courses/utils/vtt_parser.dart';

void main() {
  group('VttParser Tests', () {
    test('should parse valid VTT content successfully', () {
      const vtt = '''WEBVTT

1
00:00:01.000 --> 00:00:04.000
Hello World

2
00:00:05.100 --> 00:00:08.250
<b>This</b> is a test
subtitle line.
''';

      final cues = VttParser.parse(vtt);
      expect(cues.length, 2);
      
      expect(cues[0].startTime, '00:00:01.000');
      expect(cues[0].endTime, '00:00:04.000');
      expect(cues[0].text, 'Hello World');
      expect(cues[0].displayStartTime, '00:01');

      expect(cues[1].startTime, '00:00:05.100');
      expect(cues[1].endTime, '00:00:08.250');
      expect(cues[1].text, 'This is a test subtitle line.');
      expect(cues[1].displayStartTime, '00:05');
    });

    test('should handle different time formats and settings', () {
      const vtt = '''WEBVTT

00:01:23.456 --> 00:01:25.789 align:middle line:90%
Inline subtitle with layout options.
''';

      final cues = VttParser.parse(vtt);
      expect(cues.length, 1);
      expect(cues[0].startTime, '00:01:23.456');
      expect(cues[0].endTime, '00:01:25.789');
      expect(cues[0].text, 'Inline subtitle with layout options.');
      expect(cues[0].displayStartTime, '01:23');
    });

    test('should correctly format sub-minute and different time layouts', () {
      const cue1 = VttCue(startTime: '00:00:19.450', endTime: '00:00:22.000', text: 'Test 1');
      expect(cue1.displayStartTime, '00:19');

      const cue2 = VttCue(startTime: '00:19.000', endTime: '00:22.000', text: 'Test 2');
      expect(cue2.displayStartTime, '00:19');

      const cue3 = VttCue(startTime: '01:04:12.300', endTime: '01:04:15.000', text: 'Test 3');
      expect(cue3.displayStartTime, '01:04:12');
    });

    test('should return empty list for invalid or empty content', () {
      final cues = VttParser.parse('');
      expect(cues, isEmpty);
    });
  });
}
