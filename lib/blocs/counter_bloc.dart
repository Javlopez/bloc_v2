import 'package:bloc/bloc.dart';

enum CounterEvent { increment, decrement, reset }

class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 0;

  @override
  void onEvent(CounterEvent event) {
    print('bloc: ${this.runtimeType}, event: $event');
  }

  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    print('bloc: ${this.runtimeType}, event: $transition');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('bloc: ${this.runtimeType}, error: $error, stackTrace: $stackTrace');
  }

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    if (event == CounterEvent.increment) {
      yield state + 1;
    } else if (event == CounterEvent.decrement) {
      yield state - 1;
    } else if (event == CounterEvent.reset) {
      yield 0;
    }
  }
}
