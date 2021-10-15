class TaggedUnionError extends Error {
  final Object? o;

  TaggedUnionError([this.o]);
  @override
  String toString() => "Tipo no tratado: ${o.runtimeType}";
}

class DatabaseInconsistencyError extends Error {
  final String message;

  DatabaseInconsistencyError([this.message = ""]);
  @override
  String toString() => message;
}

class AppInitializationError extends Error {
  final String message;

  AppInitializationError([this.message = ""]);
  @override
  String toString() => message;
}
