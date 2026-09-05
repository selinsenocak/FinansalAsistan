import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import '../utils/formatters.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/nav_icon.dart';
import '../widgets/section_card.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  void _submit(AppState app) {
    final target = double.tryParse(_targetCtrl.text.replaceAll(',', '.')) ?? 0;
    app.addGoal(name: _nameCtrl.text, target: target);
    _nameCtrl.clear();
    _targetCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Hedefler', style: headingStyle(p, size: 20))),
                  AppButton(
                    label: 'Yeni Hedef',
                    palette: p,
                    background: p.tone(SemanticToken.accent),
                    foreground: Colors.white,
                    icon: kIconPlus,
                    onPressed: app.toggleAddGoal,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (app.showAddGoal) ...[
                SectionCard(
                  palette: p,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          SizedBox(width: 220, child: AppTextField(palette: p, controller: _nameCtrl, hint: 'Hedef adı')),
                          SizedBox(width: 160, child: AppTextField(palette: p, controller: _targetCtrl, hint: 'Hedef tutar (₺)', numeric: true)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppOutlineButton(label: 'İptal', palette: p, onPressed: app.toggleAddGoal),
                          const SizedBox(width: 10),
                          AppButton(
                            label: 'Ekle',
                            palette: p,
                            background: p.tone(SemanticToken.accent),
                            foreground: Colors.white,
                            onPressed: () => _submit(app),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ...app.goals.map((g) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SectionCard(
                      palette: p,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(child: Text(g.name, style: headingStyle(p, size: 15, weight: FontWeight.w700))),
                              Text(
                                g.isDone ? 'Tamamlandı' : '%${(g.progress * 100).round()}',
                                style: bodyStyle(
                                  p,
                                  size: 12,
                                  color: g.isDone ? p.onSoftTone(SemanticToken.success) : p.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 8,
                            color: p.divider,
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: g.progress,
                              child: Container(color: p.tone(SemanticToken.accent)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('${fmtTRY(g.current)} / ${fmtTRY(g.target)}', style: bodyStyle(p, size: 12, color: p.textMuted)),
                        ],
                      ),
                    ),
                  )),
              if (app.goals.isEmpty)
                Text('Henüz hedef eklenmedi.', style: bodyStyle(p, size: 13, color: p.textMuted)),
            ],
          ),
        ),
      ],
    );
  }
}
