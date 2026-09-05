import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import '../widgets/nav_icon.dart';
import '../widgets/section_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Ayarlar', style: headingStyle(p, size: 20)),
              const SizedBox(height: 16),
              SectionCard(
                palette: p,
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      color: p.softTone(SemanticToken.primary),
                      child: Icon(kIconUser, size: 22, color: p.onSoftTone(SemanticToken.primary)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.currentUser?.name ?? '',
                            style: headingStyle(p, size: 15, weight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            app.currentUser?.role ?? '',
                            style: bodyStyle(p, size: 12, color: p.textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                palette: p,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 12,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Görünüm', style: headingStyle(p, size: 14, weight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text('Aydınlık veya karanlık mod seçin', style: bodyStyle(p, size: 12, color: p.textMuted)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ModeButton(
                          label: 'Aydınlık',
                          icon: kIconSun,
                          active: !app.isDark,
                          p: p,
                          onTap: () => app.setDark(false),
                        ),
                        _ModeButton(
                          label: 'Karanlık',
                          icon: kIconMoon,
                          active: app.isDark,
                          p: p,
                          onTap: () => app.setDark(true),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Material(
                color: p.softTone(SemanticToken.danger),
                child: InkWell(
                  onTap: app.logout,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(border: Border.all(color: p.border)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(kIconLogout, size: 16, color: p.onSoftTone(SemanticToken.danger)),
                        const SizedBox(width: 8),
                        Text('Çıkış Yap', style: headingStyle(p, size: 14, color: p.onSoftTone(SemanticToken.danger))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Palette p;
  final VoidCallback onTap;

  const _ModeButton({required this.label, required this.icon, required this.active, required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? p.tone(SemanticToken.primary) : p.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: p.border)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: active ? Colors.white : p.textMuted),
              const SizedBox(width: 6),
              Text(label, style: headingStyle(p, size: 12, color: active ? Colors.white : p.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
