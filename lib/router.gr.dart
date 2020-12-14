// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'infrastructure/moor_database.dart';
import 'mvvc/creacion_form_page.dart';
import 'mvvc/llenado_form_page.dart';
import 'presentation/pages/borradores_screen.dart';
import 'presentation/pages/home_screen.dart';

class Routes {
  static const String homeScreen = '/';
  static const String creacionFormPage = '/creacion-form-page';
  static const String llenadoFormPage = '/llenado-form-page';
  static const String borradoresPage = '/borradores-page';
  static const all = <String>{
    homeScreen,
    creacionFormPage,
    llenadoFormPage,
    borradoresPage,
  };
}

class AutoRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeScreen, page: HomeScreen),
    RouteDef(Routes.creacionFormPage, page: CreacionFormPage),
    RouteDef(Routes.llenadoFormPage, page: LlenadoFormPage),
    RouteDef(Routes.borradoresPage, page: BorradoresPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomeScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeScreen(),
        settings: data,
      );
    },
    CreacionFormPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const CreacionFormPage().wrappedRoute(context),
        settings: data,
      );
    },
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
    BorradoresPage: (data) {
      final args = data.getArgs<BorradoresPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BorradoresPage(args.db),
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

/// BorradoresPage arguments holder class
class BorradoresPageArguments {
  final Database db;
  BorradoresPageArguments({@required this.db});
}
