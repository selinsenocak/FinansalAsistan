import 'package:intl/intl.dart';

/// Turkish month abbreviations, used for compact date/period labels
/// throughout the app (e.g. "05 Eyl", "Ağu").
const List<String> kTurkishMonthsShort = [
  'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
  'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
];

/// Formats a whole-number Turkish Lira amount, e.g. 42000 -> "42.000 ₺".
String fmtTRY(num amount) {
  final formatted = NumberFormat.decimalPattern('tr_TR').format(amount.round());
  return '$formatted ₺';
}

/// Formats a Turkish Lira amount with 2 decimals, e.g. 34.82 -> "34,82 ₺".
String fmtTRY2(num amount) {
  final formatted = NumberFormat('#,##0.00', 'tr_TR').format(amount);
  return '$formatted ₺';
}

/// Formats a percentage with at most one decimal, dropping a trailing
/// ".0", Turkish-comma style: 8.0 -> "8%", 12.3 -> "12,3%".
String fmtPct(num value) {
  final rounded = (value * 10).round() / 10;
  final isWhole = rounded == rounded.roundToDouble();
  final text = isWhole ? rounded.toInt().toString() : rounded.toString();
  return '${text.replaceAll('.', ',')}%';
}

/// Formats a signed percentage change with 2 decimals, e.g. 0.42 -> "+0,42%".
String fmtChange(num value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2).replaceAll('.', ',')}%';
}

/// Short date label like "05 Eyl" for lists, or "05 Eyl 2026" when the
/// year isn't obviously the current one.
String fmtDateShort(DateTime date, {bool withYear = false}) {
  final day = date.day.toString().padLeft(2, '0');
  final month = kTurkishMonthsShort[date.month - 1];
  return withYear ? '$day $month ${date.year}' : '$day $month';
}

/// Full Turkish date label, e.g. "Bugün, 05 Eylül 2026" style callers build
/// themselves; this gives the "05 Eylül 2026" part.
const List<String> kTurkishMonthsFull = [
  'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
  'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
];

String fmtDateFull(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  return '$day ${kTurkishMonthsFull[date.month - 1]} ${date.year}';
}
