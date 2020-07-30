import 'dart:js';

import 'package:bloc_v2/blocs/my_bloc_delegate.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'bloc/bloc_supervisor.dart';
import 'bloc/bloc_delegate.dart';
import 'blocs/counter_bloc.dart';
import 'flutter_bloc/bloc_provider.dart';
import 'blocs/stopwatch_bloc.dart';
import 'flutter_bloc/bloc_provider_tree.dart';

void main() {
  BlocSupervisor.delegate = MyBlocDelegate();

  runApp(BlocProviderTree(
    blocProviders: <BlocProvider>[
      BlocProvider<CounterBloc>(builder: (context) => CounterBloc()),
      BlocProvider<StopwatchBloc>(builder: (context) => StopwatchBloc())
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomeScreen(),
    ),
  ));
}
