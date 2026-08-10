import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../design/design_provider.dart';
import '../accessibility/app_semantics.dart';
import '../localization/l10n_helper.dart';
import '../accessibility/app_focusable.dart';

/// A standardized back-navigation button for use as [AppHeader.leading].
///
/// Encapsulates the arrow icon, tap target sizing, and accessibility label
/// in one reusable widget — eliminating duplicated back-button code across screens.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, required this.onTap, this.semanticLabel});

  final VoidCallback onTap;

  /// Accessibility label for the button. Defaults to the localized "back" label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppSemantics.button(
      label: semanticLabel ?? l10n.commonBackSemantic,
      onTap: onTap,
      child: AppFocusable(
        padding: const EdgeInsets.all(13),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 2), // Optical alignment
          child: Icon(
            LucideIcons.arrowLeft,
            color: design.colors.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}
