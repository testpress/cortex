import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import 'continue_button.dart';

class NotesTab extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onNext;

  const NotesTab({super.key, required this.lesson, required this.onNext});

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
                    l10n.videoLessonLectureNotes,
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
                AppText.subtitle(
                  '1. First Law of Thermodynamics',
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.body(
                  'The first law of thermodynamics states that energy cannot be created or destroyed, only transformed from one form to another. This is also known as the law of conservation of energy.',
                  color: design.colors.textSecondary,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                SizedBox(height: design.spacing.md),
                AppText.subtitle(
                  '2. Internal Energy (U)',
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.body(
                  'Internal energy is the total energy contained within a thermodynamic system. It includes kinetic energy of molecules and potential energy from molecular interactions.',
                  color: design.colors.textSecondary,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                SizedBox(height: design.spacing.md),
                AppText.subtitle(
                  '3. Mathematical Expression',
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.body(
                  'The first law is expressed as: ΔU = Q - W',
                  color: design.colors.textSecondary,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBulletPoint(
                        'ΔU = Change in internal energy',
                        design,
                      ),
                      _buildBulletPoint('Q = Heat added to the system', design),
                      _buildBulletPoint('W = Work done by the system', design),
                    ],
                  ),
                ),
                SizedBox(height: design.spacing.md),
                Container(
                  padding: EdgeInsets.all(design.spacing.md),
                  decoration: BoxDecoration(
                    color: design.colors.accent2.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(design.radius.md),
                    border: Border.all(
                      color: design.colors.accent2.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.sparkles,
                            color: design.colors.accent2,
                            size: 18,
                          ),
                          SizedBox(width: design.spacing.xs),
                          AppText.subtitle(
                            l10n.videoLessonKeyFormula,
                            color: design.colors.accent2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AppText.body(
                        'ΔU = Q - W (First Law of Thermodynamics)',
                        color: design.colors.textPrimary,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: design.spacing.lg),
                AppText.subtitle(
                  '4. Applications',
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: design.spacing.xs),
                _buildBulletPoint('Heat engines and refrigerators', design),
                _buildBulletPoint('Calorimetry problems', design),
                _buildBulletPoint('Phase transitions', design),
                _buildBulletPoint('Adiabatic and isothermal processes', design),
                ContinueButton(onTap: onNext),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, DesignConfig design) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: design.colors.textTertiary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: design.spacing.sm),
          Expanded(
            child: AppText.body(
              text,
              color: design.colors.textSecondary,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
