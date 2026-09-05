import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import '../utils/formatters.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/nav_icon.dart';
import '../widgets/section_card.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  CategoryKey _category = CategoryKey.yiyecek;

  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _submit(AppState app) {
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.')) ?? 0;
    app.addExpense(desc: _descCtrl.text, amount: amount, category: _category);
    _descCtrl.clear();
    _amountCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);
    final expenses = app.filteredExpenses;

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
                  Expanded(child: Text('Giderler', style: headingStyle(p, size: 20))),
                  AppButton(
                    label: 'Yeni Gider',
                    palette: p,
                    background: p.tone(SemanticToken.danger),
                    foreground: Colors.white,
                    icon: kIconPlus,
                    onPressed: app.toggleAddExpense,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (app.showAddExpense) ...[
                SectionCard(
                  palette: p,
                  child: StatefulBuilder(
                    builder: (context, setLocal) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            SizedBox(
                              width: 220,
                              child: AppTextField(palette: p, controller: _descCtrl, hint: 'Açıklama'),
                            ),
                            SizedBox(
                              width: 140,
                              child: AppTextField(palette: p, controller: _amountCtrl, hint: 'Tutar (₺)', numeric: true),
                            ),
                            SizedBox(
                              width: 160,
                              child: DropdownButtonFormField<CategoryKey>(
                                initialValue: _category,
                                decoration: const InputDecoration(),
                                dropdownColor: p.surface,
                                style: bodyStyle(p, size: 14),
                                items: kCategoryOrder
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                                    .toList(),
                                onChanged: (v) => setLocal(() => _category = v ?? _category),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppOutlineButton(label: 'İptal', palette: p, onPressed: app.toggleAddExpense),
                            const SizedBox(width: 10),
                            AppButton(
                              label: 'Ekle',
                              palette: p,
                              background: p.tone(SemanticToken.danger),
                              foreground: Colors.white,
                              onPressed: () => _submit(app),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(label: 'Tümü', active: app.expenseFilterCat == 'all', p: p, onTap: () => app.setExpenseFilter('all')),
                    ...kCategoryOrder.map((c) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _FilterChip(
                            label: c.label,
                            active: app.expenseFilterCat == c.name,
                            activeColor: p.tone(c.token),
                            p: p,
                            onTap: () => app.setExpenseFilter(c.name),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SectionCard(
                palette: p,
                padding: EdgeInsets.zero,
                child: expenses.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('Bu kategoride gider yok.', style: bodyStyle(p, size: 13, color: p.textMuted)),
                      )
                    : Column(
                        children: expenses.asMap().entries.map((entry) {
                          final i = entry.key;
                          final ex = entry.value;
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
                                  color: p.softTone(ex.category.token),
                                  child: Icon(iconForCategory(ex.category), size: 16, color: p.onSoftTone(ex.category.token)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ex.desc, style: bodyStyle(p, size: 14)),
                                      Text('${fmtDateShort(ex.date, withYear: true)} · ${ex.category.label}',
                                          style: bodyStyle(p, size: 12, color: p.textMuted)),
                                    ],
                                  ),
                                ),
                                Text('−${fmtTRY(ex.amount)}', style: headingStyle(p, size: 14, weight: FontWeight.w700)),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final Palette p;
  final Color? activeColor;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.active, required this.p, required this.onTap, this.activeColor});

  @override
  Widget build(BuildContext context) {
    final bg = active ? (activeColor ?? p.tone(SemanticToken.primary)) : p.surface;
    return Material(
      color: bg,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: p.border)),
          alignment: Alignment.center,
          child: Text(label, style: bodyStyle(p, size: 12, color: active ? Colors.white : p.textMuted)),
        ),
      ),
    );
  }
}
