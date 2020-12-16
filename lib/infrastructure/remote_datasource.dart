import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import 'package:inspecciones/core/error/exceptions.dart';

abstract class InspeccionesRemoteDataSource {}

@LazySingleton(as: InspeccionesRemoteDataSource)
class InspeccionesRemoteDataSourceImpl implements InspeccionesRemoteDataSource {
  final http.Client client;

  InspeccionesRemoteDataSourceImpl({@required this.client});
/*
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }*/
}
