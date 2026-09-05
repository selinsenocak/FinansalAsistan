import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../state/app_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import '../utils/formatters.dart';
import '../widgets/section_card.dart';
import '../widgets/trend_chart.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);
    final months = app.monthlyHistory;
    final shares = app.categoryShares;
    final isTrend = app.chartView == ChartView.trend;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Grafikler', style: headingStyle(p, size: 20)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _Tab(label: 'Aylık Trend', active: isTrend, p: p, onTap: () => app.setChartView(ChartView.trend)),
              const SizedBox(width: 8),
              _Tab(label: 'Kategori Dağılımı', active: !isTrend, p: p, onTap: () => app.setChartView(ChartView.category)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isTrend)
          SectionCard(
            palette: p,
            child: Column(
              children: [
                TrendChart(
                  income: months.map((m) => m.income).toList(),
                  expense: months.map((m) => m.expense).toList(),
                  incomeColor: p.tone(SemanticToken.primary),
                  expenseColor: p.tone(SemanticToken.danger),
                  gridColor: p.chartGrid,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _legend(p, p.tone(SemanticToken.primary), 'Gelir'),
                    const SizedBox(width: 20),
                    _legend(p, p.tone(SemanticToken.danger), 'Gider'),
                  ],
                ),
              ],
            ),
          )
        else
          SectionCard(
            palette: p,
            child: Column(
              children: shares
                  .map((s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(width: 90, child: Text(s.key.label, style: bodyStyle(p, size: 13))),
                            Expanded(
                              child: Container(
                                height: 14,
                                color: p.divider,
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: (s.percent / 100).clamp(0, 1),
                                  child: Container(color: p.tone(s.key.token)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              child: Text(fmtTRY(s.amount), textAlign: TextAlign.right, style: bodyStyle(p, size: 12, color: p.textMuted)),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _legend(Palette p, Color color, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, color: color),
          const SizedBox(width: 6),
          Text(label, style: bodyStyle(p, size: 12, color: p.textMuted)),
        ],
      );
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final Palette p;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? p.tone(SemanticToken.primary) : p.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: p.border)),
          child: Text(label, style: headingStyle(p, size: 12, color: active ? Colors.white : p.textMuted)),
        ),
      ),
    );
  }
}
