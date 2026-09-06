import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/account_record.dart';
import '../state/app_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../theme/palette.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/nav_icon.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _signupEmailCtrl = TextEditingController();
  final _signupPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _signupEmailCtrl.dispose();
    _signupPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final p = Palette.of(app.isDark ? Brightness.dark : Brightness.light);

    return Scaffold(
      backgroundColor: p.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840;
            return wide ? _buildWide(context, app, p) : _buildNarrow(context, app, p);
          },
        ),
      ),
    );
  }

  Widget _buildWide(BuildContext context, AppState app, Palette p) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: p.surfaceActive,
            padding: const EdgeInsets.all(60),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Finansal', style: headingStyle(p, size: 36, weight: FontWeight.w800)),
                Text('Asistan', style: headingStyle(p, size: 36, weight: FontWeight.w800)),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Text(
                    'Gelir ve giderlerinizi kategori bazlı takip edin, harcama dağılımınızı görün, güncel piyasa verilerini tek ekranda izleyin.',
                    style: bodyStyle(p, size: 15, color: p.textMuted),
                  ),
                ),
                const SizedBox(height: 28),
                Container(width: 64, height: 2, color: p.tone(SemanticToken.primary)),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 420,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(48),
            child: _AuthForm(
              app: app,
              p: p,
              emailCtrl: _emailCtrl,
              passwordCtrl: _passwordCtrl,
              nameCtrl: _nameCtrl,
              signupEmailCtrl: _signupEmailCtrl,
              signupPasswordCtrl: _signupPasswordCtrl,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrow(BuildContext context, AppState app, Palette p) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Finansal Asistan', style: headingStyle(p, size: 26)),
          const SizedBox(height: 4),
          Text('Gelir ve giderlerinizi tek yerden yönetin.', style: bodyStyle(p, size: 13, color: p.textMuted)),
          const SizedBox(height: 24),
          _AuthForm(
            app: app,
            p: p,
            emailCtrl: _emailCtrl,
            passwordCtrl: _passwordCtrl,
            nameCtrl: _nameCtrl,
            signupEmailCtrl: _signupEmailCtrl,
            signupPasswordCtrl: _signupPasswordCtrl,
          ),
        ],
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  final AppState app;
  final Palette p;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController signupEmailCtrl;
  final TextEditingController signupPasswordCtrl;

  const _AuthForm({
    required this.app,
    required this.p,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.nameCtrl,
    required this.signupEmailCtrl,
    required this.signupPasswordCtrl,
  });

  Future<void> _confirmDelete(BuildContext context, AccountRecord acc) async {
    if (acc.isDemo) {
      // Reversible (see "Gizlenen demo hesapları geri getir") — no need
      // to interrupt with a confirmation dialog.
      app.removeAccount(acc.id);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surface,
        title: Text('Hesabı sil', style: headingStyle(p, size: 16)),
        content: Text(
          '"${acc.name}" hesabını ve tüm gelir/gider/hedef verilerini kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
          style: bodyStyle(p, size: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Vazgeç')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sil')),
        ],
      ),
    );
    if (confirmed == true) app.removeAccount(acc.id);
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = app.authMode == AuthMode.login;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _ModeTab(
                label: 'Giriş Yap',
                active: isLogin,
                p: p,
                onTap: () => app.setAuthMode(AuthMode.login),
              ),
            ),
            Expanded(
              child: _ModeTab(
                label: 'Kayıt Ol',
                active: !isLogin,
                p: p,
                onTap: () => app.setAuthMode(AuthMode.signup),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isLogin) ...[
          AppTextField(palette: p, controller: emailCtrl, hint: 'E-posta'),
          const SizedBox(height: 10),
          AppTextField(palette: p, controller: passwordCtrl, hint: 'Şifre', obscure: true),
          if (app.loginError != null) ...[
            const SizedBox(height: 8),
            Text(app.loginError!, style: bodyStyle(p, size: 12, color: p.tone(SemanticToken.danger))),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Giriş Yap',
              palette: p,
              background: p.tone(SemanticToken.primary),
              foreground: Colors.white,
              onPressed: () => app.loginWithCredentials(emailCtrl.text, passwordCtrl.text),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
          ),
        ] else ...[
          AppTextField(palette: p, controller: nameCtrl, hint: 'Ad Soyad'),
          const SizedBox(height: 10),
          AppTextField(palette: p, controller: signupEmailCtrl, hint: 'E-posta'),
          const SizedBox(height: 10),
          AppTextField(palette: p, controller: signupPasswordCtrl, hint: 'Şifre', obscure: true),
          if (app.signupError != null) ...[
            const SizedBox(height: 8),
            Text(app.signupError!, style: bodyStyle(p, size: 12, color: p.tone(SemanticToken.danger))),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Kayıt Ol',
              palette: p,
              background: p.tone(SemanticToken.primary),
              foreground: Colors.white,
              onPressed: () => app.signup(
                name: nameCtrl.text,
                email: signupEmailCtrl.text,
                password: signupPasswordCtrl.text,
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
          ),
        ],
        if (app.visibleCustomAccounts.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(height: 2, color: p.divider),
          const SizedBox(height: 16),
          Text('KAYITLI HESAPLARIM', style: bodyStyle(p, size: 12, color: p.textMuted, weight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...app.visibleCustomAccounts.map((acc) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AccountTile(
                  account: acc,
                  p: p,
                  onTap: () => app.loginWithAccount(acc),
                  onDelete: () => _confirmDelete(context, acc),
                ),
              )),
        ],
        const SizedBox(height: 20),
        Container(height: 2, color: p.divider),
        const SizedBox(height: 16),
        Text(
          'DEMO HESAPLA GİRİŞ',
          style: bodyStyle(p, size: 12, color: p.textMuted, weight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        ...app.visibleDemoAccounts.map((acc) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AccountTile(
                account: acc,
                p: p,
                onTap: () => app.loginWithAccount(acc),
                onDelete: () => app.removeAccount(acc.id),
              ),
            )),
        if (app.hasHiddenDemoAccounts) ...[
          const SizedBox(height: 4),
          TextButton(
            onPressed: app.restoreDemoAccounts,
            child: Text(
              'Gizlenen demo hesapları geri getir',
              style: bodyStyle(p, size: 12, color: p.tone(SemanticToken.primary)),
            ),
          ),
        ],
      ],
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool active;
  final Palette p;
  final VoidCallback onTap;

  const _ModeTab({required this.label, required this.active, required this.p, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? p.tone(SemanticToken.primary) : p.surface,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: p.border)),
          child: Text(
            label,
            style: headingStyle(p, size: 13, color: active ? Colors.white : p.textMuted),
          ),
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final AccountRecord account;
  final Palette p;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AccountTile({required this.account, required this.p, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: p.border)),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: p.surface,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        color: p.softTone(SemanticToken.primary),
                        child: Icon(kIconUser, size: 16, color: p.onSoftTone(SemanticToken.primary)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(account.name, style: headingStyle(p, size: 13, weight: FontWeight.w700)),
                            Text(account.role, style: bodyStyle(p, size: 11, color: p.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: p.surface,
            child: InkWell(
              onTap: onDelete,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Icon(
                  account.isDemo ? Icons.visibility_off_outlined : Icons.delete_outline,
                  size: 18,
                  color: p.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
