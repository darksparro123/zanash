class StepsModel {
  final int week;
  final int totalSteps;

  StepsModel(
    this.week,
    this.totalSteps,
  );

  StepsModel.fromMap(Map<String, dynamic> map)
      : assert(map['day'] != null),
        assert(map['steps'] != null),
        // assert(map['colorVal'] != null),
        week = map['day'],
        totalSteps = map['steps'];

  @override
  String toString() => "Record<$week:$totalSteps:>";
}
