/// Cortex Core Package
///
/// Platform-neutral UI primitives and design system for the Cortex SDK.
/// This package provides first-principles components that work identically
/// across all platforms without Material or Cupertino dependencies.
library;

// Design system (runtime)
export 'design/design_config.dart';
export 'design/design_context.dart';
export 'design/design_provider.dart';

// Icons
export 'package:lucide_icons_flutter/lucide_icons.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:package_info_plus/package_info_plus.dart';

// Widgets
export 'widgets/app_text.dart';
export 'widgets/app_markdown.dart';
export 'widgets/app_html.dart';
export 'widgets/app_html_v2.dart';
export 'widgets/app_button.dart';
export 'widgets/app_icon_button.dart';
export 'widgets/app_card.dart';
export 'widgets/app_header.dart';
export 'widgets/app_scroll.dart';
export 'widgets/app_refresh_indicator.dart';
export 'widgets/app_badge.dart';
export 'widgets/app_search_bar.dart';
export 'widgets/app_text_field.dart';
export 'widgets/app_otp_input.dart';
export 'widgets/app_tab_bar.dart';
export 'widgets/app_navigation_rail.dart';
export 'widgets/app_subject_chip.dart';
export 'widgets/app_chip.dart';
export 'widgets/typography_gallery_screen.dart';
export 'widgets/app_carousel.dart';
export 'widgets/app_loading_indicator.dart';
export 'widgets/app_drawer.dart';
export 'widgets/app_bottom_sheet.dart';
export 'widgets/app_error_view.dart';
export 'widgets/app_webview.dart';
export 'widgets/dashboard_header.dart';
export 'widgets/lesson_detail_shell.dart';
export 'widgets/bookmark_folders_sheet.dart';
export 'widgets/app_toast.dart';
export 'widgets/session_expired_dialog.dart';
export 'widgets/app_confirmation_dialog.dart';

// Shell
export 'shell/app_shell.dart';

// Screens
export 'screens/ai_screen.dart';
export 'screens/bp_elearn_my_results_screen.dart';

// Navigation
export 'navigation/app_route.dart';
export 'navigation/route_names.dart';
export 'navigation/lesson_router.dart';
export 'package:go_router/go_router.dart';

// Accessibility
export 'accessibility/app_semantics.dart';
export 'accessibility/app_focus.dart';
export 'accessibility/app_focusable.dart';
export 'accessibility/accessibility_guard.dart';

// Motion
export 'motion/accessibility_motion.dart';

// Network
export 'network/dio_provider.dart';
export 'network/file_downloader.dart';
export 'network/network_utils.dart';

// Utils
export 'utils/date_formatter.dart';
export 'utils/time_formatter.dart';
export 'utils/lesson_type_icon_x.dart';
export 'utils/watermark_params.dart';

// Localization
export 'localization/localization_provider.dart';
export 'localization/l10n_helper.dart';
export 'generated/l10n/app_localizations.dart';

// Payment
export 'payment/payment.dart';

// User State
export 'data/providers/user_provider.dart';
export 'data/repositories/user_repository.dart';

// Integrations
export 'data/integrations/bp_elearn/bp_elearn_exam_provider.dart';
export 'data/integrations/bp_elearn/models/bp_elearn_paginated_response_dto.dart';
