/// The currently signed-in user (a fresh sign-up or one of the demo
/// accounts). Kept separate from [DemoUser] because a real sign-up has
/// no seeded history — only a name and an empty ledger.
class AppUser {
  final String id;
  final String name;
  final String role;
  final bool isDemo;

  const AppUser({
    required this.id,
    required this.name,
    required this.role,
    this.isDemo = false,
  });
}
