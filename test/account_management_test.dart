// Covers the account system added on top of the base app: unlimited
// sign-ups persisted to this browser, e-posta/şifre login against those
// accounts, and the ability to hide a demo profile or permanently
// delete a custom one from the auth screen.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<void> _fillAndTapSignup(
  WidgetTester tester, {
  required String name,
  required String email,
  required String password,
}) async {
  await tester.tap(find.text('Kayıt Ol').first);
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Ad Soyad'), name);
  await tester.enterText(find.widgetWithText(TextField, 'E-posta'), email);
  await tester.enterText(find.widgetWithText(TextField, 'Şifre'), password);
  await tester.tap(find.text('Kayıt Ol').last);
  await tester.pumpAndSettle();
}

Future<void> _logout(WidgetTester tester) async {
  final settings = find.text('Ayarlar').first;
  await tester.ensureVisible(settings);
  await tester.tap(settings, warnIfMissed: false);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Çıkış Yap').first);
  await tester.pumpAndSettle();
}

Future<void> _fillAndTapLogin(
  WidgetTester tester, {
  required String email,
  required String password,
}) async {
  await tester.enterText(find.widgetWithText(TextField, 'E-posta'), email);
  await tester.enterText(find.widgetWithText(TextField, 'Şifre'), password);
  await tester.tap(find.text('Giriş Yap').last);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Sign-up has no limit and immediately reaches the dashboard', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    await _fillAndTapSignup(tester, name: 'Test Kullanıcı', email: 'test@example.com', password: '123456');

    expect(find.textContaining('Merhaba, Test Kullanıcı'), findsOneWidget);
  });

  testWidgets('A signed-up account can log back in with the same credentials', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    await _fillAndTapSignup(tester, name: 'Deniz Yılmaz', email: 'deniz@example.com', password: 'gizli123');
    expect(find.textContaining('Merhaba, Deniz'), findsOneWidget);

    // Log out, back to the auth screen.
    await _logout(tester);

    await _fillAndTapLogin(tester, email: 'deniz@example.com', password: 'gizli123');

    expect(find.textContaining('Merhaba, Deniz'), findsOneWidget);
  });

  testWidgets('Wrong password shows an error and does not log in', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    await _fillAndTapSignup(tester, name: 'Deniz Yılmaz', email: 'deniz2@example.com', password: 'dogru123');
    await _logout(tester);

    await _fillAndTapLogin(tester, email: 'deniz2@example.com', password: 'yanlis');

    expect(find.text('Şifre hatalı.'), findsOneWidget);
    expect(find.textContaining('Merhaba,'), findsNothing);
  });

  testWidgets('Signing up twice with the same e-posta is rejected', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    await _fillAndTapSignup(tester, name: 'Birinci', email: 'ayni@example.com', password: '111111');
    await _logout(tester);

    await _fillAndTapSignup(tester, name: 'İkinci', email: 'ayni@example.com', password: '222222');

    expect(find.textContaining('zaten kayıtlı'), findsOneWidget);
    expect(find.textContaining('Merhaba,'), findsNothing);
  });

  testWidgets('Hiding a demo account removes it from the list, restore brings it back', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Ayşe Kaya'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('Ayşe Kaya'), findsNothing);
    expect(find.text('Gizlenen demo hesapları geri getir'), findsOneWidget);

    await tester.tap(find.text('Gizlenen demo hesapları geri getir'));
    await tester.pumpAndSettle();

    expect(find.text('Ayşe Kaya'), findsOneWidget);
  });

  testWidgets('Deleting a custom account removes it permanently and frees its e-posta', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    await _fillAndTapSignup(tester, name: 'Silinecek', email: 'silinecek@example.com', password: '123456');
    await _logout(tester);

    expect(find.text('Silinecek'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();
    // Confirmation dialog.
    await tester.tap(find.text('Sil'));
    await tester.pumpAndSettle();

    expect(find.text('Silinecek'), findsNothing);

    // The e-posta is free again for a brand new sign-up.
    await _fillAndTapSignup(tester, name: 'Yeniden', email: 'silinecek@example.com', password: 'baska123');
    expect(find.textContaining('Merhaba, Yeniden'), findsOneWidget);
  });
}
