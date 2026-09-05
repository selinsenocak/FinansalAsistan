import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/budget_screen.dart';
import '../screens/charts_screen.dart';
import '../screens/expenses_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/home_screen.dart';
import '../screens/income_screen.dart';
import '../screens/market_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/settings_screen.dart';
import '../state/app_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import 'nav_icon.dart';

/// The authenticated app frame: a bottom nav bar on narrow (phone-width)
/// windows, a sidebar on wide (web/desktop) ones — one real, responsive
/// layout, rather than the source design's manual mobile/web toggle.
class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({super.key});

  static const _wideBreakpoint = 840.0;

  Widget _screenFor(AppScreen s) {
    return switch (s) {
      AppScreen.home => const HomeScreen(),
      AppScreen.income => const IncomeScreen(),
      AppScreen.expenses => const ExpensesScreen(),
      AppScreen.budget => const BudgetScreen(),
      AppScreen.reports => const ReportsScreen(),
      AppScreen.charts => const ChartsScreen(),
      AppScreen.market => const MarketScreen(),
      AppScreen.goals => const GoalsScreen(),
      AppScreen.settings => const SettingsScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _wideBreakpoint;
        return wide ? _buildWide(context, app, p) : _buildNarrow(context, app, p);
      },
    );
  }

  Widget _buildNarrow(BuildContext context, AppState app, Palette p) {
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.topbar,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Finansal Asistan', style: headingStyle(p, size: 16)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => app.setScreen(AppScreen.settings),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                color: p.softTone(SemanticToken.primary),
                child: Icon(kIconUser, size: 16, color: p.onSoftTone(SemanticToken.primary)),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(top: false, child: _screenFor(app.screen)),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: p.topbar,
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppScreen.values.map((s) {
                final active = app.screen == s;
                final color = active ? p.tone(SemanticToken.primary) : p.textMuted;
                return InkWell(
                  onTap: () => app.setScreen(s),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 64),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(iconForScreen(s), size: 20, color: color),
                        const SizedBox(height: 4),
                        Text(s.label, style: bodyStyle(p, size: 10, color: color)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWide(BuildContext context, AppState app, Palette p) {
    return Scaffold(
      backgroundColor: p.bg,
      body: Row(
        children: [
          Container(
            width: 220,
            color: p.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Text('Finansal Asistan', style: headingStyle(p, size: 16)),
                ),
                ...AppScreen.values.map((s) {
                  final active = app.screen == s;
                  final color = active ? p.tone(SemanticToken.primary) : p.textMuted;
                  return InkWell(
                    onTap: () => app.setScreen(s),
                    child: Container(
                      color: active ? p.surfaceActive : Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Icon(iconForScreen(s), size: 18, color: color),
                          const SizedBox(width: 12),
                          Text(s.label, style: bodyStyle(p, size: 14, color: color)),
                        ],
                      ),
                    ),
                  );
                }),
                const Spacer(),
                InkWell(
                  onTap: app.logout,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Icon(kIconLogout, size: 18, color: p.onSoftTone(SemanticToken.danger)),
                        const SizedBox(width: 12),
                        Text('Çıkış Yap', style: bodyStyle(p, size: 14, color: p.onSoftTone(SemanticToken.danger))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: p.topbar,
                    border: Border(bottom: BorderSide(color: p.divider)),
                  ),
                  child: Row(
                    children: [
                      Text(app.screen.label, style: headingStyle(p, size: 15, weight: FontWeight.w700)),
                      const Spacer(),
                      Text(app.currentUser?.name ?? '', style: bodyStyle(p, size: 13, color: p.textMuted)),
                      const SizedBox(width: 12),
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        color: p.softTone(SemanticToken.primary),
                        child: Icon(kIconUser, size: 16, color: p.onSoftTone(SemanticToken.primary)),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _screenFor(app.screen)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
