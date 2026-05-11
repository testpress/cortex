import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class ExamInstructionsView extends StatelessWidget {
  final ExamDto? exam;
  final VoidCallback onClose;
  final VoidCallback onStartExam;

  const ExamInstructionsView({
    super.key,
    required this.exam,
    required this.onClose,
    required this.onStartExam,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.surface,
      child: Column(
        children: [
          AppHeader(
            title: exam?.title ?? 'Instructions',
            leading: GestureDetector(
              onTap: onClose,
              child: const Icon(LucideIcons.x),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(design.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText.headline(l10n.examInstructions),
                  SizedBox(height: design.spacing.md),
                  Expanded(
                    child: SingleChildScrollView(
                      child: AppText.body(
                        'Please read the instructions carefully before starting the exam...',
                      ),
                    ),
                  ),
                  AppButton(
                    onPressed: onStartExam,
                    label: l10n.startExam,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
