import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/demo_data.dart';
import '../models/app_user.dart';
import '../models/category.dart';
import '../models/demo_user.dart';
import '../models/expense_entry.dart';
import '../models/goal.dart';
import '../models/income_entry.dart';
import '../models/market_quote.dart';
import '../services/market_service.dart';
import '../utils/formatters.dart';
import 'app_screen.dart';
import 'recent_tx.dart';

/// The single source of truth for the whole app: auth/session, theme,
/// current screen, the ledger (incomes/expenses/goals) and the derived
/// numbers every screen renders. One ChangeNotifier kept simple on
/// purpose — this is a prototype-grade app, not a layered architecture.
class AppState extends ChangeNotifier {
  AppState() {
    _loadTheme();
    refreshMarket();
    // Keep the market screen from ever going stale while the app is
    // open — a one-shot fetch at launch is not enough for live quotes.
    _marketTimer = Timer.periodic(const Duration(minutes: 5), (_) => refreshMarket());
  }

  final MarketService _marketService = MarketService();
  Timer? _marketTimer;
  int _idSeq = 0;
  String _nextId(String prefix) => '$prefix-${_idSeq++}-${DateTime.now().microsecondsSinceEpoch}';

  @override
  void dispose() {
    _marketTimer?.cancel();
    super.dispose();
  }

  // ── Theme ──────────────────────────────────────────────────────────
  bool isDark = true;

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool('isDark');
      if (saved != null) {
        isDark = saved;
        notifyListeners();
      }
    } catch (_) {
      // No persistence available (e.g. some web/test contexts) — the
      // in-memory default stands for this session.
    }
  }

  void setDark(bool value) {
    if (isDark == value) return;
    isDark = value;
    notifyListeners();
    _saveTheme();
  }

  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDark', isDark);
    } catch (_) {}
  }

  // ── Auth ───────────────────────────────────────────────────────────
  bool authed = false;
  AuthMode authMode = AuthMode.login;
  AppUser? currentUser;

  List<IncomeEntry> incomes = [];
  List<ExpenseEntry> expenses = [];
  List<Goal> goals = [];

  void setAuthMode(AuthMode mode) {
    authMode = mode;
    notifyListeners();
  }

  void loginWithDemo(DemoUser user) {
    currentUser = user.toAppUser();
    incomes = user.seedIncomes();
    expenses = user.seedExpenses();
    goals = user.seedGoals();
    _resetSession();
  }

  /// The plain email/password "Giriş Yap" form has no real backend in
  /// this prototype — it signs the visitor into the first demo profile
  /// so the app always has data to show.
  void loginGeneric() => loginWithDemo(kDemoUsers.first);

  void signup(String name) {
    final display = name.trim().isEmpty ? 'Kullanıcı' : name.trim();
    currentUser = AppUser(id: _nextId('user'), name: display, role: 'Yeni kullanıcı');
    incomes = [];
    expenses = [];
    goals = [];
    _resetSession();
  }

  void _resetSession() {
    authed = true;
    screen = AppScreen.home;
    expenseFilterCat = 'all';
    chartView = ChartView.trend;
    showAddIncome = false;
    showAddExpense = false;
    showAddGoal = false;
    notifyListeners();
  }

  void logout() {
    authed = false;
    currentUser = null;
    authMode = AuthMode.login;
    incomes = [];
    expenses = [];
    goals = [];
    screen = AppScreen.home;
    notifyListeners();
  }

  // ── Navigation ─────────────────────────────────────────────────────
  AppScreen screen = AppScreen.home;

  void setScreen(AppScreen s) {
    screen = s;
    notifyListeners();
  }

  // ── Ledger UI state ────────────────────────────────────────────────
  String expenseFilterCat = 'all';
  ChartView chartView = ChartView.trend;
  bool showAddIncome = false;
  bool showAddExpense = false;
  bool showAddGoal = false;

  void setExpenseFilter(String catOrAll) {
    expenseFilterCat = catOrAll;
    notifyListeners();
  }

  void setChartView(ChartView v) {
    chartView = v;
    notifyListeners();
  }

  void toggleAddIncome() {
    showAddIncome = !showAddIncome;
    notifyListeners();
  }

  void toggleAddExpense() {
    showAddExpense = !showAddExpense;
    notifyListeners();
  }

  void toggleAddGoal() {
    showAddGoal = !showAddGoal;
    notifyListeners();
  }

  void addIncome({required String desc, required double amount}) {
    if (desc.trim().isEmpty || amount <= 0) return;
    incomes = [
      IncomeEntry(id: _nextId('inc'), desc: desc.trim(), amount: amount, date: DateTime.now()),
      ...incomes,
    ];
    showAddIncome = false;
    notifyListeners();
  }

  void addExpense({required String desc, required double amount, required CategoryKey category}) {
    if (desc.trim().isEmpty || amount <= 0) return;
    expenses = [
      ExpenseEntry(id: _nextId('exp'), desc: desc.trim(), amount: amount, date: DateTime.now(), category: category),
      ...expenses,
    ];
    showAddExpense = false;
    notifyListeners();
  }

  void addGoal({required String name, required double target}) {
    if (name.trim().isEmpty || target <= 0) return;
    goals = [...goals, Goal(id: _nextId('goal'), name: name.trim(), target: target)];
    showAddGoal = false;
    notifyListeners();
  }

  // ── Market data ────────────────────────────────────────────────────
  List<MarketQuote> market = MarketQuote.demoFallback();
  bool marketLoading = false;
  DateTime marketUpdatedAt = DateTime.now();

  Future<void> refreshMarket() async {
    marketLoading = true;
    notifyListeners();
    final quotes = await _marketService.fetchQuotes();
    market = quotes;
    marketLoading = false;
    marketUpdatedAt = DateTime.now();
    notifyListeners();
  }

  String get marketUpdatedLabel =>
      '${fmtDateFull(marketUpdatedAt)}, '
      '${marketUpdatedAt.hour.toString().padLeft(2, '0')}:${marketUpdatedAt.minute.toString().padLeft(2, '0')}';

  // ── Derived numbers ────────────────────────────────────────────────

  /// The "current" period is the latest month present in the ledger
  /// (not the wall clock) — so a fresh sign-up, or this app opened long
  /// after the seed data's dates, still shows a sensible period rather
  /// than an all-zero month.
  DateTime get _periodAnchor {
    DateTime? latest;
    for (final e in incomes) {
      if (latest == null || e.date.isAfter(latest)) latest = e.date;
    }
    for (final e in expenses) {
      if (latest == null || e.date.isAfter(latest)) latest = e.date;
    }
    return latest ?? DateTime.now();
  }

  bool _inPeriod(DateTime d, int year, int month) => d.year == year && d.month == month;

  Iterable<IncomeEntry> get _currentIncomes {
    final a = _periodAnchor;
    return incomes.where((e) => _inPeriod(e.date, a.year, a.month));
  }

  Iterable<ExpenseEntry> get _currentExpenses {
    final a = _periodAnchor;
    return expenses.where((e) => _inPeriod(e.date, a.year, a.month));
  }

  double get totalIncome => _currentIncomes.fold(0.0, (s, e) => s + e.amount);
  double get totalExpense => _currentExpenses.fold(0.0, (s, e) => s + e.amount);
  double get balance => totalIncome - totalExpense;
  double get savingsRate => totalIncome == 0 ? 0 : (balance / totalIncome * 100);

  Map<CategoryKey, double> get categoryTotals {
    final totals = {for (final c in kCategoryOrder) c: 0.0};
    for (final e in _currentExpenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  List<CategoryShare> get categoryShares {
    final totals = categoryTotals;
    final total = totalExpense;
    return kCategoryOrder
        .map((c) => CategoryShare(
              key: c,
              amount: totals[c] ?? 0,
              percent: total == 0 ? 0 : (totals[c] ?? 0) / total * 100,
            ))
        .toList();
  }

  List<BudgetCard> get budgetCards {
    final totals = categoryTotals;
    return kCategoryOrder.map((c) {
      final spent = totals[c] ?? 0;
      final budget = kMonthlyBudgets[c] ?? 0;
      return BudgetCard(key: c, spent: spent, budget: budget, over: spent > budget);
    }).toList();
  }

  /// The 3 calendar months ending at the current period, oldest first —
  /// used by Reports (table) and Grafikler (trend line).
  List<MonthBucket> get monthlyHistory {
    final anchor = _periodAnchor;
    final months = List.generate(3, (i) {
      final m = DateTime(anchor.year, anchor.month - (2 - i), 1);
      return m;
    });
    return months.map((m) {
      final inc = incomes
          .where((e) => _inPeriod(e.date, m.year, m.month))
          .fold(0.0, (s, e) => s + e.amount);
      final exp = expenses
          .where((e) => _inPeriod(e.date, m.year, m.month))
          .fold(0.0, (s, e) => s + e.amount);
      return MonthBucket(
        year: m.year,
        month: m.month,
        label: kTurkishMonthsShort[m.month - 1],
        income: inc,
        expense: exp,
      );
    }).toList();
  }

  /// The most recent 5 transactions (income or expense), newest first.
  List<RecentTx> get recentTransactions {
    final all = <RecentTx>[
      ...incomes.map((e) => RecentTx(desc: e.desc, date: e.date, isIncome: true, amount: e.amount)),
      ...expenses.map((e) => RecentTx(
            desc: e.desc,
            date: e.date,
            isIncome: false,
            amount: e.amount,
            category: e.category,
          )),
    ];
    all.sort((a, b) => b.date.compareTo(a.date));
    return all.take(5).toList();
  }

  List<ExpenseEntry> get filteredExpenses {
    final sorted = [...expenses]..sort((a, b) => b.date.compareTo(a.date));
    if (expenseFilterCat == 'all') return sorted;
    return sorted.where((e) => e.category.name == expenseFilterCat).toList();
  }

  List<IncomeEntry> get sortedIncomes => [...incomes]..sort((a, b) => b.date.compareTo(a.date));
}
