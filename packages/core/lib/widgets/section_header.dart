import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.leadingIcon,
    this.trailingAction,
    this.secondaryContent,
    this.secondaryContentSpacing,
    this.backgroundColor,
  });

  final String title;
  final Widget? leadingIcon;
  final Widget? trailingAction;
  final Widget? secondaryContent;
  final double? secondaryContentSpacing;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final padding = MediaQuery.paddingOf(context);

    return Container(
      padding: _buildPadding(design, padding),
      color: backgroundColor ?? design.colors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderRow(design),
          if (secondaryContent != null) _buildSecondaryContent(design),
        ],
      ),
    );
  }

  EdgeInsets _buildPadding(DesignConfig design, EdgeInsets padding) {
    return EdgeInsets.fromLTRB(
      math.max(padding.left, design.spacing.md),
      padding.top + design.spacing.md,
      math.max(padding.right, design.spacing.md),
      design.spacing.md,
    );
  }

  Widget _buildSecondaryContent(DesignConfig design) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: secondaryContentSpacing ?? design.spacing.md),
        secondaryContent!,
      ],
    );
  }

  Widget _buildHeaderRow(DesignConfig design) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          SizedBox(width: design.spacing.sm),
        ],
        Expanded(child: _buildTitle(design)),
        if (trailingAction != null) ...[
          SizedBox(width: design.spacing.md),
          trailingAction!,
        ],
      ],
    );
  }

  Widget _buildTitle(DesignConfig design) {
    return AppSemantics.header(
      label: title,
      child: AppText.headline(title, color: design.colors.textPrimary),
    );
  }
}
