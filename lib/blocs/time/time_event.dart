part of 'time_bloc.dart';

abstract class TimeEvent extends Equatable {
  const TimeEvent();

  @override
  List<Object?> get props => [];
}

class UpdateTimeEvent extends TimeEvent {}

class SetAlarmTimeEvent extends TimeEvent {
  final int hour;
  final int minute;
  final bool isActive;
  final List<String> repeatDays;

  const SetAlarmTimeEvent({
    required this.hour,
    required this.minute,
    this.isActive = true,
    this.repeatDays = const [],
  });

  @override
  List<Object?> get props => [hour, minute, isActive, repeatDays];
}

class RemoveAlarmTimeEvent extends TimeEvent {
  final int alarmKey;

  const RemoveAlarmTimeEvent(this.alarmKey);

  @override
  List<Object?> get props => [alarmKey];
}

class LoadAlarmTimesEvent extends TimeEvent {}
