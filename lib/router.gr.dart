// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'mvvc/form_llenado.dart';

class Routes {
  static const String formLlenado = '/';
  static const all = <String>{
    formLlenado,
  };
}

class AutoRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.formLlenado, page: FormLlenado),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    FormLlenado: (data) {
      final args = data.getArgs<FormLlenadoArguments>(
        orElse: () => FormLlenadoArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => FormLlenado(
          key: args.key,
          vehiculo: args.vehiculo,
          cuestionarioId: args.cuestionarioId,
        ).wrappedRoute(context),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// FormLlenado arguments holder class
class FormLlenadoArguments {
  final Key key;
  final String vehiculo;
  final int cuestionarioId;
  FormLlenadoArguments({this.key, this.vehiculo, this.cuestionarioId});
}
