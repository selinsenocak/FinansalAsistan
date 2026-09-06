/// A persisted account entry shown on the auth screen — either one of
/// the three built-in demo profiles or a real sign-up made in this
/// browser. Only the index (this record) and each account's ledger are
/// stored; there is no server, so "silme" (delete) here means "remove
/// from this browser's local storage."
class AccountRecord {
  final String id;
  final String name;
  final String role;
  final String? email;
  final String? password;
  final bool isDemo;
  final bool dismissed;

  const AccountRecord({
    required this.id,
    required this.name,
    required this.role,
    this.email,
    this.password,
    required this.isDemo,
    this.dismissed = false,
  });

  AccountRecord copyWith({bool? dismissed}) => AccountRecord(
        id: id,
        name: name,
        role: role,
        email: email,
        password: password,
        isDemo: isDemo,
        dismissed: dismissed ?? this.dismissed,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'email': email,
        'password': password,
        'isDemo': isDemo,
        'dismissed': dismissed,
      };

  factory AccountRecord.fromJson(Map<String, dynamic> j) => AccountRecord(
        id: j['id'] as String,
        name: j['name'] as String,
        role: j['role'] as String,
        email: j['email'] as String?,
        password: j['password'] as String?,
        isDemo: j['isDemo'] as bool? ?? false,
        dismissed: j['dismissed'] as bool? ?? false,
      );
}
