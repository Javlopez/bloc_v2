import 'package:flutter/material.dart';
import 'action_button.dart';
import 'blocs/stopwatch_bloc.dart';
import 'flutter_bloc/bloc_provider.dart';
import 'flutter_bloc/bloc_builder.dart';

class StopwatchScreenWithLocalState extends StatefulWidget {
  StopwatchScreenWithLocalState({Key key}) : super(key: key);

  @override
  _StopwatchScreenWithLocalStateState createState() =>
      _StopwatchScreenWithLocalStateState();
}

class _StopwatchScreenWithLocalStateState
    extends State<StopwatchScreenWithLocalState> {
  StopwatchBloc _stopwatchBloc;

  @override
  void initState() {
    super.initState();
    _stopwatchBloc = StopwatchBloc();
  }

  @override
  void dispose() {
    _stopwatchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _stopwatchBloc,
      child: StopwatchScaffold(title: 'Stopwatch - Local state'),
    );
  }
}

class StopwatchScreenWithGlobalState extends StatelessWidget {
  const StopwatchScreenWithGlobalState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StopwatchScaffold(
      title: 'Stopwatch-  global state',
    );
  }
}

class StopwatchScaffold extends StatelessWidget {
  final String title;

  const StopwatchScaffold({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stopwatchBloc = BlocProvider.of<StopwatchBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: BlocBuilder(
            bloc: stopwatchBloc,
            builder: (BuildContext context, StopwatchState state) {
              return Text(
                state.timeFormated,
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16),
        child: BlocBuilder(
          bloc: stopwatchBloc,
          condition: (StopwatchState previous, StopwatchState current) {
            return previous.isInitial != current.isInitial ||
                previous.isRunning != current.isRunning;
          },
          builder: (BuildContext context, StopwatchState state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (state.isRunning)
                  ActionButton(
                    iconData: Icons.stop,
                    onPressed: () {
                      stopwatchBloc.dispatch(StopStopwatch());
                    },
                  )
                else
                  ActionButton(
                    iconData: Icons.play_arrow,
                    onPressed: () {
                      stopwatchBloc.dispatch(StartStopwatch());
                    },
                  ),
                if (!state.isInitial)
                  ActionButton(
                    iconData: Icons.replay,
                    onPressed: () {
                      stopwatchBloc.dispatch(ResetStopwatch());
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
