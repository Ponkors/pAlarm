import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '/models/alarm_hive.dart';

part 'time_event.dart';
part 'time_state.dart';

class TimeBloc extends Bloc<TimeEvent, TimeState> {
  final Box<Alarm> alarmBox;

  TimeBloc({required this.alarmBox}) : super(TimeInitial()) {

    on<SetAlarmTimeEvent>((event, emit) async {
      final newAlarm = Alarm(
        time: _getFormattedTime(event.hour, event.minute),
        isActive: event.isActive,
        repeatDays: event.repeatDays,
      );

      await alarmBox.add(newAlarm);
      add(LoadAlarmTimesEvent());
    });

    on<RemoveAlarmTimeEvent>((event, emit) async {
      await alarmBox.delete(event.alarmKey);
      add(LoadAlarmTimesEvent());
    });

    on<LoadAlarmTimesEvent>((event, emit) {
      print('Loading alarms from Hive...');
      final alarmTimes = alarmBox.values.toList();

      alarmTimes.sort((a, b) {
        final aTime = _parseTime(a.time);
        final bTime = _parseTime(b.time);
        return aTime.compareTo(bTime);
      });

      print('Loaded alarms: $alarmTimes');
      emit(AlarmTimesLoadedState(alarmTimes));
    });
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  static String _getFormattedTime([int? hour, int? minute]) {
    final now = DateTime.now();
    if (hour != null && minute != null) {
      return DateFormat('HH:mm').format(DateTime(now.year, now.month, now.day, hour, minute));
    }
    return DateFormat.Hm().format(now);
  }
}

