/// The playback speeds offered by the player UI.
const List<double> kStandardPlaybackSpeeds = [
  0.5,
  0.75,
  1.0,
  1.25,
  1.5,
  1.75,
  2.0,
  3.0,
];

/// Returns the standard playback speed nearest to [measured].
///
/// Returns `null` when the measured rate is too noisy to map to a standard
/// speed (i.e. it deviates by more than 25% from the closest one).
double? quantizePlaybackSpeed(double measured) {
  var nearest = kStandardPlaybackSpeeds.first;
  var nearestDiff = double.infinity;
  for (final speed in kStandardPlaybackSpeeds) {
    final diff = (measured - speed).abs();
    if (diff < nearestDiff) {
      nearestDiff = diff;
      nearest = speed;
    }
  }
  if (nearestDiff > 0.25 * nearest) {
    return null;
  }
  return nearest;
}
