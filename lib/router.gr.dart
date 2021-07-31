// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'infrastructure/moor_database.dart';
import 'mvvc/creacion_form_page.dart';
import 'mvvc/llenado_form_page.dart';
import 'presentation/pages/borradores_screen.dart';
import 'presentation/pages/cuestionarios_screen.dart';
import 'presentation/pages/grupos_screen.dart';
import 'presentation/pages/history_screen.dart';
import 'presentation/pages/login_screen.dart';
import 'presentation/pages/sincronizacion_screen.dart';
import 'presentation/pages/splash_screen.dart';

class Routes {
  static const String splashPage = '/';
  static const String loginScreen = '/login-screen';
  static const String creacionFormPage = '/creacion-form-page';
  static const String borradoresPage = '/borradores-page';
  static const String llenadoFormPage = '/llenado-form-page';
  static const String sincronizacionPage = '/sincronizacion-page';
  static const String cuestionariosPage = '/cuestionarios-page';
  static const String gruposScreen = '/grupos-screen';
  static const String historyInspeccionesPage = '/history-inspecciones-page';
  static const all = <String>{
    splashPage,
    loginScreen,
    creacionFormPage,
    borradoresPage,
    llenadoFormPage,
    sincronizacionPage,
    cuestionariosPage,
    gruposScreen,
    historyInspeccionesPage,
  };
}

class AutoRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashPage, page: SplashPage),
    RouteDef(Routes.loginScreen, page: LoginScreen),
    RouteDef(Routes.creacionFormPage, page: CreacionFormPage),
    RouteDef(Routes.borradoresPage, page: BorradoresPage),
    RouteDef(Routes.llenadoFormPage, page: LlenadoFormPage),
    RouteDef(Routes.sincronizacionPage, page: SincronizacionPage),
    RouteDef(Routes.cuestionariosPage, page: CuestionariosPage),
    RouteDef(Routes.gruposScreen, page: GruposScreen),
    RouteDef(Routes.historyInspeccionesPage, page: HistoryInspeccionesPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashPage(),
        settings: data,
      );
    },
    LoginScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginScreen().wrappedRoute(context),
        settings: data,
      );
    },
    CreacionFormPage: (data) {
      final args = data.getArgs<CreacionFormPageArguments>(
        orElse: () => CreacionFormPageArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreacionFormPage(
          key: args.key,
          cuestionario: args.cuestionario,
          cuestionarioDeModelo: args.cuestionarioDeModelo,
          bloques: args.bloques,
        ).wrappedRoute(context),
        settings: data,
      );
    },
    BorradoresPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => BorradoresPage().wrappedRoute(context),
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
          activo: args.activo,
          cuestionarioId: args.cuestionarioId,
        ).wrappedRoute(context),
        settings: data,
      );
    },
    SincronizacionPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SincronizacionPage().wrappedRoute(context),
        settings: data,
      );
    },
    CuestionariosPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CuestionariosPage().wrappedRoute(context),
        settings: data,
      );
    },
    GruposScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => GruposScreen().wrappedRoute(context),
        settings: data,
      );
    },
    HistoryInspeccionesPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HistoryInspeccionesPage().wrappedRoute(context),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Navigation helper methods extension
/// *************************************************************************

extension AutoRouterExtendedNavigatorStateX on ExtendedNavigatorState {
  Future<dynamic> pushSplashPage() => push<dynamic>(Routes.splashPage);

  Future<dynamic> pushLoginScreen() => push<dynamic>(Routes.loginScreen);

  Future<dynamic> pushCreacionFormPage({
    Key key,
    dynamic cuestionario,
    CuestionarioConContratista cuestionarioDeModelo,
    List<IBloqueOrdenable> bloques,
  }) =>
      push<dynamic>(
        Routes.creacionFormPage,
        arguments: CreacionFormPageArguments(
            key: key,
            cuestionario: cuestionario,
            cuestionarioDeModelo: cuestionarioDeModelo,
            bloques: bloques),
      );

  Future<dynamic> pushBorradoresPage() => push<dynamic>(Routes.borradoresPage);

  Future<dynamic> pushLlenadoFormPage({
    Key key,
    int activo,
    int cuestionarioId,
  }) =>
      push<dynamic>(
        Routes.llenadoFormPage,
        arguments: LlenadoFormPageArguments(
            key: key, activo: activo, cuestionarioId: cuestionarioId),
      );

  Future<dynamic> pushSincronizacionPage() =>
      push<dynamic>(Routes.sincronizacionPage);

  Future<dynamic> pushCuestionariosPage() =>
      push<dynamic>(Routes.cuestionariosPage);

  Future<dynamic> pushGruposScreen() => push<dynamic>(Routes.gruposScreen);

  Future<dynamic> pushHistoryInspeccionesPage() =>
      push<dynamic>(Routes.historyInspeccionesPage);
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// CreacionFormPage arguments holder class
class CreacionFormPageArguments {
  final Key key;
  final dynamic cuestionario;
  final CuestionarioConContratista cuestionarioDeModelo;
  final List<IBloqueOrdenable> bloques;
  CreacionFormPageArguments(
      {this.key, this.cuestionario, this.cuestionarioDeModelo, this.bloques});
}

/// LlenadoFormPage arguments holder class
class LlenadoFormPageArguments {
  final Key key;
  final int activo;
  final int cuestionarioId;
  LlenadoFormPageArguments({this.key, this.activo, this.cuestionarioId});
}
