extension AsyncMappings<E> on Iterable<E> {
  /// Extension que permite hace un map con una función asíncrona
  Future<Iterable<T>> asyncMap<T>(Future<T> Function(E e) toElement) =>
      Future.wait(map((e) => toElement(e)));
}

extension AllNullToEmpty<E> on Iterable<E?> {
  /// Convierte un iterable con elementos nullables a uno con elementos no nullables,
  /// Si el iterable tiene todos sus campos nulos, devuelve una lista vacía,
  /// si hay algun campo nulo y alguno no nulo lanza un error
  /// util cuando se usa un outerJoin
  Iterable<E> allNullToEmpty() =>
      every((e) => e == null) ? <E>[] : map((e) => e!);
}
