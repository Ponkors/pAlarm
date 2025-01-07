part of 'time_bloc.dart';

abstract class TimeState extends Equatable {
  const TimeState();

  @override
  List<Object?> get props => [];
}

class TimeInitial extends TimeState {}

class TimeUpdated extends TimeState {
  final String time;
  const TimeUpdated(this.time);

  @override
  List<Object?> get props => [time];
}

class AlarmTimesLoadedState extends TimeState {
  final List<Alarm> alarmTimes;

  const AlarmTimesLoadedState(this.alarmTimes);

  @override
  List<Object?> get props => [alarmTimes];
}