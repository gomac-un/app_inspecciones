import 'package:dartz/dartz.dart';

extension IListX<A> on IList<A> {
  IList<A> remove(A value) => where((e) => e != value);
  IList<A> update(A value, A Function(A) update) =>
      map((e) => e == value ? update(e) : e);
}
