String formatDuration(Duration duration, {bool showUnit = false}) {
  if (showUnit) {
    if (duration.inHours > 0 && duration.inMinutes.remainder(60) == 0) {
      return '${duration.inHours * 60} min';
    }
    if (duration.inHours == 0) {
      return '${duration.inMinutes} min';
    }
    // Fallback for non-round durations or large ones
    return '${duration.inMinutes} min';
  }

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (hours > 0) {
    return '$hours:$minutes:$seconds';
  }
  return '$minutes:$seconds';
}
