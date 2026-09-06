class Goal {
  final String id;
  final String name;
  final double target;
  final double current;

  const Goal({
    required this.id,
    required this.name,
    required this.target,
    this.current = 0,
  });

  bool get isDone => current >= target;

  double get progress => target <= 0 ? 0 : (current / target).clamp(0, 1);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'target': target,
        'current': current,
      };

  factory Goal.fromJson(Map<String, dynamic> j) => Goal(
        id: j['id'] as String,
        name: j['name'] as String,
        target: (j['target'] as num).toDouble(),
        current: (j['current'] as num).toDouble(),
      );
}
