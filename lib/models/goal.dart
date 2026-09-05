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
}
