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

  Map<String, dynamic> toJson() => {
        'id': id,
        'desc': desc,
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category.name,
      };

  factory ExpenseEntry.fromJson(Map<String, dynamic> j) => ExpenseEntry(
        id: j['id'] as String,
        desc: j['desc'] as String,
        amount: (j['amount'] as num).toDouble(),
        date: DateTime.parse(j['date'] as String),
        category: CategoryKey.values.byName(j['category'] as String),
      );
}
