abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<bool> get isDisconnected => isConnected.then((r) => !r);
}
