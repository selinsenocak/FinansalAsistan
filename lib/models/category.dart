import '../theme/palette.dart';

/// The six expense categories, in the fixed display order used across
/// every screen (dashboard donut, budget cards, category filters, …).
enum CategoryKey { kira, yiyecek, ulasim, faturalar, eglence, diger }

const List<CategoryKey> kCategoryOrder = [
  CategoryKey.kira,
  CategoryKey.yiyecek,
  CategoryKey.ulasim,
  CategoryKey.faturalar,
  CategoryKey.eglence,
  CategoryKey.diger,
];

extension CategoryKeyX on CategoryKey {
  String get label => switch (this) {
        CategoryKey.kira => 'Kira',
        CategoryKey.yiyecek => 'Yiyecek',
        CategoryKey.ulasim => 'Ulaşım',
        CategoryKey.faturalar => 'Faturalar',
        CategoryKey.eglence => 'Eğlence',
        CategoryKey.diger => 'Diğer',
      };

  /// The semantic color role this category is drawn with, everywhere.
  SemanticToken get token => switch (this) {
        CategoryKey.kira => SemanticToken.primary,
        CategoryKey.yiyecek => SemanticToken.success,
        CategoryKey.ulasim => SemanticToken.warning,
        CategoryKey.faturalar => SemanticToken.danger,
        CategoryKey.eglence => SemanticToken.accent,
        CategoryKey.diger => SemanticToken.info,
      };
}

/// Monthly budget targets per category (₺). Shared across demo users —
/// a real account would let the user set these under Bütçe.
const Map<CategoryKey, double> kMonthlyBudgets = {
  CategoryKey.kira: 12000,
  CategoryKey.yiyecek: 4500,
  CategoryKey.ulasim: 800,
  CategoryKey.faturalar: 1000,
  CategoryKey.eglence: 700,
  CategoryKey.diger: 500,
};
