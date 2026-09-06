import 'package:shared_preferences/shared_preferences.dart';

/// [SharedPreferences.getInstance] with a short timeout.
///
/// On the real web target this resolves immediately (the web
/// implementation reads `window.localStorage` directly, no platform
/// channel involved). In some host environments — notably the plain VM
/// test runner without a mocked platform channel — the underlying call
/// never replies at all instead of rejecting, which would otherwise
/// hang every persistence read/write (theme, accounts, ledgers)
/// forever. The timeout turns that into an ordinary failure that the
/// caller's existing try/catch already falls back from.
Future<SharedPreferences> getPrefs() {
  return SharedPreferences.getInstance().timeout(const Duration(seconds: 2));
}
