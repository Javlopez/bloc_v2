import 'package:flutter/material.dart';
import 'counter_screen.dart';
import 'blocs/counter_bloc.dart';
import 'blocs/stopwatch/stopwatch_bloc.dart';
import 'stopwatch_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  void _pushContent(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    final stopwatchBloc = BlocProvider.of<StopwatchBloc>(context);

    void _pushScreen(BuildContext context, Widget screen) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => screen),
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<CounterBloc, int>(
          listener: (context, state) {
            if (state == 10) {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        content: Text('Count $state'),
                      ));
            }
          },
        ),
        BlocListener<StopwatchBloc, StopwatchState>(
          listener: (context, state) {
            if (state.time.inMilliseconds == 10000) {
              if (!Navigator.of(context).canPop()) {
                _pushScreen(context, StopwatchScreenWithGlobalState());
              }
            }
          },
        ),
      ],
      child: Scaffold(
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
              subtitle: BlocBuilder<CounterBloc, int>(
                builder: (context, state) {
                  return Text('$state');
                },
              ),
              trailing: Chip(
                label: Text('Global State'),
                backgroundColor: Colors.green[800],
              ),
              onTap: () =>
                  _pushContent(context, CounterScreenWithGlobalState()),
              onLongPress: () {
                counterBloc.add(CounterEvent.increment);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Stopwatch'),
              trailing: Chip(
                label: Text('Local State'),
                backgroundColor: Colors.blue[800],
              ),
              onTap: () =>
                  _pushContent(context, StopwatchScreenWithLocalState()),
            ),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Stopwatch'),
              subtitle: BlocBuilder<StopwatchBloc, StopwatchState>(
                builder: (context, state) {
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
                if (stopwatchBloc.state.isRunning) {
                  stopwatchBloc.add(StopStopwatch());
                } else {
                  stopwatchBloc.add(StartStopwatch());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
