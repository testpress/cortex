/// Utility for formatting duration strings from the API.
class TimeFormatter {
  /// Formats duration strings like "0.02:17" or "00:45:00" into "2min 17sec" or "45min".
  static String? formatDuration(String? duration) {
    if (duration == null || duration.isEmpty || duration == '0' || duration == '00:00' || duration == '00:00:00' || duration == '0:00:00') {
      return null;
    }

    // If it's already formatted (contains m, h, or s), return it as is
    if (duration.contains(RegExp(r'[mhs]'))) {
      return duration;
    }

    try {
      // Normalize: Some APIs return "0.02:17" or "0:02:17" or "45:00"
      final normalized = duration.replaceAll('.', ':');
      final parts = normalized.split(':').map((s) => int.tryParse(s) ?? 0).toList();
      
      int hours = 0;
      int minutes = 0;
      int seconds = 0;

      if (parts.length >= 3) {
        hours = parts[parts.length - 3];
        minutes = parts[parts.length - 2];
        seconds = parts[parts.length - 1];
      } else if (parts.length == 2) {
        minutes = parts[0];
        seconds = parts[1];
      } else if (parts.length == 1) {
        // If it's just a number, assume it's seconds if it's large, or minutes if small?
        // Usually, if it's a single number in a duration field, it's total seconds.
        final total = parts[0];
        hours = total ~/ 3600;
        minutes = (total % 3600) ~/ 60;
        seconds = total % 60;
      }

      final buffer = StringBuffer();
      if (hours > 0) {
        buffer.write('${hours}h ');
      }
      if (minutes > 0) {
        buffer.write('${minutes}m ');
      }
      if (seconds > 0 && hours == 0) {
        // Only show seconds if there are no hours (to keep it short)
        buffer.write('${seconds}s');
      }

      final result = buffer.toString().trim();
      if (result.isEmpty) return null;
      
      // Post-process to match common "45 min" style if it's just minutes
      if (hours == 0 && seconds == 0 && minutes > 0) {
        return '$minutes min';
      }

      return result;
    } catch (_) {
      return null;
    }
  }
}
