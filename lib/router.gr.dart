// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'application/crear_cuestionario_form/llenar_cuestionario_form_bloc.dart';
import 'infrastructure/moor_database_llenado.dart';
import 'presentation/pages/borradores_screen.dart';
import 'presentation/pages/home_screen.dart';
import 'presentation/pages/llenar_cuestionario_form_page.dart';

class Routes {
  static const String homeScreen = '/';
  static const String borradoresPage = '/borradores-page';
  static const String llenarCuestionarioFormPage =
      '/llenar-cuestionario-form-page';
  static const all = <String>{
    homeScreen,
    borradoresPage,
    llenarCuestionarioFormPage,
  };
}

class AutoRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeScreen, page: HomeScreen),
    RouteDef(Routes.borradoresPage, page: BorradoresPage),
    RouteDef(Routes.llenarCuestionarioFormPage,
        page: LlenarCuestionarioFormPage),
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
    BorradoresPage: (data) {
      final args = data.getArgs<BorradoresPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BorradoresPage(args.db),
        settings: data,
      );
    },
    LlenarCuestionarioFormPage: (data) {
      final args =
          data.getArgs<LlenarCuestionarioFormPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => LlenarCuestionarioFormPage(
          args.formBloc,
          key: args.key,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// BorradoresPage arguments holder class
class BorradoresPageArguments {
  final Database db;
  BorradoresPageArguments({@required this.db});
}

/// LlenarCuestionarioFormPage arguments holder class
class LlenarCuestionarioFormPageArguments {
  final LlenarCuestionarioFormBloc formBloc;
  final Key key;
  LlenarCuestionarioFormPageArguments({@required this.formBloc, this.key});
}
