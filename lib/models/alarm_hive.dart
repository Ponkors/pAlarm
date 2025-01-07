import 'package:hive/hive.dart';

part 'alarm_hive.g.dart';

@HiveType(typeId: 0)
class Alarm extends HiveObject {
  @HiveField(0)
  final String time;

  @HiveField(1)
  final bool isActive;

  @HiveField(2)
  final List<String> repeatDays;

  Alarm({
    required this.time,
    required this.isActive,
    required this.repeatDays,
  });
}
