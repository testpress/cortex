import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import './question_palette_strategy.dart';

class QuestionPaletteLegend extends StatelessWidget {
  final PaletteColorStrategy strategy;

  const QuestionPaletteLegend({super.key, required this.strategy});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = AppLocalizations.of(context)!;
    final entries = strategy.legendEntries(design, l10n);

    // Split entries into rows of 2
    final rows = <List<PaletteLegendEntry>>[];
    for (var i = 0; i < entries.length; i += 2) {
      rows.add(
        entries.sublist(i, i + 2 > entries.length ? entries.length : i + 2),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: design.spacing.lg,
        right: design.spacing.lg,
        bottom: design.spacing.lg,
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) SizedBox(height: design.spacing.sm),
            Row(
              children: rows[i]
                  .map((entry) => _buildEntry(design, entry))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEntry(DesignConfig design, PaletteLegendEntry entry) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(width: 24, height: 24, child: Center(child: entry.shape)),
          const SizedBox(width: 8),
          Expanded(
            child: AppText.caption(
              entry.label,
              color: design.colors.textSecondary,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
