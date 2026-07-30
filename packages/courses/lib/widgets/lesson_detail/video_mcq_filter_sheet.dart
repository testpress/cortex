import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class VideoMcqFilterSheet extends StatefulWidget {
  final String difficulty;
  final int questionCount;
  final Function(String difficulty, int questionCount) onApply;

  const VideoMcqFilterSheet({
    super.key,
    required this.difficulty,
    required this.questionCount,
    required this.onApply,
  });

  @override
  State<VideoMcqFilterSheet> createState() => _VideoMcqFilterSheetState();
}

class _VideoMcqFilterSheetState extends State<VideoMcqFilterSheet> {
  late String _selectedDifficulty;
  late int _selectedQuestionCount;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.difficulty;
    _selectedQuestionCount = widget.questionCount;
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.sm,
        0,
        design.spacing.sm,
        design.spacing.md + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            design.spacing.lg,
            design.spacing.md,
            design.spacing.lg,
            design.spacing.lg,
          ),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.all(
              Radius.circular(design.radius.xxl),
            ),
            boxShadow: design.shadows.floating,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: design.spacing.xl * 1.5,
                  height: 4,
                  decoration: BoxDecoration(
                    color: design.colors.border,
                    borderRadius: BorderRadius.circular(design.radius.full),
                  ),
                ),
              ),

              SizedBox(height: design.spacing.lg),

              AppText.title(
                L10n.of(context).videoMcqQuizOptions,
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),

              SizedBox(height: design.spacing.md),

              AppText.body(
                L10n.of(context).videoMcqDifficultyLevel,
                color: design.colors.textPrimary,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              SizedBox(height: design.spacing.sm),
              Row(
                children: [
                  _buildChip(
                    label: L10n.of(context).videoMcqDifficultyEasy,
                    isSelected: _selectedDifficulty == 'easy',
                    onTap: () => setState(() => _selectedDifficulty = 'easy'),
                    design: design,
                  ),
                  SizedBox(width: design.spacing.sm),
                  _buildChip(
                    label: L10n.of(context).videoMcqDifficultyMedium,
                    isSelected: _selectedDifficulty == 'medium',
                    onTap: () => setState(() => _selectedDifficulty = 'medium'),
                    design: design,
                  ),
                  SizedBox(width: design.spacing.sm),
                  _buildChip(
                    label: L10n.of(context).videoMcqDifficultyHard,
                    isSelected: _selectedDifficulty == 'hard',
                    onTap: () => setState(() => _selectedDifficulty = 'hard'),
                    design: design,
                  ),
                ],
              ),
              SizedBox(height: design.spacing.md),
              AppText.body(
                L10n.of(context).videoMcqQuizOptions,
                color: design.colors.textPrimary,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              SizedBox(height: design.spacing.sm),
              Row(
                children: [
                  _buildChip(
                    label: L10n.of(context).videoMcqQuestionsCount(5),
                    isSelected: _selectedQuestionCount == 5,
                    onTap: () => setState(() => _selectedQuestionCount = 5),
                    design: design,
                  ),
                  SizedBox(width: design.spacing.sm),
                  _buildChip(
                    label: L10n.of(context).videoMcqQuestionsCount(10),
                    isSelected: _selectedQuestionCount == 10,
                    onTap: () => setState(() => _selectedQuestionCount = 10),
                    design: design,
                  ),
                  SizedBox(width: design.spacing.sm),
                  _buildChip(
                    label: L10n.of(context).videoMcqQuestionsCount(20),
                    isSelected: _selectedQuestionCount == 20,
                    onTap: () => setState(() => _selectedQuestionCount = 20),
                    design: design,
                  ),
                ],
              ),
              SizedBox(height: design.spacing.lg),
              AppButton.primary(
                label: L10n.of(context).videoMcqApplyOptions,
                fullWidth: true,
                onPressed: () =>
                    widget.onApply(_selectedDifficulty, _selectedQuestionCount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required DesignConfig design,
  }) {
    return Expanded(
      child: AppSemantics.button(
        label: label,
        onTap: onTap,
        child: AppFocusable(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: design.spacing.sm),
            decoration: BoxDecoration(
              color: isSelected
                  ? design.colors.accent2
                  : design.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(design.radius.sm),
              border: Border.all(
                color:
                    isSelected ? design.colors.accent2 : design.colors.divider,
              ),
            ),
            child: Center(
              child: AppText.caption(
                label,
                color: isSelected
                    ? design.colors.textInverse
                    : design.colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
