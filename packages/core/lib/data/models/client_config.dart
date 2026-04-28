/// Configuration specific to the client/institute/tenant.
///
/// This config controls feature flags and branding elements based on the
/// current subdomain or institute settings.
class ClientConfig {
  final bool showTodaySchedule;
  final bool showQuickAccess;
  final bool showContextualHero;
  final bool showStudyCategoryButtons;
  final bool showResumeSection;
  final bool showWhatsNewSection;
  final bool showRecentlyCompletedSection;
  final String? instituteLogoUrl;
  final bool isLocalLogo;

  const ClientConfig({
    this.showTodaySchedule = true,
    this.showQuickAccess = true,
    this.showContextualHero = true,
    this.showStudyCategoryButtons = true,
    this.showResumeSection = true,
    this.showWhatsNewSection = true,
    this.showRecentlyCompletedSection = true,
    this.instituteLogoUrl,
    this.isLocalLogo = false,
  });

  ClientConfig copyWith({
    bool? showTodaySchedule,
    bool? showQuickAccess,
    bool? showContextualHero,
    bool? showStudyCategoryButtons,
    bool? showResumeSection,
    bool? showWhatsNewSection,
    bool? showRecentlyCompletedSection,
    String? instituteLogoUrl,
    bool? isLocalLogo,
  }) {
    return ClientConfig(
      showTodaySchedule: showTodaySchedule ?? this.showTodaySchedule,
      showQuickAccess: showQuickAccess ?? this.showQuickAccess,
      showContextualHero: showContextualHero ?? this.showContextualHero,
      showStudyCategoryButtons:
          showStudyCategoryButtons ?? this.showStudyCategoryButtons,
      showResumeSection: showResumeSection ?? this.showResumeSection,
      showWhatsNewSection: showWhatsNewSection ?? this.showWhatsNewSection,
      showRecentlyCompletedSection: showRecentlyCompletedSection ?? this.showRecentlyCompletedSection,
      instituteLogoUrl: instituteLogoUrl ?? this.instituteLogoUrl,
      isLocalLogo: isLocalLogo ?? this.isLocalLogo,
    );
  }

  factory ClientConfig.fromJson(Map<String, dynamic> json) {
    return ClientConfig(
      showTodaySchedule: json['show_today_schedule'] as bool? ?? true,
      showQuickAccess: json['show_quick_access'] as bool? ?? true,
      showContextualHero: json['show_contextual_hero'] as bool? ?? true,
      showStudyCategoryButtons: json['show_study_category_buttons'] as bool? ?? true,
      showResumeSection: json['show_resume_section'] as bool? ?? true,
      showWhatsNewSection: json['show_whats_new_section'] as bool? ?? true,
      showRecentlyCompletedSection: json['show_recently_completed_section'] as bool? ?? true,
      instituteLogoUrl: json['institute_logo_url'] as String?,
      isLocalLogo: json['is_local_logo'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'show_today_schedule': showTodaySchedule,
      'show_quick_access': showQuickAccess,
      'show_contextual_hero': showContextualHero,
      'show_study_category_buttons': showStudyCategoryButtons,
      'show_resume_section': showResumeSection,
      'show_whats_new_section': showWhatsNewSection,
      'show_recently_completed_section': showRecentlyCompletedSection,
      'institute_logo_url': instituteLogoUrl,
      'is_local_logo': isLocalLogo,
    };
  }

  /// Default configuration for general institutes.
  static const ClientConfig defaultGeneral = ClientConfig();

  /// Specialized configuration for institutes like "Brilliant".
  static const ClientConfig brilliant = ClientConfig(
    showTodaySchedule: false,
    showQuickAccess: false,
    showContextualHero: false,
    showStudyCategoryButtons: false,
    instituteLogoUrl: 'assets/images/brilliant_pala_logo.png',
    isLocalLogo: true,
  );
}
