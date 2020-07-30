import 'package:bloc_v2/blocs/my_bloc_delegate.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'bloc/bloc_supervisor.dart';
import 'bloc/bloc_delegate.dart';
import 'blocs/counter_bloc.dart';
import 'flutter_bloc/bloc_provider.dart';
import 'blocs/stopwatch_bloc.dart';

void main() {
  BlocSupervisor.delegate = MyBlocDelegate();

  final stopwatchBloc = StopwatchBloc();
  final counterBloc = CounterBloc();

  runApp(BlocProvider(
    bloc: stopwatchBloc,
    child: BlocProvider<CounterBloc>(
      bloc: counterBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: HomeScreen(),
      ),
    ),
  ));
}
