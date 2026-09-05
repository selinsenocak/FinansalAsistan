import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import '../utils/formatters.dart';
import '../widgets/monthly_bars.dart';
import '../widgets/section_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);
    final months = app.monthlyHistory;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Raporlar', style: headingStyle(p, size: 20)),
        const SizedBox(height: 16),
        SectionCard(
          palette: p,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: p.divider, width: 2))),
                child: Row(
                  children: [
                    _headCell(p, 'Ay'),
                    _headCell(p, 'Gelir'),
                    _headCell(p, 'Gider'),
                    _headCell(p, 'Bakiye'),
                  ],
                ),
              ),
              ...months.map((m) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: p.divider))),
                    child: Row(
                      children: [
                        _cell(p, m.label),
                        _cell(p, fmtTRY(m.income)),
                        _cell(p, fmtTRY(m.expense)),
                        _cell(
                          p,
                          fmtTRY(m.balance),
                          color: m.balance >= 0 ? p.onSoftTone(SemanticToken.success) : p.onSoftTone(SemanticToken.danger),
                          bold: true,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          palette: p,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gelir / Gider Karşılaştırması', style: headingStyle(p, size: 14)),
              const SizedBox(height: 16),
              MonthlyBars(palette: p, months: months),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headCell(Palette p, String text) => Expanded(
        child: Text(text.toUpperCase(), style: bodyStyle(p, size: 11, color: p.textMuted, weight: FontWeight.w600)),
      );

  Widget _cell(Palette p, String text, {Color? color, bool bold = false}) => Expanded(
        child: Text(
          text,
          style: bold
              ? headingStyle(p, size: 13, weight: FontWeight.w700, color: color)
              : bodyStyle(p, size: 13, color: color ?? p.textHeading),
        ),
      );
}
