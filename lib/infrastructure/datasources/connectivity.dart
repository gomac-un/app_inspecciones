import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final connectivityProvider = StreamProvider.autoDispose((ref) => Rx.concat([
      Stream.fromFuture(Connectivity()
          .checkConnectivity()
          .then((e) => e != ConnectivityResult.none)),
      Connectivity()
          .onConnectivityChanged
          .map((e) => e != ConnectivityResult.none)
    ]));