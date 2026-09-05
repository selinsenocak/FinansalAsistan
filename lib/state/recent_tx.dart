import '../models/category.dart';

/// A unified, display-only view of one income or expense entry, used by
/// the "Son İşlemler" feed on the home screen.
class RecentTx {
  final String desc;
  final DateTime date;
  final bool isIncome;
  final CategoryKey? category;
  final double amount;

  const RecentTx({
    required this.desc,
    required this.date,
    required this.isIncome,
    required this.amount,
    this.category,
  });
}

/// One bucket of a monthly income/expense/balance comparison, used by
/// the Reports table and the Grafikler trend line.
class MonthBucket {
  final int year;
  final int month;
  final String label;
  final double income;
  final double expense;

  const MonthBucket({
    required this.year,
    required this.month,
    required this.label,
    required this.income,
    required this.expense,
  });

  double get balance => income - expense;
}

/// One category's share of the current month's spending, ready to draw.
class CategoryShare {
  final CategoryKey key;
  final double amount;
  final double percent; // 0-100, of total expense

  const CategoryShare({required this.key, required this.amount, required this.percent});
}

/// One category's progress against its monthly budget.
class BudgetCard {
  final CategoryKey key;
  final double spent;
  final double budget;
  final bool over;

  const BudgetCard({required this.key, required this.spent, required this.budget, required this.over});

  double get progress => budget <= 0 ? 0 : (spent / budget).clamp(0, 1);
}
