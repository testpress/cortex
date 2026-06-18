import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class HierarchicalTopicPicker extends ConsumerStatefulWidget {
  final void Function(int? topicId, {required bool isFinalized})
  onTopicFinalized;

  const HierarchicalTopicPicker({super.key, required this.onTopicFinalized});

  @override
  ConsumerState<HierarchicalTopicPicker> createState() =>
      _HierarchicalTopicPickerState();
}

class _HierarchicalTopicPickerState
    extends ConsumerState<HierarchicalTopicPicker> {
  final List<DoubtTopicDto> _topicPath = [];
  int? _selectedChipId; // The ID of the leaf node or -1 for "I don't know"

  void _onTopicTapped(DoubtTopicDto topic) {
    if (topic.hasChildren) {
      setState(() {
        _topicPath.add(topic);
        _selectedChipId = null;
      });
      widget.onTopicFinalized(null, isFinalized: false);
    } else {
      setState(() {
        _selectedChipId = topic.id;
      });
      widget.onTopicFinalized(topic.id, isFinalized: true);
    }
  }

  void _onIdkTapped() {
    setState(() {
      _selectedChipId = -1;
    });
    widget.onTopicFinalized(_topicPath.lastOrNull?.id, isFinalized: true);
  }

  void _onBreadcrumbTapped(int index) {
    // -1 means "Topics" (root)
    setState(() {
      _selectedChipId = null;
      if (index == -1) {
        _topicPath.clear();
      } else {
        _topicPath.removeRange(index + 1, _topicPath.length);
      }
    });
    widget.onTopicFinalized(null, isFinalized: false);
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final currentParentId = _topicPath.lastOrNull?.id;
    final topicsAsync = ref.watch(doubtSubtopicsProvider(currentParentId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Breadcrumbs
        Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppFocusable(
              onTap: _topicPath.isNotEmpty
                  ? () => _onBreadcrumbTapped(-1)
                  : null,
              child: AppText.bodySmall(
                'Topics',
                color: _topicPath.isEmpty
                    ? design.colors.textPrimary
                    : design.colors.textSecondary,
                style: TextStyle(
                  fontWeight: _topicPath.isEmpty
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            for (int i = 0; i < _topicPath.length; i++) ...[
              Icon(
                LucideIcons.chevronRight,
                size: 14,
                color: design.colors.textTertiary,
              ),
              AppFocusable(
                onTap: i < _topicPath.length - 1
                    ? () => _onBreadcrumbTapped(i)
                    : null,
                child: AppText.bodySmall(
                  _topicPath[i].title,
                  color: i == _topicPath.length - 1
                      ? design.colors.textPrimary
                      : design.colors.textSecondary,
                  style: TextStyle(
                    fontWeight: i == _topicPath.length - 1
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // Chips
        topicsAsync.when(
          data: (topics) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...topics.map((topic) {
                  final isSelected = _selectedChipId == topic.id;
                  return AppChip(
                    label: topic.title,
                    isSelected: isSelected,
                    onTap: () => _onTopicTapped(topic),
                  );
                }),
                AppChip(
                  label: 'I don\'t know',
                  isSelected: _selectedChipId == -1,
                  onTap: _onIdkTapped,
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: AppLoadingIndicator()),
          ),
          error: (e, s) => AppText.bodySmall(
            'Failed to load topics',
            color: design.colors.textTertiary,
          ),
        ),
      ],
    );
  }
}
