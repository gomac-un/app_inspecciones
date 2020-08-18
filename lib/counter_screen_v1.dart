import 'package:flutter/material.dart';
import 'action_button.dart';
import 'blocs/counter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterScreenWithLocalState extends StatefulWidget {
  @override
  _CounterScreenWithLocalStateState createState() =>
      _CounterScreenWithLocalStateState();
}

class _CounterScreenWithLocalStateState
    extends State<CounterScreenWithLocalState> {
  CounterBloc _counterBloc;

  @override
  void initState() {
    super.initState();
    _counterBloc = CounterBloc();
  }

  @override
  void dispose() {
    _counterBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter - Local state'),
      ),
      body: Center(
        child: BlocBuilder(
          cubit: _counterBloc,
          builder: (context, state) {
            return Text(
              '$state',
              style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ActionButton(
              iconData: Icons.add,
              onPressed: () {
                _counterBloc.add(CounterEvent.increment);
              },
            ),
            ActionButton(
              iconData: Icons.remove,
              onPressed: () {
                _counterBloc.add(CounterEvent.decrement);
              },
            ),
            ActionButton(
              iconData: Icons.replay,
              onPressed: () {
                _counterBloc.add(CounterEvent.reset);
              },
            )
          ],
        ),
      ),
    );
  }
}
