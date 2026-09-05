import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import '../utils/formatters.dart';
import '../widgets/section_card.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);
    final cards = app.budgetCards;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Bütçe', style: headingStyle(p, size: 20)),
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth > 720 ? 3 : (c.maxWidth > 460 ? 2 : 1);
          return GridView.count(
            crossAxisCount: cols,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 2.0,
            children: cards.map((b) {
              final barColor = b.over ? p.tone(SemanticToken.danger) : p.tone(b.key.token);
              final statusColor = b.over ? p.onSoftTone(SemanticToken.danger) : p.textMuted;
              final statusLabel = b.over ? 'Bütçe aşıldı' : '%${(b.progress * 100).round()} kullanıldı';
              return SectionCard(
                palette: p,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(child: Text(b.key.label, style: headingStyle(p, size: 14, weight: FontWeight.w700))),
                        Text('${fmtTRY(b.spent)} / ${fmtTRY(b.budget)}',
                            style: bodyStyle(p, size: 12, color: p.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            height: 8,
                            color: p.divider,
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: b.progress,
                              child: Container(color: barColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(statusLabel, style: bodyStyle(p, size: 12, color: statusColor)),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
