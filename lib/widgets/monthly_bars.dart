import 'package:flutter/material.dart';

import '../state/recent_tx.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';

/// Grouped income/expense bars, one pair per month — the Reports
/// screen's "Gelir / Gider Karşılaştırması" chart.
class MonthlyBars extends StatelessWidget {
  final Palette palette;
  final List<MonthBucket> months;
  final double maxHeight;

  const MonthlyBars({super.key, required this.palette, required this.months, this.maxHeight = 130});

  @override
  Widget build(BuildContext context) {
    final maxVal = months.fold<double>(
      1,
      (m, b) => [b.income, b.expense, m].reduce((a, c) => a > c ? a : c),
    );
    final primary = palette.tone(SemanticToken.primary);
    final danger = palette.tone(SemanticToken.danger);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: months
              .map((b) => Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: maxHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(width: 20, height: maxHeight * (b.income / maxVal), color: primary),
                              const SizedBox(width: 4),
                              Container(width: 20, height: maxHeight * (b.expense / maxVal), color: danger),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(b.label, style: bodyStyle(palette, size: 12, color: palette.textMuted)),
                      ],
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _legendDot(primary, 'Gelir'),
            const SizedBox(width: 20),
            _legendDot(danger, 'Gider'),
          ],
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 6),
        Text(label, style: bodyStyle(palette, size: 12, color: palette.textMuted)),
      ],
    );
  }
}
