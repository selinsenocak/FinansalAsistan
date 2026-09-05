import 'package:flutter/material.dart';

import '../models/category.dart';
import '../state/app_screen.dart';

/// Central icon lookup so every screen draws the same glyph for the same
/// concept — mirrors the Lucide icon set the original design specifies.
IconData iconForScreen(AppScreen s) => switch (s) {
      AppScreen.home => Icons.home_outlined,
      AppScreen.income => Icons.arrow_circle_up_outlined,
      AppScreen.expenses => Icons.arrow_circle_down_outlined,
      AppScreen.budget => Icons.account_balance_wallet_outlined,
      AppScreen.reports => Icons.bar_chart_outlined,
      AppScreen.charts => Icons.show_chart,
      AppScreen.market => Icons.trending_up,
      AppScreen.goals => Icons.track_changes_outlined,
      AppScreen.settings => Icons.settings_outlined,
    };

IconData iconForCategory(CategoryKey c) => switch (c) {
      CategoryKey.kira => Icons.home_outlined,
      CategoryKey.yiyecek => Icons.restaurant_outlined,
      CategoryKey.ulasim => Icons.directions_bus_outlined,
      CategoryKey.faturalar => Icons.receipt_long_outlined,
      CategoryKey.eglence => Icons.local_movies_outlined,
      CategoryKey.diger => Icons.category_outlined,
    };

const IconData kIconIncome = Icons.arrow_circle_up_outlined;
const IconData kIconExpense = Icons.arrow_circle_down_outlined;
const IconData kIconUser = Icons.person_outline;
const IconData kIconLogout = Icons.logout;
const IconData kIconPlus = Icons.add;
const IconData kIconSun = Icons.wb_sunny_outlined;
const IconData kIconMoon = Icons.nightlight_round;
