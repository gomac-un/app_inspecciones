// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'mvvc/llenado_form_page.dart';

class Routes {
  static const String llenadoFormPage = '/';
  static const all = <String>{
    llenadoFormPage,
  };
}

class AutoRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.llenadoFormPage, page: LlenadoFormPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    LlenadoFormPage: (data) {
      final args = data.getArgs<LlenadoFormPageArguments>(
        orElse: () => LlenadoFormPageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => LlenadoFormPage(
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

/// LlenadoFormPage arguments holder class
class LlenadoFormPageArguments {
  final Key key;
  final String vehiculo;
  final int cuestionarioId;
  LlenadoFormPageArguments({this.key, this.vehiculo, this.cuestionarioId});
}
