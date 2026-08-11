import 'package:intl/intl.dart';

/// Utility for formatting duration strings from the API.
class TimeFormatter {
  /// Formats duration strings like "0.02:17" or "00:45:00" into "2min 17sec" or "45min".
  static String? formatDuration(String? duration) {
    if (duration == null ||
        duration.isEmpty ||
        duration == '0' ||
        duration == '00:00' ||
        duration == '00:00:00' ||
        duration == '0:00:00') {
      return null;
    }

    // If it's already formatted (contains m, h, or s), return it as is
    if (duration.contains(RegExp(r'[mhs]'))) {
      return duration;
    }

    // Try parsing raw double value (seconds)
    final doubleValue = double.tryParse(duration);
    if (doubleValue != null) {
      final total = doubleValue.toInt();
      final hours = total ~/ 3600;
      final minutes = (total % 3600) ~/ 60;
      final seconds = total % 60;

      final buffer = StringBuffer();
      if (hours > 0) {
        buffer.write('${hours}h ');
      }
      if (minutes > 0) {
        buffer.write('${minutes}m ');
      }
      if (seconds > 0 && hours == 0) {
        buffer.write('${seconds}s');
      }

      final result = buffer.toString().trim();
      if (result.isEmpty) return null;

      if (hours == 0 && seconds == 0 && minutes > 0) {
        return '$minutes min';
      }

      return result;
    }

    try {
      // Normalize: Some APIs return "0.02:17" or "0:02:17" or "45:00"
      final normalized = duration.replaceAll('.', ':');
      final parts = normalized
          .split(':')
          .map((s) => int.tryParse(s) ?? 0)
          .toList();

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

  /// Parses a timestamp string like "1:23" or "01:23:45" into a [Duration].
  static Duration parseDuration(String timeStr) {
    if (timeStr.isEmpty) return Duration.zero;

    try {
      final parts = timeStr.split('.');
      final timePart = parts[0];
      final msPart = parts.length > 1 ? parts[1] : '0';

      final timeUnits = timePart.split(':');
      int hours = 0;
      int minutes = 0;
      int seconds = 0;

      if (timeUnits.length == 3) {
        hours = int.tryParse(timeUnits[0]) ?? 0;
        minutes = int.tryParse(timeUnits[1]) ?? 0;
        seconds = int.tryParse(timeUnits[2]) ?? 0;
      } else if (timeUnits.length == 2) {
        minutes = int.tryParse(timeUnits[0]) ?? 0;
        seconds = int.tryParse(timeUnits[1]) ?? 0;
      } else if (timeUnits.length == 1) {
        seconds = int.tryParse(timeUnits[0]) ?? 0;
      }

      final milliseconds =
          int.tryParse(msPart.padRight(3, '0').substring(0, 3)) ?? 0;

      return Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
      );
    } catch (_) {
      return Duration.zero;
    }
  }

  /// Formats a date string like "2026-06-27T06:30:00Z" into "dd MMM yyyy"
  static String? formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return null;
    }
  }

  /// Parses a duration string (formatted or raw) and returns total minutes as a String (e.g. "60 minutes").
  static String? formatDurationToMinutes(String? durationStr) {
    if (durationStr == null || durationStr.isEmpty) return null;

    int totalMinutes = 0;
    bool parsedSuccessfully = false;

    // Check for hours (e.g., "1h" or "1 h")
    final hourMatch = RegExp(r'(\d+)\s*h').firstMatch(durationStr);
    if (hourMatch != null) {
      final hours = int.tryParse(hourMatch.group(1) ?? '') ?? 0;
      totalMinutes += hours * 60;
      parsedSuccessfully = true;
    }

    // Check for minutes (e.g., "30m" or "45 min" or "45m")
    final minMatch = RegExp(r'(\d+)\s*(?:m|min)').firstMatch(durationStr);
    if (minMatch != null) {
      final mins = int.tryParse(minMatch.group(1) ?? '') ?? 0;
      totalMinutes += mins;
      parsedSuccessfully = true;
    }

    if (parsedSuccessfully) {
      return '$totalMinutes minutes';
    }

    // Fallback: Try parsing raw integers (since live stream raw durations are in minutes)
    final doubleVal = double.tryParse(durationStr);
    if (doubleVal != null && doubleVal > 0) {
      return '${doubleVal.toInt()} minutes';
    }

    // Fallback: Try raw parsing of formats like "01:23:45"
    final duration = parseDuration(durationStr);
    if (duration != Duration.zero) {
      return '${duration.inMinutes} minutes';
    }

    return null;
  }
}
