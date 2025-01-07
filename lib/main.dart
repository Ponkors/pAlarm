import 'package:digital_alarm_clock_design/models/alarm_hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:digital_alarm_clock_design/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'blocs/time/time_bloc.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(AlarmAdapter());

  final alarmBox = await Hive.openBox<Alarm>('alarms');

  runApp(MyApp(alarmBox: alarmBox));
}

class MyApp extends StatelessWidget {
  final Box<Alarm> alarmBox;

  const MyApp({super.key, required this.alarmBox});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeBloc(alarmBox: alarmBox),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Digital',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
