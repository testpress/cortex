import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../models/test_model.dart';
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart' show FontWeight;

class TestHeader extends StatelessWidget {
  final Test test;
  final String timeFormatted;
  final VoidCallback onExit;

  const TestHeader({
    super.key,
    required this.test,
    required this.timeFormatted,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + design.spacing.md,
        bottom: design.spacing.md,
        left: design.spacing.md,
        right: design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(bottom: BorderSide(color: design.colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onExit,
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.chevronLeft,
                      color: design.colors.textPrimary,
                      size: 20,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.body(
                      l10n.testExit,
                      color: design.colors.textPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 72),
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.sm,
                  vertical: design.spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: design.isDark
                      ? design.colors.surface
                      : design.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(design.radius.xl),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.clock,
                      color: design.colors.accent3,
                      size: 16,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.caption(
                      timeFormatted,
                      color: design.colors.textPrimary,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: design.spacing.lg),
          AppText.headline(
            '${l10n.filterTest}: ${test.title}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: design.spacing.xs),
          Row(
            children: [
              AppText.caption(
                '${test.totalQuestions} ${l10n.shortcutTests}',
                color: design.colors.textSecondary,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: design.colors.textSecondary,
                  ),
                ),
              ),
              AppText.caption(
                'Attempt 1 of 2',
                color: design.colors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
