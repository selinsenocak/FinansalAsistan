import 'app_user.dart';
import 'expense_entry.dart';
import 'goal.dart';
import 'income_entry.dart';

/// One selectable demo account on the auth screen. `incomes`/`expenses`/
/// `goals` are factories (not fixed lists) so every login starts from a
/// clean copy of the seed data, even if a previous session edited it.
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

  AppUser toAppUser() => AppUser(id: id, name: name, role: role, isDemo: true);
}
