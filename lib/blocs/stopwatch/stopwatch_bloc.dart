import 'dart:async';
import 'stopwatch_event.dart';
import 'stopwatch_state.dart';
import 'package:bloc/bloc.dart';

export 'stopwatch_event.dart';
export 'stopwatch_state.dart';

class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  int _elapsedTimeInmilliseconds = 0;
  StreamSubscription _streamPeriodicSubscription;

  @override
  void close() {
    _streamPeriodicSubscription?.cancel();
    _streamPeriodicSubscription = null;
    super.close();
  }

  @override
  StopwatchState get initialState => StopwatchState.initial();

  @override
  Stream<StopwatchState> mapEventToState(StopwatchEvent event) async* {
    if (event is StartStopwatch) {
      yield* _mapStartStopwatchToState();
    } else if (event is UpdateStopwatch) {
      yield* _mapUpdateStopwatchToState(event);
    } else if (event is StopStopwatch) {
      yield* _mapStopStopwatchToState();
    } else if (event is ResetStopwatch) {
      yield* _mapResetStopwatchToState();
    }
  }

  Stream<StopwatchState> _mapStartStopwatchToState() async* {
    if (_streamPeriodicSubscription == null) {
      _streamPeriodicSubscription =
          Stream.periodic(Duration(milliseconds: 10)).listen((_) {
        _elapsedTimeInmilliseconds += 10;
        add(UpdateStopwatch(
            Duration(milliseconds: _elapsedTimeInmilliseconds)));
      });
    }
  }

  Stream<StopwatchState> _mapUpdateStopwatchToState(
      UpdateStopwatch event) async* {
    final bool isSpecial = event.time.inMilliseconds % 3000 == 0;

    yield StopwatchState(
      time: event.time,
      isInitial: false,
      isRunning: true,
      isSpecial: isSpecial,
    );
  }

  Stream<StopwatchState> _mapStopStopwatchToState() async* {
    _streamPeriodicSubscription?.cancel();
    _streamPeriodicSubscription = null;

    yield state.copyWith(isRunning: false);
  }

  Stream<StopwatchState> _mapResetStopwatchToState() async* {
    _elapsedTimeInmilliseconds = 0;
    if (!state.isRunning) {
      yield StopwatchState.initial();
    }
  }
}
