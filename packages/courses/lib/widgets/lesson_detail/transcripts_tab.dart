import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import 'continue_button.dart';

class TranscriptsTab extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onNext;

  const TranscriptsTab({super.key, required this.lesson, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.md,
        top: design.spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.fileText,
                    color: design.colors.accent2,
                    size: 20,
                  ),
                  SizedBox(width: design.spacing.sm),
                  AppText.subtitle(
                    l10n.videoLessonTranscript,
                    color: design.colors.textPrimary,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              AppButton.primary(
                label: l10n.videoLessonDownloadPdf,
                leading: Icon(
                  LucideIcons.download,
                  color: design.colors.onPrimary,
                  size: 14,
                ),
                height: 32,
                backgroundColor: design.colors.accent2,
                onPressed: () {},
                padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
              ),
            ],
          ),
          SizedBox(height: design.spacing.md),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildTranscriptLine(
                  '00:00',
                  'Welcome to this lesson on the First Law of Thermodynamics.',
                  design,
                ),
                _buildTranscriptLine(
                  '00:15',
                  'The first law states that energy cannot be created or destroyed, only transformed from one form to another.',
                  design,
                ),
                _buildTranscriptLine(
                  '00:32',
                  'Let\'s begin by understanding what internal energy means in the context of thermodynamic systems. Internal energy is the sum of all microscopic forms of energy.',
                  design,
                ),
                _buildTranscriptLine(
                  '01:05',
                  'When we add heat to a system, it can either increase the internal energy or do work on the surroundings.',
                  design,
                ),
                ContinueButton(onTap: onNext),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptLine(String time, String text, DesignConfig design) {
    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: AppText.caption(
              time,
              color: design.colors.accent2,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: AppText.body(
              text,
              color: design.colors.textSecondary,
              style: const TextStyle(height: 1.5, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
