import 'package:flutter/material.dart';
import 'counter_screen.dart';
import 'blocs/counter_bloc.dart';
import 'flutter_bloc/bloc_provider.dart';
import 'flutter_bloc/bloc_builder.dart';
import 'blocs/stopwatch_bloc.dart';
import 'stopwatch_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  void _pushContent(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    final stopwatchBloc = BlocProvider.of<StopwatchBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text("BLoC Example")),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('Counter'),
            trailing: Chip(
              label: Text('Local State'),
              backgroundColor: Colors.blue[800],
            ),
            onTap: () => _pushContent(context, CounterScreenWithLocalState()),
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('Counter'),
            subtitle: BlocBuilder(
              bloc: counterBloc,
              builder: (BuildContext context, int state) {
                return Text('$state');
              },
            ),
            trailing: Chip(
              label: Text('Global State'),
              backgroundColor: Colors.green[800],
            ),
            onTap: () => _pushContent(context, CounterScreenWithGlobalState()),
            onLongPress: () {
              counterBloc.dispatch(CounterEvent.increment);
            },
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('Stopwatch'),
            trailing: Chip(
              label: Text('Local State'),
              backgroundColor: Colors.blue[800],
            ),
            onTap: () => _pushContent(context, StopwatchScreenWithLocalState()),
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('Stopwatch'),
            subtitle: BlocBuilder(
              bloc: stopwatchBloc,
              builder: (BuildContext context, StopwatchState state) {
                return Text('${state.timeFormated}');
              },
            ),
            trailing: Chip(
              label: Text('Global State'),
              backgroundColor: Colors.green[800],
            ),
            onTap: () =>
                _pushContent(context, StopwatchScreenWithGlobalState()),
            onLongPress: () {
              if (stopwatchBloc.currentState.isRunning) {
                stopwatchBloc.dispatch(StopStopwatch());
              } else {
                stopwatchBloc.dispatch(StartStopwatch());
              }
            },
          ),
        ],
      ),
    );
  }
}
