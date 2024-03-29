import 'package:dartz/dartz.dart';

extension FutureEither<L, R> on Future<Either<L, R>> {
  Future<Either<L, R2>> flatMap<R2>(Function1<R, Future<Either<L, R2>>> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        f,
      ),
    );
  }

  Future<Either<L, R2>> map<R2>(Function1<R, Either<L, R2>> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        (r) => Future.value(f(r)),
      ),
    );
  }

  // TODO: Find an official FP name for mapping multiple layers deep into a nested composition
  Future<Either<L, R2>> nestedMap<R2>(Function1<R, R2> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        (r) => Future.value(right<L, R2>(f(r))),
      ),
    );
  }

  Future<Either<L2, R>> leftMap<L2>(Function1<L, L2> f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left(f(l))),
        (r) => Future.value(right<L2, R>(r)),
      ),
    );
  }

  Future<Either<L, R2>> nestedEvaluatedMap<R2>(Future<R2> Function(R) f) {
    return then(
      (either1) => either1.fold(
        (l) => Future.value(left<L, R2>(l)),
        (r) async => right<L, R2>(await f(r)),
      ),
    );
  }
}
