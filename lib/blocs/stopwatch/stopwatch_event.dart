import 'package:equatable/equatable.dart';

abstract class StopwatchEvent extends Equatable {
  StopwatchEvent([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class StartStopwatch extends StopwatchEvent {}

class StopStopwatch extends StopwatchEvent {}

class ResetStopwatch extends StopwatchEvent {}

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
