class TaggedUnionError extends Error {
  final Object? o;

  TaggedUnionError([this.o]);
  @override
  String toString() => "Tipo no tratado: ${o.runtimeType}";
}
