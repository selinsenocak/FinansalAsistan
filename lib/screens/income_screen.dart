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

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _submit(AppState app) {
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.')) ?? 0;
    app.addIncome(desc: _descCtrl.text, amount: amount);
    _descCtrl.clear();
    _amountCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);
    final incomes = app.sortedIncomes;

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
                  Expanded(child: Text('Gelirler', style: headingStyle(p, size: 20))),
                  AppButton(
                    label: 'Yeni Gelir',
                    palette: p,
                    background: p.tone(SemanticToken.primary),
                    foreground: Colors.white,
                    icon: kIconPlus,
                    onPressed: app.toggleAddIncome,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (app.showAddIncome) ...[
                SectionCard(
                  palette: p,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          SizedBox(
                            width: 260,
                            child: AppTextField(palette: p, controller: _descCtrl, hint: 'Açıklama / Kaynak'),
                          ),
                          SizedBox(
                            width: 160,
                            child: AppTextField(palette: p, controller: _amountCtrl, hint: 'Tutar (₺)', numeric: true),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppOutlineButton(label: 'İptal', palette: p, onPressed: app.toggleAddIncome),
                          const SizedBox(width: 10),
                          AppButton(
                            label: 'Ekle',
                            palette: p,
                            background: p.tone(SemanticToken.primary),
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
              SectionCard(
                palette: p,
                padding: EdgeInsets.zero,
                child: incomes.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('Henüz gelir eklenmedi.', style: bodyStyle(p, size: 13, color: p.textMuted)),
                      )
                    : Column(
                        children: incomes.asMap().entries.map((entry) {
                          final i = entry.key;
                          final inc = entry.value;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: p.divider, width: i == 0 ? 0 : 1)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  color: p.softTone(SemanticToken.success),
                                  child: Icon(kIconIncome, size: 16, color: p.onSoftTone(SemanticToken.success)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(inc.desc, style: bodyStyle(p, size: 14)),
                                      Text(fmtDateShort(inc.date, withYear: true),
                                          style: bodyStyle(p, size: 12, color: p.textMuted)),
                                    ],
                                  ),
                                ),
                                Text(
                                  '+${fmtTRY(inc.amount)}',
                                  style: headingStyle(p, size: 14, weight: FontWeight.w700, color: p.onSoftTone(SemanticToken.success)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
