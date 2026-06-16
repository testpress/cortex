import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import 'widgets/overall_reports_view.dart';
import 'widgets/individual_reports_view.dart';

enum AnalyticsTab { overall, individual }

class SubjectAnalyticsScreen extends ConsumerStatefulWidget {
  const SubjectAnalyticsScreen({
    super.key,
    this.parentId,
    this.subjectName,
    required this.onBack,
  });

  final String? parentId;
  final String? subjectName;
  final VoidCallback onBack;

  @override
  ConsumerState<SubjectAnalyticsScreen> createState() =>
      _SubjectAnalyticsScreenState();
}

class _SubjectAnalyticsScreenState
    extends ConsumerState<SubjectAnalyticsScreen> {
  AnalyticsTab _activeTab = AnalyticsTab.overall;
  String _selectedFilter = 'All';
  bool _isFilterMenuOpen = false;
  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final title = widget.subjectName ?? l10n.drawerAnalytics;
    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: design.colors.skeleton,
          highlightColor: design.colors.onSkeleton,
          duration: MotionPreferences.duration(
            context,
            const Duration(milliseconds: 800),
          ),
        ),
        ignoreContainers: false,
      ),
      child: Stack(
        children: [
          Container(
            color: design.colors.canvas,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Unified Header Container (White background, same visual section)
                Container(
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    border: Border(
                      bottom: BorderSide(
                        color: design.colors.divider,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Navigation Row: Chevron icon, Title, Filter icon
                        Container(
                          constraints: const BoxConstraints(minHeight: 56),
                          padding: EdgeInsetsDirectional.fromSTEB(
                            design.spacing.md,
                            10.0,
                            design.spacing.screenPadding,
                            10.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: widget.onBack,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 2,
                                  ), // Optical alignment
                                  child: Icon(
                                    LucideIcons.arrowLeft,
                                    color: design.colors.textPrimary,
                                    size: 22,
                                  ),
                                ),
                              ),
                              SizedBox(width: design.spacing.sm),
                              Expanded(
                                child: AppText.title(
                                  title,
                                  color: design.colors.textPrimary,
                                ),
                              ),
                              // Filter icon button — AppSemantics wraps for accessibility label only;
                              // the actual tap is handled solely by AppFocusable inside.
                              AppSemantics.button(
                                label: l10n.analyticsFilterSubjects,
                                child: CompositedTransformTarget(
                                  link: _layerLink,
                                  child: AppFocusable(
                                    onTap: () {
                                      setState(() {
                                        _isFilterMenuOpen = !_isFilterMenuOpen;
                                      });
                                    },
                                    child: Container(
                                      width: 48,
                                      height: 36,
                                      alignment: Alignment.center,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Icon(
                                            LucideIcons.filter,
                                            color: design.colors.textPrimary,
                                            size: design.iconSize.md,
                                          ),
                                          if (_selectedFilter != 'All')
                                            Positioned(
                                              right: -1,
                                              top: -1,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: design.colors.error,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tabs Row: Overall / Individual Report Pills
                        if (widget.parentId == null)
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              design.spacing.md,
                              design.spacing.xs,
                              design.spacing.md,
                              design.spacing.sm,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _TabButton(
                                    label: l10n.analyticsGraphReports,
                                    isActive:
                                        _activeTab == AnalyticsTab.overall,
                                    onTap: () {
                                      setState(() {
                                        _activeTab = AnalyticsTab.overall;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: design.spacing.sm),
                                Expanded(
                                  child: _TabButton(
                                    label: l10n.analyticsTableReports,
                                    isActive:
                                        _activeTab == AnalyticsTab.individual,
                                    onTap: () {
                                      setState(() {
                                        _activeTab = AnalyticsTab.individual;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: _activeTab == AnalyticsTab.overall
                      ? OverallReportsView(
                          parentId: widget.parentId,
                          activeFilter: _selectedFilter,
                        )
                      : IndividualReportsView(
                          parentId: widget.parentId,
                          activeFilter: _selectedFilter,
                        ),
                ),
              ],
            ),
          ),

          // Filter Dropdown Overlay Menu & transparent dismissal barrier
          if (_isFilterMenuOpen) ...[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _isFilterMenuOpen = false;
                });
              },
              child: Container(
                color: design.colors.transparent,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              width: design.spacing.xxxl * 2,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(
                  -(design.spacing.xxxl * 2 - 36.0),
                  design.spacing.xxl + design.spacing.sm,
                ),
                child: _FilterMenu(
                  selectedFilter: _selectedFilter,
                  onFilterSelected: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                      _isFilterMenuOpen = false;
                    });
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppSemantics.button(
      label: l10n.analyticsSelectTab(label),
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: design.spacing.sm + design.spacing.xs / 2,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive
                ? design.colors.primary
                : design.colors.surfaceVariant,
            borderRadius: design.radius.button,
          ),
          child: AppText.label(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: -0.23,
            ),
            color: isActive
                ? design.colors.onPrimary
                : design.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _FilterMenu extends StatelessWidget {
  const _FilterMenu({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  static const List<String> _filterOptions = [
    'All',
    'Correct',
    'Incorrect',
    'Unanswered',
  ];

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      width: design.spacing.xxxl * 2,
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.lg),
        border: Border.all(color: design.colors.border, width: 1.0),
        boxShadow: design.shadows.floating,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < _filterOptions.length; i++)
            _FilterMenuItem(
              label: _filterOptions[i],
              isSelected: selectedFilter == _filterOptions[i],
              onTap: () => onFilterSelected(_filterOptions[i]),
              isFirst: i == 0,
              isLast: i == _filterOptions.length - 1,
            ),
        ],
      ),
    );
  }
}

class _FilterMenuItem extends StatelessWidget {
  const _FilterMenuItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppSemantics.button(
      label: l10n.filterBy(label),
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? design.colors.surfaceVariant
                : design.colors.transparent,
            borderRadius: _menuItemRadius(isFirst, isLast, design.radius.lg),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm + design.spacing.xs,
          ),
          alignment: Alignment.centerLeft,
          child: AppText.label(label, color: design.colors.textPrimary),
        ),
      ),
    );
  }
}

BorderRadius _menuItemRadius(bool isFirst, bool isLast, double radius) {
  return BorderRadius.only(
    topLeft: isFirst ? Radius.circular(radius) : Radius.zero,
    topRight: isFirst ? Radius.circular(radius) : Radius.zero,
    bottomLeft: isLast ? Radius.circular(radius) : Radius.zero,
    bottomRight: isLast ? Radius.circular(radius) : Radius.zero,
  );
}

extension SubjectAnalyticsColors on DesignConfig {
  Color get correctColor => colors.success;
  Color get incorrectColor => colors.error;
  Color get unansweredColor => colors.rank3;
}
