import '../utils/formatters.dart';

/// How a quote's value is displayed: `decimal2` for FX pairs (34,82 ₺),
/// `tryRounded` for whole-lira quantities (gram gold, an index level).
enum MarketFormat { decimal2, tryRounded }

class MarketQuote {
  final String symbol;
  final double value;
  final double changePct;
  final MarketFormat format;

  /// True when this quote came back from a live fetch this session;
  /// false while showing the bundled fallback numbers.
  final bool isLive;

  const MarketQuote({
    required this.symbol,
    required this.value,
    required this.changePct,
    required this.format,
    this.isLive = false,
  });

  String get valueLabel =>
      format == MarketFormat.decimal2 ? fmtTRY2(value) : fmtTRY(value);

  String get changeLabel => fmtChange(changePct);

  MarketQuote copyWith({double? value, double? changePct, bool? isLive}) =>
      MarketQuote(
        symbol: symbol,
        value: value ?? this.value,
        changePct: changePct ?? this.changePct,
        format: format,
        isLive: isLive ?? this.isLive,
      );

  /// Bundled fallback quotes, shown immediately and kept on screen if the
  /// live fetch fails — the market screen never renders empty.
  static List<MarketQuote> demoFallback() => const [
        MarketQuote(
          symbol: 'USD/TRY',
          value: 34.82,
          changePct: 0.42,
          format: MarketFormat.decimal2,
        ),
        MarketQuote(
          symbol: 'EUR/TRY',
          value: 37.95,
          changePct: -0.18,
          format: MarketFormat.decimal2,
        ),
        MarketQuote(
          symbol: 'Altın (gram)',
          value: 3120,
          changePct: 1.05,
          format: MarketFormat.tryRounded,
        ),
        MarketQuote(
          symbol: 'BIST 100',
          value: 9842,
          changePct: 0.63,
          format: MarketFormat.tryRounded,
        ),
      ];
}
