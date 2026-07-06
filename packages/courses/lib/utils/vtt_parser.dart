class VttCue {
  final String startTime;
  final String endTime;
  final String text;

  const VttCue({
    required this.startTime,
    required this.endTime,
    required this.text,
  });

  String get displayStartTime {
    final parts = startTime.split('.');
    final timeStr = parts.isNotEmpty ? parts[0].trim() : startTime.trim();
    final timeUnits = timeStr.split(':');

    if (timeUnits.length == 3) {
      final hrs = int.tryParse(timeUnits[0]) ?? 0;
      final mins = int.tryParse(timeUnits[1]) ?? 0;
      final secs = int.tryParse(timeUnits[2]) ?? 0;

      if (hrs == 0) {
        final mm = mins.toString().padLeft(2, '0');
        final ss = secs.toString().padLeft(2, '0');
        return '$mm:$ss';
      } else {
        final hh = hrs.toString().padLeft(2, '0');
        final mm = mins.toString().padLeft(2, '0');
        final ss = secs.toString().padLeft(2, '0');
        return '$hh:$mm:$ss';
      }
    } else if (timeUnits.length == 2) {
      final mins = int.tryParse(timeUnits[0]) ?? 0;
      final secs = int.tryParse(timeUnits[1]) ?? 0;
      final mm = mins.toString().padLeft(2, '0');
      final ss = secs.toString().padLeft(2, '0');
      return '$mm:$ss';
    }
    return timeStr;
  }
}

class VttParser {
  static List<VttCue> parse(String vttContent) {
    final List<VttCue> cues = [];
    final lines = vttContent.split(RegExp(r'\r?\n'));

    int index = 0;
    while (index < lines.length) {
      final line = lines[index].trim();

      // Skip empty lines, headers, notes, or style definitions
      if (line.isEmpty ||
          line.startsWith('WEBVTT') ||
          line.startsWith('NOTE') ||
          line.startsWith('STYLE') ||
          line.startsWith('REGION')) {
        index++;
        continue;
      }

      // Check if line is a timestamp line (e.g. "00:00:01.000 --> 00:00:05.000")
      if (line.contains('-->')) {
        final timeParts = line.split('-->');
        if (timeParts.length >= 2) {
          final startTime = timeParts[0].trim();
          // The end time might be followed by settings, so split by space
          final parts = timeParts[1].trim().split(RegExp(r'\s+'));
          final endTime = parts.isNotEmpty ? parts[0] : '';

          if (endTime.isEmpty) {
            index++;
            continue;
          }

          // Read subsequent lines until we hit an empty line or another timestamp
          final List<String> textLines = [];
          index++;
          while (index < lines.length) {
            final nextLine = lines[index].trim();
            if (nextLine.isEmpty || nextLine.contains('-->')) {
              // We finished reading text for this cue, or hit the next cue directly
              // If it's next cue directly, decrement index so the outer loop processes it
              if (nextLine.contains('-->')) {
                index--;
              }
              break;
            }
            // Strip any HTML/WebVTT tags (like <v speaker> or <b>) from subtitle text
            final cleanLine = nextLine.replaceAll(RegExp(r'<[^>]*>'), '');
            if (cleanLine.isNotEmpty) {
              textLines.add(cleanLine);
            }
            index++;
          }

          if (textLines.isNotEmpty) {
            cues.add(VttCue(
              startTime: startTime,
              endTime: endTime,
              text: textLines.join(' '),
            ));
          }
        }
      }
      index++;
    }

    return cues;
  }
}
