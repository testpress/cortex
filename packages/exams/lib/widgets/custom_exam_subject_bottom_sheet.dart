import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../models/questionnaire_block.dart';
import '../providers/custom_exam_builder_provider.dart';
import '../providers/custom_exam_config_provider.dart';

class CustomExamSubjectBottomSheet extends ConsumerStatefulWidget {
  final String courseId;
  final VoidCallback onClose;

  const CustomExamSubjectBottomSheet({
    super.key,
    required this.courseId,
    required this.onClose,
  });

  @override
  ConsumerState<CustomExamSubjectBottomSheet> createState() =>
      _CustomExamSubjectBottomSheetState();
}

class _CustomExamSubjectBottomSheetState
    extends ConsumerState<CustomExamSubjectBottomSheet> {
  bool _isAllSelected = true;
  int? _selectedSubjectId;
  int _noOfQuestions = 15;
  final List<String> _selectedDifficulties = [];
  final List<String> _selectedQuestionTypes = [];

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final design = Design.of(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final configAsync = ref.watch(customExamConfigProvider(widget.courseId));
    final builderState = ref.watch(customExamBuilderProvider(widget.courseId));

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
      margin: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.md,
        bottom:
            math.max(
              MediaQuery.viewInsetsOf(context).bottom,
              MediaQuery.paddingOf(context).bottom,
            ) +
            design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
        boxShadow: design.shadows.floating,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag pill
          Center(
            child: Container(
              margin: EdgeInsets.only(top: design.spacing.sm),
              width: design.spacing.xl * 1.5,
              height: 4,
              decoration: BoxDecoration(
                color: design.colors.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(design.radius.full),
              ),
            ),
          ),
          // Scrollable body
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.md,
                design.spacing.md,
                design.spacing.md,
              ),
              child: configAsync.when(
                data: (config) =>
                    _buildContent(context, design, config, builderState),
                loading: () => SizedBox(
                  height: 200,
                  child: Center(
                    child: AppText.body(
                      l10n.labelLoading,
                      color: design.colors.textSecondary,
                    ),
                  ),
                ),
                error: (e, _) => SizedBox(
                  height: 200,
                  child: Center(
                    child: AppText.body(
                      l10n.customExamErrorLoadingConfig,
                      color: design.colors.error,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DesignConfig design,
    CustomTestConfigDto config,
    CustomExamBuilderState builderState,
  ) {
    final l10n = L10n.of(context);
    final parentId = builderState.currentParentSubjectId;
    final currentLevelSubjects = config.subjects
        .where((s) => s.parentId == parentId)
        .toList();

    final parentSubject = parentId != null
        ? config.subjects.firstWhere(
            (s) => s.id == parentId,
            orElse: () => config.subjects.first,
          )
        : null;

    final subjectName = parentSubject != null
        ? l10n.customExamAllOfSubject(parentSubject.name)
        : l10n.customExamAllSubjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        AppSemantics.header(
          label: l10n.customExamAddQuestionnaire,
          child: AppText.title(l10n.customExamAddQuestionnaire),
        ),
        SizedBox(height: design.spacing.lg),

        // ── Subject chips ──────────────────────────────────────────
        _sectionLabel(design, l10n.labelSubject),
        SizedBox(height: design.spacing.sm),
        Wrap(
          spacing: design.spacing.sm,
          runSpacing: design.spacing.sm,
          children: [
            AppChip(
              label: subjectName,
              isSelected: _isAllSelected,
              onTap: () => setState(() {
                _isAllSelected = true;
                _selectedSubjectId = null;
              }),
            ),
            ...currentLevelSubjects.map((sub) {
              final hasChildren = config.subjects.any(
                (s) => s.parentId == sub.id,
              );
              final isSelected =
                  _selectedSubjectId == sub.id && !_isAllSelected;

              return AppChip(
                label: sub.name,
                isSelected: isSelected,
                onTap: () {
                  if (hasChildren) {
                    ref
                        .read(
                          customExamBuilderProvider(widget.courseId).notifier,
                        )
                        .navigateToParentSubject(sub.id);
                    setState(() {
                      _isAllSelected = true;
                      _selectedSubjectId = null;
                    });
                  } else {
                    setState(() {
                      _isAllSelected = false;
                      _selectedSubjectId = sub.id;
                    });
                  }
                },
              );
            }),
          ],
        ),

        if (config.difficultyLevels.isNotEmpty) ...[
          SizedBox(height: design.spacing.lg),
          _sectionLabel(design, l10n.customExamDifficultyLevel),
          SizedBox(height: design.spacing.sm),
          Wrap(
            spacing: design.spacing.sm,
            runSpacing: design.spacing.sm,
            children: config.difficultyLevels.map((diff) {
              final isSelected = _selectedDifficulties.contains(diff.value);
              return AppChip(
                label: diff.label,
                isSelected: isSelected,
                onTap: () => setState(() {
                  if (isSelected) {
                    _selectedDifficulties.remove(diff.value);
                  } else {
                    _selectedDifficulties.add(diff.value);
                  }
                }),
              );
            }).toList(),
          ),
        ],

        if (config.questionTypes.isNotEmpty) ...[
          SizedBox(height: design.spacing.lg),
          _sectionLabel(design, l10n.customExamQuestionTypes),
          SizedBox(height: design.spacing.sm),
          Wrap(
            spacing: design.spacing.sm,
            runSpacing: design.spacing.sm,
            children: config.questionTypes.map((qt) {
              final isSelected = _selectedQuestionTypes.contains(qt.value);
              return AppChip(
                label: qt.label,
                isSelected: isSelected,
                onTap: () => setState(() {
                  if (isSelected) {
                    _selectedQuestionTypes.remove(qt.value);
                  } else {
                    _selectedQuestionTypes.add(qt.value);
                  }
                }),
              );
            }).toList(),
          ),
        ],

        SizedBox(height: design.spacing.lg),
        _sectionLabel(design, l10n.customExamNumberOfQuestions),
        SizedBox(height: design.spacing.sm),
        (() {
          final double maxVal = config.limits.maxQuestionsPerTest < 5
              ? 5.0
              : config.limits.maxQuestionsPerTest.toDouble();
          final double currentVal = _noOfQuestions.toDouble().clamp(
            5.0,
            maxVal,
          );

          return Row(
            children: [
              Expanded(
                child: _SimpleSlider(
                  value: currentVal,
                  min: 5,
                  max: maxVal,
                  divisions: (maxVal - 5) > 0 ? (maxVal - 5).toInt() : 1,
                  onChanged: (val) {
                    setState(() => _noOfQuestions = val.toInt());
                  },
                ),
              ),
              SizedBox(width: design.spacing.md),
              SizedBox(
                width: 48,
                child: AppText.title(
                  currentVal.toInt().toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        })(),

        SizedBox(height: design.spacing.xl),
        AppSemantics.button(
          label: l10n.labelSave,
          onTap: () => _saveBlock(config),
          child: AppButton.primary(
            label: l10n.labelSave,
            fullWidth: true,
            onPressed: () => _saveBlock(config),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(DesignConfig design, String label) {
    return AppText.labelSmall(
      label.toUpperCase(),
      color: design.colors.textTertiary,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  void _saveBlock(CustomTestConfigDto config) {
    final l10n = L10n.of(context);
    final notifier = ref.read(
      customExamBuilderProvider(widget.courseId).notifier,
    );

    final resolvedIds = notifier.resolveSubjectIds(
      isAllSelected: _isAllSelected,
      selectedSubjectId: _selectedSubjectId,
    );

    final builderState = ref.read(customExamBuilderProvider(widget.courseId));
    String subjectName = l10n.customExamAllSubjects;
    if (!_isAllSelected && _selectedSubjectId != null) {
      subjectName = config.subjects
          .firstWhere(
            (s) => s.id == _selectedSubjectId,
            orElse: () => config.subjects.first,
          )
          .name;
    } else if (_isAllSelected && builderState.currentParentSubjectId != null) {
      subjectName = l10n.customExamAllOfSubject(
        config.subjects
            .firstWhere(
              (s) => s.id == builderState.currentParentSubjectId,
              orElse: () => config.subjects.first,
            )
            .name,
      );
    }

    final diffLabels = config.difficultyLevels
        .where((d) => _selectedDifficulties.contains(d.value))
        .map((d) => d.label)
        .toList();

    final typeLabels = config.questionTypes
        .where((q) => _selectedQuestionTypes.contains(q.value))
        .map((q) => q.label)
        .toList();

    notifier.addBlock(
      QuestionnaireBlock(
        subjects: resolvedIds,
        subjectName: subjectName,
        noOfQuestions: _noOfQuestions,
        difficultyLevels: List.from(_selectedDifficulties),
        questionTypes: List.from(_selectedQuestionTypes),
        difficultyLabels: diffLabels,
        questionTypeLabels: typeLabels,
      ),
    );

    widget.onClose();
  }
}

class _SimpleSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const _SimpleSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  State<_SimpleSlider> createState() => _SimpleSliderState();
}

class _SimpleSliderState extends State<_SimpleSlider> {
  void _updateValue(Offset localPosition, double width) {
    if (width <= 0) return;

    double percent = localPosition.dx / width;
    percent = percent.clamp(0.0, 1.0);

    final range = widget.max - widget.min;
    if (range <= 0) return;

    double rawValue = widget.min + (percent * range);

    if (widget.divisions > 0) {
      final step = range / widget.divisions;
      if (step > 0) {
        rawValue = ((rawValue - widget.min) / step).round() * step + widget.min;
      }
    }

    widget.onChanged(rawValue.clamp(widget.min, widget.max));
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final safeRange = widget.max - widget.min;
    final percent = safeRange <= 0
        ? 0.0
        : ((widget.value - widget.min) / safeRange).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbSize = 16.0;
        final trackHeight = 4.0;

        return Semantics(
          slider: true,
          value: widget.value.toStringAsFixed(0),
          onIncrease: () => widget.onChanged(
            (widget.value + 1).clamp(widget.min, widget.max),
          ),
          onDecrease: () => widget.onChanged(
            (widget.value - 1).clamp(widget.min, widget.max),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => _updateValue(d.localPosition, width),
            onPanUpdate: (d) => _updateValue(d.localPosition, width),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Inactive track
                  Container(
                    height: trackHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: design.colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                  // Active track
                  Container(
                    height: trackHeight,
                    width: width * percent,
                    decoration: BoxDecoration(
                      color: design.colors.primary,
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                  // Thumb
                  Positioned(
                    left: (width - thumbSize) * percent,
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: design.colors.primary,
                        shape: BoxShape.circle,
                        boxShadow: design.shadows.floating,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
