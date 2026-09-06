import 'expense_entry.dart';
import 'goal.dart';
import 'income_entry.dart';

/// One demo profile's seed data. Only used to seed an [AccountRecord]
/// (see `account_record.dart`) the first time its ledger is opened —
/// after that, edits are persisted like any other account.
/// `incomes`/`expenses`/`goals` are factories (not fixed lists) so
/// re-seeding always starts from a clean copy.
class DemoUser {
  final String id;
  final String name;
  final String role;
  final List<IncomeEntry> Function() seedIncomes;
  final List<ExpenseEntry> Function() seedExpenses;
  final List<Goal> Function() seedGoals;

  const DemoUser({
    required this.id,
    required this.name,
    required this.role,
    required this.seedIncomes,
    required this.seedExpenses,
    required this.seedGoals,
  });
}
