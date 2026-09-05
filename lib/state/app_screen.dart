enum AppScreen { home, income, expenses, budget, reports, charts, market, goals, settings }

extension AppScreenX on AppScreen {
  String get label => switch (this) {
        AppScreen.home => 'Ana Sayfa',
        AppScreen.income => 'Gelirler',
        AppScreen.expenses => 'Giderler',
        AppScreen.budget => 'Bütçe',
        AppScreen.reports => 'Raporlar',
        AppScreen.charts => 'Grafikler',
        AppScreen.market => 'Piyasa',
        AppScreen.goals => 'Hedefler',
        AppScreen.settings => 'Ayarlar',
      };
}

enum AuthMode { login, signup }

enum ChartView { trend, category }
