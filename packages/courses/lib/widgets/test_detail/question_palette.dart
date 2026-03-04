import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart' show Colors, FontWeight;
import '../../models/test_model.dart';
import './palette_shapes.dart';

class QuestionPalette extends StatelessWidget {
  final List<TestQuestion> questions;
  final Map<String, TestAttemptAnswer> answers;
  final int currentIndex;
  final Function(int) onQuestionSelected;
  final VoidCallback onClose;

  const QuestionPalette({
    super.key,
    required this.questions,
    required this.answers,
    required this.currentIndex,
    required this.onQuestionSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final answeredCount = answers.values
        .where((a) => a.selectedOptions.isNotEmpty)
        .length;

    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            onTap: onClose,
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: design.colors.card,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(design.radius.xl),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(design.spacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.headline(
                              l10n.testPaletteTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppText.caption(
                              l10n.testPaletteAnsweredCount(
                                answeredCount,
                                questions.length,
                              ),
                              color: design.colors.textSecondary,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: onClose,
                          child: Icon(
                            LucideIcons.x,
                            color: design.colors.textSecondary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPaletteLegend(design, l10n),
                  Container(height: 1, color: design.colors.border),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(design.spacing.lg),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        final answer = answers[question.id];
                        return _buildPaletteItem(design, index, answer);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaletteItem(
    DesignConfig design,
    int index,
    TestAttemptAnswer? answer,
  ) {
    final isSelected = answer != null && answer.selectedOptions.isNotEmpty;
    final isMarked = answer?.isMarked ?? false;
    const double baseSize = 44.0;
    Widget shape;

    if (isSelected && isMarked) {
      shape = HexagonShape(
        size: baseSize,
        color: design.colors.success,
        child: _buildNumber(index, design.colors.textInverse),
      );
    } else if (isMarked) {
      shape = DiamondShape(
        size: baseSize / 1.414,
        color: design.colors.accent3,
        child: _buildNumber(index, design.colors.textInverse),
      );
    } else if (isSelected) {
      shape = CircleShape(
        size: baseSize,
        color: design.colors.success,
        child: _buildNumber(index, design.colors.textInverse),
      );
    } else {
      shape = SquareShape(
        size: baseSize,
        borderColor: design.colors.border,
        child: _buildNumber(index, design.colors.textSecondary),
      );
    }

    return GestureDetector(
      onTap: () => onQuestionSelected(index),
      child: Center(child: shape),
    );
  }

  Widget _buildNumber(int index, Color color) {
    return Center(
      child: AppText.label(
        '${index + 1}',
        color: color,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildPaletteLegend(DesignConfig design, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.only(
        left: design.spacing.lg,
        right: design.spacing.lg,
        bottom: design.spacing.lg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildLegendItem(
                design,
                CircleShape(borderColor: design.colors.border, size: 18),
                l10n.testStatusNotVisited,
              ),
              SizedBox(width: design.spacing.md),
              _buildLegendItem(
                design,
                CircleShape(color: design.colors.success, size: 18),
                l10n.testStatusAnswered,
              ),
            ],
          ),
          SizedBox(height: design.spacing.sm),
          Row(
            children: [
              _buildLegendItem(
                design,
                DiamondShape(color: design.colors.accent3, size: 18),
                l10n.testStatusMarked,
              ),
              SizedBox(width: design.spacing.md),
              _buildLegendItem(
                design,
                HexagonShape(color: design.colors.success, size: 18),
                l10n.testStatusAnsweredMarked,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(DesignConfig design, Widget shape, String label) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(width: 24, height: 24, child: Center(child: shape)),
          const SizedBox(width: 8),
          AppText.caption(
            label,
            color: design.colors.textSecondary,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
