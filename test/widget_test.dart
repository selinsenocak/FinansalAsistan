// Basic smoke tests: the app boots to the auth screen, signing in with a
// demo account reaches the dashboard, and every screen in the bottom
// navigation renders without a layout exception for each demo profile
// (this is how two real overflow bugs — the Grafikler tab row and the
// Ayarlar profile row — were actually caught during development; keep
// this test whenever new screens are added).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:finansal_asistan/screens/auth_screen.dart';
import 'package:finansal_asistan/state/app_state.dart';
import 'package:finansal_asistan/theme/app_theme.dart';
import 'package:finansal_asistan/theme/palette.dart';
import 'package:finansal_asistan/widgets/adaptive_shell.dart';

Widget _wrap() {
  return ChangeNotifierProvider(
    create: (_) => AppState(),
    child: Builder(
      builder: (context) {
        final app = context.watch<AppState>();
        return MaterialApp(
          theme: buildAppTheme(Palette.of(app.isDark ? Brightness.dark : Brightness.light)),
          home: app.authed ? const AdaptiveShell() : const AuthScreen(),
        );
      },
    ),
  );
}

const _navLabels = [
  'Ana Sayfa',
  'Gelirler',
  'Giderler',
  'Bütçe',
  'Raporlar',
  'Grafikler',
  'Piyasa',
  'Hedefler',
  'Ayarlar', // visited last, so its logout button is on screen right after
];

void main() {
  testWidgets('Auth screen shows the three demo accounts', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Ayşe Kaya'), findsOneWidget);
    expect(find.text('Mert Demir'), findsOneWidget);
    expect(find.text('Elif Şahin'), findsOneWidget);
  });

  testWidgets('Selecting a demo account reaches the dashboard', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ayşe Kaya'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Merhaba,'), findsOneWidget);
  });

  for (final size in [const Size(390, 844), const Size(1280, 832)]) {
    testWidgets('Every nav screen renders at ${size.width.toInt()}x${size.height.toInt()} for each demo user',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      for (final user in ['Ayşe Kaya', 'Mert Demir', 'Elif Şahin']) {
        await tester.tap(find.text(user));
        await tester.pumpAndSettle();

        for (final label in _navLabels) {
          final finder = find.text(label).first;
          await tester.ensureVisible(finder);
          await tester.tap(finder, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Ayarlar (just visited) has the logout button — use it to get
        // back to a clean auth screen for the next demo user.
        await tester.tap(find.text('Çıkış Yap').first);
        await tester.pumpAndSettle();
      }
    });
  }
}
