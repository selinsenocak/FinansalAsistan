import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import '../widgets/section_card.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);

    return RefreshIndicator(
      onRefresh: app.refreshMarket,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(child: Text('Piyasa', style: headingStyle(p, size: 20))),
              IconButton(
                onPressed: app.marketLoading ? null : app.refreshMarket,
                icon: app.marketLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: p.textMuted),
                      )
                    : Icon(Icons.refresh, color: p.textMuted),
              ),
            ],
          ),
          Text('Son güncelleme: ${app.marketUpdatedLabel}', style: bodyStyle(p, size: 12, color: p.textMuted)),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 720 ? 4 : (c.maxWidth > 460 ? 2 : 1);
            return GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 110,
              ),
              children: app.market
                  .map((m) => SectionCard(
                        palette: p,
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(m.symbol, style: bodyStyle(p, size: 13, color: p.textMuted)),
                            const SizedBox(height: 6),
                            Text(m.valueLabel, style: headingStyle(p, size: 22)),
                            const SizedBox(height: 4),
                            Text(
                              m.changeLabel,
                              style: bodyStyle(
                                p,
                                size: 13,
                                weight: FontWeight.w700,
                                color: m.changePct >= 0
                                    ? p.onSoftTone(SemanticToken.success)
                                    : p.onSoftTone(SemanticToken.danger),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            );
          }),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            color: p.softTone(SemanticToken.info),
            child: Text(
              'Bu bir finansal danışmanlık değildir, bilgilendirme amaçlıdır.',
              style: bodyStyle(p, size: 13, color: p.onSoftTone(SemanticToken.info)),
            ),
          ),
        ],
      ),
    );
  }
}
