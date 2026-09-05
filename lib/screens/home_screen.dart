import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import '../utils/formatters.dart';
import '../widgets/donut_chart.dart';
import '../widgets/nav_icon.dart';
import '../widgets/section_card.dart';
import '../widgets/stat_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);
    final shares = app.categoryShares;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(fmtDateFull(DateTime.now()), style: bodyStyle(p, size: 13, color: p.textMuted)),
        const SizedBox(height: 2),
        Text('Merhaba, ${app.currentUser?.name ?? ''}', style: headingStyle(p, size: 24)),
        const SizedBox(height: 20),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth > 720 ? 4 : (c.maxWidth > 460 ? 2 : 1);
          final tiles = [
            StatTile(palette: p, label: 'Toplam Gelir', value: fmtTRY(app.totalIncome)),
            StatTile(palette: p, label: 'Toplam Gider', value: fmtTRY(app.totalExpense)),
            StatTile(
              palette: p,
              label: 'Bakiye',
              value: fmtTRY(app.balance),
              valueColor: p.onSoftTone(SemanticToken.primary),
            ),
            StatTile(
              palette: p,
              label: 'Tasarruf Oranı',
              value: fmtPct(app.savingsRate),
              valueColor: p.onSoftTone(SemanticToken.accent),
            ),
          ];
          return GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 100,
            ),
            children: tiles,
          );
        }),
        const SizedBox(height: 20),
        SectionCard(
          palette: p,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Harcama Dağılımı', style: headingStyle(p, size: 15)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        DonutChart(
                          values: shares.map((s) => s.amount).toList(),
                          colors: shares.map((s) => p.tone(s.key.token)).toList(),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Toplam', style: bodyStyle(p, size: 11, color: p.textMuted)),
                            Text(fmtTRY(app.totalExpense), style: headingStyle(p, size: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 160),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: shares
                          .map((s) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(width: 10, height: 10, color: p.tone(s.key.token)),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(s.key.label, style: bodyStyle(p, size: 13))),
                                    Text('${s.percent.round()}%', style: bodyStyle(p, size: 13, color: p.textMuted)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          palette: p,
          padding: const EdgeInsets.only(top: 20, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Son İşlemler', style: headingStyle(p, size: 15)),
              ),
              const SizedBox(height: 8),
              if (app.recentTransactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Text('Henüz işlem yok.', style: bodyStyle(p, size: 13, color: p.textMuted)),
                )
              else
                ...app.recentTransactions.map((tx) {
                  final token = tx.isIncome ? SemanticToken.success : (tx.category?.token ?? SemanticToken.info);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: p.divider))),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          color: p.softTone(token),
                          child: Icon(
                            tx.isIncome ? kIconIncome : iconForCategory(tx.category!),
                            size: 16,
                            color: p.onSoftTone(token),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tx.desc, style: bodyStyle(p, size: 14), overflow: TextOverflow.ellipsis),
                              Text(fmtDateShort(tx.date), style: bodyStyle(p, size: 12, color: p.textMuted)),
                            ],
                          ),
                        ),
                        Text(
                          '${tx.isIncome ? '+' : '−'}${fmtTRY(tx.amount)}',
                          style: headingStyle(
                            p,
                            size: 14,
                            weight: FontWeight.w700,
                            color: tx.isIncome ? p.onSoftTone(SemanticToken.success) : p.textHeading,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SectionCard(
          palette: p,
          padding: const EdgeInsets.only(top: 20, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Piyasa Özeti', style: headingStyle(p, size: 15)),
              ),
              const SizedBox(height: 12),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 76,
                ),
                children: app.market
                    .map((m) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(m.symbol, style: bodyStyle(p, size: 12, color: p.textMuted)),
                              Text(m.valueLabel, style: headingStyle(p, size: 15)),
                              Text(
                                m.changeLabel,
                                style: bodyStyle(
                                  p,
                                  size: 12,
                                  color: m.changePct >= 0
                                      ? p.onSoftTone(SemanticToken.success)
                                      : p.onSoftTone(SemanticToken.danger),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
