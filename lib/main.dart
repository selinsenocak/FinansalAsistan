import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'theme/palette.dart';
import 'widgets/adaptive_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const FinansalAsistanApp(),
    ),
  );
}

class FinansalAsistanApp extends StatelessWidget {
  const FinansalAsistanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final palette = Palette.of(app.isDark ? Brightness.dark : Brightness.light);

    return MaterialApp(
      title: 'Finansal Asistan',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(palette),
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: app.authed ? const AdaptiveShell() : const AuthScreen(),
    );
  }
}
