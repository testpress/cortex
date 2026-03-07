import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotificationPreferenceType {
  liveClassReminders,
  testAssessmentAlerts,
  announcementsUpdates,
  achievementsBadges,
}

@immutable
class NotificationPreferencesState {
  const NotificationPreferencesState({
    required this.liveClassReminders,
    required this.testAssessmentAlerts,
    required this.announcementsUpdates,
    required this.achievementsBadges,
  });

  const NotificationPreferencesState.defaults()
    : liveClassReminders = true,
      testAssessmentAlerts = true,
      announcementsUpdates = false,
      achievementsBadges = true;

  final bool liveClassReminders;
  final bool testAssessmentAlerts;
  final bool announcementsUpdates;
  final bool achievementsBadges;

  NotificationPreferencesState toggle(NotificationPreferenceType type) {
    return switch (type) {
      NotificationPreferenceType.liveClassReminders => copyWith(
        liveClassReminders: !liveClassReminders,
      ),
      NotificationPreferenceType.testAssessmentAlerts => copyWith(
        testAssessmentAlerts: !testAssessmentAlerts,
      ),
      NotificationPreferenceType.announcementsUpdates => copyWith(
        announcementsUpdates: !announcementsUpdates,
      ),
      NotificationPreferenceType.achievementsBadges => copyWith(
        achievementsBadges: !achievementsBadges,
      ),
    };
  }

  NotificationPreferencesState copyWith({
    bool? liveClassReminders,
    bool? testAssessmentAlerts,
    bool? announcementsUpdates,
    bool? achievementsBadges,
  }) {
    return NotificationPreferencesState(
      liveClassReminders: liveClassReminders ?? this.liveClassReminders,
      testAssessmentAlerts: testAssessmentAlerts ?? this.testAssessmentAlerts,
      announcementsUpdates: announcementsUpdates ?? this.announcementsUpdates,
      achievementsBadges: achievementsBadges ?? this.achievementsBadges,
    );
  }
}

class NotificationPreferencesNotifier
    extends StateNotifier<NotificationPreferencesState> {
  NotificationPreferencesNotifier()
    : super(const NotificationPreferencesState.defaults());

  void toggle(NotificationPreferenceType type) {
    state = state.toggle(type);
  }
}

final notificationPreferencesProvider =
    StateNotifierProvider<
      NotificationPreferencesNotifier,
      NotificationPreferencesState
    >((ref) => NotificationPreferencesNotifier());
