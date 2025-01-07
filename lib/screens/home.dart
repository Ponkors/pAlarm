import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digital_alarm_clock_design/blocs/time/time_bloc.dart';
import 'package:digital_alarm_clock_design/screens/custom_time_picker.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  late String _currentTime = _getCurrentFormattedTime();
  late int _currentHour;
  late int _currentMinute;
  late int _currentSecond;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _currentHour = now.hour;
    _currentMinute = now.minute;
    _currentSecond = now.second;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = _getCurrentFormattedTime();
        _currentHour = DateTime.now().hour;
        _currentSecond = DateTime.now().second;
      });
    });

    context.read<TimeBloc>().add(LoadAlarmTimesEvent());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getCurrentFormattedTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffa8c889),
      body: Column(
        children: [
          _buildClockSection(),
          _buildProgressIndicator(),
          const SizedBox(height: 16),
          _buildDayRow(),
          const SizedBox(height: 18),
          _buildHorizontalList(),
          // _buildAlarmsList(),
        ],
      ),
      persistentFooterButtons: [_buildFooter()],
    );
  }

  Widget _buildClockSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentTime,
              style: const TextStyle(
                fontSize: 120,
                color: Color(0xffa8c889),
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Current Time",
              style: TextStyle(fontSize: 18, color: Color(0xff69745F)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomPaint(
        painter: ProgressPainter(_currentHour, _currentMinute, _currentSecond),
        size: const Size(double.infinity, 150),
      ),
    );
  }

  Widget _buildDayRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
          .map((day) => Text(
        day,
        style: TextStyle(
            fontSize: 22,
            color: DateTime.now().weekday ==
                ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'].indexOf(day) + 1
                ? Colors.black
                : const Color(0xff59644c)),
      ))
          .toList(),
    );
  }

  Widget _buildHorizontalList() {
    return BlocBuilder<TimeBloc, TimeState>(
      builder: (context, state) {
        if (state is AlarmTimesLoadedState) {
          if (state.alarmTimes.isEmpty) {
            return const Center(
              child: Text(
                "No alarms set.",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  state.alarmTimes.length,
                      (index) {
                    final alarm = state.alarmTimes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 2,
                        dashPattern: const [5, 5],
                        borderType: BorderType.RRect,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: 350,
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    alarm.time,
                                    style: const TextStyle(fontSize: 60),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<TimeBloc>().add(RemoveAlarmTimeEvent(alarm.key));
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                alarm.repeatDays.join(", "),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff69745f),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }


  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            // Navigate to calendar screen
          },
          icon: const Icon(
            Icons.calendar_month,
            color: Color(0xffa8c889),
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: const Size(60, 60),
          ),
        ),
        SizedBox(
          width: 250,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomTimePicker()),
              );
            },
            label: const Text(
              'Add Alarm',
              style: TextStyle(fontSize: 24),
            ),
            shape: const StadiumBorder(),
            backgroundColor: Colors.black,
            foregroundColor: const Color(0xffa8c889),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CustomTimePicker()),
            );
          },
          icon: const Icon(
            Icons.add,
            color: Color(0xffa8c889),
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: const Size(60, 60),
          ),
        ),
      ],
    );
  }
}

class ProgressPainter extends CustomPainter {
  final int totalBars = 24;
  final int currentHour;
  final int currentMinute;
  final int currentSecond;

  ProgressPainter(this.currentHour, this.currentMinute, this.currentSecond);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double barSpacing = size.width / (totalBars - 1);

    final double hourOffset = currentHour * barSpacing +
        (currentMinute / 60 + currentSecond / 3600) * barSpacing;

    for (int i = 0; i < totalBars; i++) {
      paint.color = Colors.grey;
      canvas.drawLine(
        Offset(i * barSpacing, size.height),
        Offset(i * barSpacing, 0),
        paint,
      );

      if (i < totalBars - 1) {
        final double halfHourX = i * barSpacing + barSpacing / 2;
        paint.color = Colors.grey;

        final double centerY = size.height / 2;
        final double shortBarHeight = size.height * 0.5;
        canvas.drawLine(
          Offset(halfHourX, centerY + shortBarHeight / 2),
          Offset(halfHourX, centerY - shortBarHeight / 2),
          paint,
        );
      }
    }

    paint
      ..color = Colors.red
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(hourOffset, size.height),
      Offset(hourOffset, 0),
      paint,
    );

    paint
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    final double secondX = (currentSecond / 60) * size.width;
    canvas.drawCircle(Offset(secondX, -30), 6, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

