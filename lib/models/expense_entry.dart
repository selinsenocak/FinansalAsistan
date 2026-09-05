import 'category.dart';

class ExpenseEntry {
  final String id;
  final String desc;
  final double amount;
  final DateTime date;
  final CategoryKey category;

  const ExpenseEntry({
    required this.id,
    required this.desc,
    required this.amount,
    required this.date,
    required this.category,
  });
}
