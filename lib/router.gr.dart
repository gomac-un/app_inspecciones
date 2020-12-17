// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'mvvc/creacion_form_page.dart';
import 'mvvc/llenado_form_page.dart';
import 'presentation/pages/borradores_screen.dart';
import 'presentation/pages/home_screen.dart';
import 'presentation/pages/login_screen.dart';
import 'presentation/pages/splash_screen.dart';

class Routes {
  static const String splashPage = '/';
  static const String loginScreen = '/login-screen';
  static const String homeScreen = '/home-screen';
  static const String creacionFormPage = '/creacion-form-page';
  static const String llenadoFormPage = '/llenado-form-page';
  static const String borradoresPage = '/borradores-page';
  static const all = <String>{
    splashPage,
    loginScreen,
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
    RouteDef(Routes.splashPage, page: SplashPage),
    RouteDef(Routes.loginScreen, page: LoginScreen),
    RouteDef(Routes.homeScreen, page: HomeScreen),
    RouteDef(Routes.creacionFormPage, page: CreacionFormPage),
    RouteDef(Routes.llenadoFormPage, page: LlenadoFormPage),
    RouteDef(Routes.borradoresPage, page: BorradoresPage),
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
      return MaterialPageRoute<dynamic>(
        builder: (context) => BorradoresPage(),
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

  Future<dynamic> pushHomeScreen() => push<dynamic>(Routes.homeScreen);

  Future<dynamic> pushCreacionFormPage() =>
      push<dynamic>(Routes.creacionFormPage);

  Future<dynamic> pushLlenadoFormPage({
    Key key,
    String vehiculo,
    int cuestionarioId,
  }) =>
      push<dynamic>(
        Routes.llenadoFormPage,
        arguments: LlenadoFormPageArguments(
            key: key, vehiculo: vehiculo, cuestionarioId: cuestionarioId),
      );

  Future<dynamic> pushBorradoresPage() => push<dynamic>(Routes.borradoresPage);
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
