import 'dart:async';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
//import '../bloc/bloc.dart';
import 'package:bloc/bloc.dart';

abstract class StopwatchEvent extends Equatable {
  StopwatchEvent([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class StartStopwatch extends StopwatchEvent {
  @override
  String toString() {
    return 'StartStopwatch';
  }
}

class StopStopwatch extends StopwatchEvent {
  @override
  String toString() {
    return 'StopStopwatch';
  }
}

class ResetStopwatch extends StopwatchEvent {
  @override
  String toString() {
    return 'ResetStopwatch';
  }
}

class UpdateStopwatch extends StopwatchEvent {
  final Duration time;

  UpdateStopwatch(this.time);
  // : super([time]);

  @override
  List<Object> get props => [time];

  @override
  String toString() {
    return 'UpdateStopwatch {timeInMilliseconds: ${time.inMilliseconds}} ';
  }
}

class StopwatchState extends Equatable {
  final Duration time;
  final bool isInitial;
  final bool isRunning;
  final bool isSpecial;

  StopwatchState(
      {@required this.time,
      @required this.isInitial,
      @required this.isRunning,
      @required this.isSpecial});

  @override
  List<Object> get props =>
      [this.time, this.isInitial, this.isRunning, this.isSpecial];

  factory StopwatchState.initial() {
    return StopwatchState(
        time: Duration(milliseconds: 0),
        isInitial: true,
        isRunning: false,
        isSpecial: false);
  }

  int get minutes => time.inMinutes.remainder(60);
  int get seconds => time.inSeconds.remainder(60);
  int get hundreds => (time.inMilliseconds / 10).floor().remainder(100);

  String get timeFormated {
    String toTwoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    return "${toTwoDigits(minutes)}:${toTwoDigits(seconds)}:${toTwoDigits(hundreds)}";
  }

  StopwatchState copyWith(
      {Duration time, bool isInitial, bool isRunning, bool isSpecial}) {
    return StopwatchState(
        time: time ?? this.time,
        isInitial: isInitial ?? this.isInitial,
        isRunning: isRunning ?? this.isRunning,
        isSpecial: isSpecial ?? this.isSpecial);
  }

  @override
  String toString() =>
      "StopwatchState { timeFormated: $timeFormated, isInitial: $isInitial,  isRunning: $isRunning, isSpecial: $isSpecial}";
}

class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  int _elapsedTimeInmilliseconds = 0;
  StreamSubscription _streamPeriodicSubscription;

  @override
  void dispose() {
    _streamPeriodicSubscription?.cancel();
    _streamPeriodicSubscription = null;
    super.dispose();
  }

  @override
  StopwatchState get initialState => StopwatchState.initial();

  @override
  Stream<StopwatchState> mapEventToState(StopwatchEvent event) async* {
    if (event is StartStopwatch) {
      if (_streamPeriodicSubscription == null) {
        _streamPeriodicSubscription =
            Stream.periodic(Duration(milliseconds: 10)).listen((_) {
          _elapsedTimeInmilliseconds += 10;
          dispatch(UpdateStopwatch(
              Duration(milliseconds: _elapsedTimeInmilliseconds)));
        });
      }
    } else if (event is UpdateStopwatch) {
      final bool isSpecial = event.time.inMilliseconds % 3000 == 0;

      yield StopwatchState(
        time: event.time,
        isInitial: false,
        isRunning: true,
        isSpecial: isSpecial,
      );
    } else if (event is StopStopwatch) {
      _streamPeriodicSubscription?.cancel();
      _streamPeriodicSubscription = null;

      yield currentState.copyWith(isRunning: false);
    } else if (event is ResetStopwatch) {
      _elapsedTimeInmilliseconds = 0;
      if (!currentState.isRunning) {
        yield StopwatchState.initial();
      }
    }
  }
}
