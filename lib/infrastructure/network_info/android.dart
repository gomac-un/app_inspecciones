import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/core/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final networkInfoProvider = Provider<NetworkInfo>(
    (ref) => NetworkInfoAndroidImpl(InternetConnectionChecker()));

// En Android toca usar [InternetConnectionChecker] porque
class NetworkInfoAndroidImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoAndroidImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
