import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/market_quote.dart';

/// Fetches live FX rates for the market screen. Uses the free,
/// no-key `@fawazahmed0/currency-api` mirror on jsDelivr (see
/// uploads/intent-2.md §7) for USD/TRY and EUR/TRY, comparing today's
/// rate against yesterday's dated snapshot for the change percentage.
///
/// Gold and BIST 100 have no equivalent free, keyless public endpoint,
/// so they stay on the bundled reference values below — wire a real
/// provider in here when one is available. If any request fails (no
/// network, the mirror is down, …) the whole call falls back to the
/// bundled numbers, so the screen is never left blank.
class MarketService {
  static const _base = 'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api';

  Future<List<MarketQuote>> fetchQuotes() async {
    final fallback = MarketQuote.demoFallback();
    try {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      final results = await Future.wait([
        _rate(today, 'usd', 'try'),
        _rate(yesterday, 'usd', 'try'),
        _rate(today, 'eur', 'try'),
        _rate(yesterday, 'eur', 'try'),
      ]);

      return [
        _quote(fallback[0], results[0], results[1]),
        _quote(fallback[1], results[2], results[3]),
        fallback[2], // Altın — bundled reference value
        fallback[3], // BIST 100 — bundled reference value
      ];
    } catch (e, st) {
      debugPrint('[MarketService] fetchQuotes failed: $e\n$st');
      return fallback;
    }
  }

  MarketQuote _quote(MarketQuote fallback, double? now, double? prev) {
    if (now == null) return fallback;
    final change =
        (prev != null && prev != 0) ? (now - prev) / prev * 100 : fallback.changePct;
    return fallback.copyWith(value: now, changePct: change, isLive: true);
  }

  Future<double?> _rate(DateTime date, String base, String target) async {
    try {
      final stamp = '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
      final uri = Uri.parse('$_base@$stamp/v1/currencies/$base.json');
      final res = await http.get(uri).timeout(const Duration(seconds: 6));
      if (res.statusCode != 200) {
        debugPrint('[MarketService] $uri -> HTTP ${res.statusCode}');
        return null;
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final rates = body[base] as Map<String, dynamic>?;
      final value = rates?[target];
      return value == null ? null : (value as num).toDouble();
    } catch (e) {
      debugPrint('[MarketService] _rate($base->$target, $date) failed: $e');
      return null;
    }
  }
}
