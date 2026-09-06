class IncomeEntry {
  final String id;
  final String desc;
  final double amount;
  final DateTime date;

  const IncomeEntry({
    required this.id,
    required this.desc,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'desc': desc,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  factory IncomeEntry.fromJson(Map<String, dynamic> j) => IncomeEntry(
        id: j['id'] as String,
        desc: j['desc'] as String,
        amount: (j['amount'] as num).toDouble(),
        date: DateTime.parse(j['date'] as String),
      );
}
