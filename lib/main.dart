import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'blocs/counter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'inspeccion_screen.dart';

void main() {
  runApp(
    BlocProvider<CounterBloc>(
      create: (context) {
        return CounterBloc();
      },
      child: MaterialApp(
        theme: ThemeData.light(),
        home: HomeScreen(), //InspeccionScreen(),
      ),
    ),
  );
}
