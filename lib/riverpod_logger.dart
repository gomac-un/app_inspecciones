import 'package:hooks_riverpod/hooks_riverpod.dart';

class RiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (previousValue is StateController<bool>) {
      previousValue = previousValue.state;
    }
    if (newValue is StateController<bool>) {
      newValue = newValue.state;
    }
    print({
      "action": "didUpdateProvider",
      "provider": "${provider.name ?? provider.runtimeType}",
      "previousValue": "$previousValue",
      "newValue": "$newValue"
    });
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    print({
      "action": "didAddProvider",
      "provider": "${provider.name ?? provider.runtimeType}",
      "value": "$value"
    });
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer containers,
  ) {
    print({
      "action": "didUpdateProvider",
      "provider": "${provider.name ?? provider.runtimeType}",
    });
  }
}
