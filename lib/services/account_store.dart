import 'dart:convert';

import '../models/account_record.dart';
import '../models/expense_entry.dart';
import '../models/goal.dart';
import '../models/income_entry.dart';
import 'prefs.dart';

/// One account's gelir/gider/hedef ledger, as loaded from or about to be
/// saved to local storage.
class LedgerData {
  final List<IncomeEntry> incomes;
  final List<ExpenseEntry> expenses;
  final List<Goal> goals;

  const LedgerData({required this.incomes, required this.expenses, required this.goals});
}

/// Persists the account list and each account's ledger in the browser's
/// local storage (via `shared_preferences`, which maps to `localStorage`
/// on web). There is no server — everything lives in this browser only,
/// which is what lets "Hesabı Sil" be a real, permanent delete.
class AccountStore {
  static const _indexKey = 'finansal_asistan.accounts_v1';
  static String _ledgerKey(String id) => 'finansal_asistan.ledger_v1.$id';

  Future<List<AccountRecord>> loadIndex() async {
    try {
      final prefs = await getPrefs();
      final raw = prefs.getString(_indexKey);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List;
      return list.map((e) => AccountRecord.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveIndex(List<AccountRecord> accounts) async {
    try {
      final prefs = await getPrefs();
      await prefs.setString(_indexKey, jsonEncode(accounts.map((a) => a.toJson()).toList()));
    } catch (_) {
      // No persistence available in this context — the in-memory list
      // still works for the current session.
    }
  }

  Future<LedgerData?> loadLedger(String id) async {
    try {
      final prefs = await getPrefs();
      final raw = prefs.getString(_ledgerKey(id));
      if (raw == null) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return LedgerData(
        incomes: (map['incomes'] as List).map((e) => IncomeEntry.fromJson(e as Map<String, dynamic>)).toList(),
        expenses: (map['expenses'] as List).map((e) => ExpenseEntry.fromJson(e as Map<String, dynamic>)).toList(),
        goals: (map['goals'] as List).map((e) => Goal.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLedger(String id, LedgerData data) async {
    try {
      final prefs = await getPrefs();
      await prefs.setString(
        _ledgerKey(id),
        jsonEncode({
          'incomes': data.incomes.map((e) => e.toJson()).toList(),
          'expenses': data.expenses.map((e) => e.toJson()).toList(),
          'goals': data.goals.map((e) => e.toJson()).toList(),
        }),
      );
    } catch (_) {}
  }

  Future<void> deleteLedger(String id) async {
    try {
      final prefs = await getPrefs();
      await prefs.remove(_ledgerKey(id));
    } catch (_) {}
  }
}
