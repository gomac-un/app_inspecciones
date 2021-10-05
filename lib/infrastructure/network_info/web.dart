import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/core/network_info.dart';

final networkInfoProvider =
    Provider<NetworkInfo>((ref) => NetworkInfoWebImpl(Connectivity()));

class NetworkInfoWebImpl extends NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoWebImpl(this.connectivity);

  @override
  Future<bool> get isConnected => connectivity
      .checkConnectivity()
      .then((cr) => cr != ConnectivityResult.none);
}
