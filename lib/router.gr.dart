// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import 'infrastructure/moor_database.dart' as _i12;
import 'mvvc/creacion_form_page.dart' as _i5;
import 'mvvc/llenado_form_page.dart' as _i7;
import 'presentation/pages/borradores_screen.dart' as _i6;
import 'presentation/pages/cuestionarios_screen.dart' as _i9;
import 'presentation/pages/grupos_screen.dart' as _i10;
import 'presentation/pages/history_screen.dart' as _i11;
import 'presentation/pages/login_screen.dart' as _i4;
import 'presentation/pages/sincronizacion_screen.dart' as _i8;
import 'presentation/pages/splash_screen.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.SplashPage();
        }),
    LoginRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i4.LoginPage();
        }),
    CreacionFormRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<CreacionFormRouteArgs>(
              orElse: () => const CreacionFormRouteArgs());
          return _i5.CreacionFormPage(
              key: args.key,
              cuestionario: args.cuestionario,
              cuestionarioDeModelo: args.cuestionarioDeModelo,
              bloques: args.bloques);
        }),
    BorradoresRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i6.BorradoresPage();
        }),
    LlenadoFormRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<LlenadoFormRouteArgs>(
              orElse: () => const LlenadoFormRouteArgs());
          return _i7.LlenadoFormPage(
              key: args.key,
              activo: args.activo,
              cuestionarioId: args.cuestionarioId);
        }),
    SincronizacionRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i8.SincronizacionPage();
        }),
    CuestionariosRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i9.CuestionariosPage();
        }),
    GruposScreen.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i10.GruposScreen();
        }),
    HistoryInspeccionesRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i11.HistoryInspeccionesPage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashRoute.name, path: '/'),
        _i1.RouteConfig(LoginRoute.name, path: '/login-page'),
        _i1.RouteConfig(CreacionFormRoute.name, path: '/creacion-form-page'),
        _i1.RouteConfig(BorradoresRoute.name, path: '/borradores-page'),
        _i1.RouteConfig(LlenadoFormRoute.name, path: '/llenado-form-page'),
        _i1.RouteConfig(SincronizacionRoute.name, path: '/sincronizacion-page'),
        _i1.RouteConfig(CuestionariosRoute.name, path: '/cuestionarios-page'),
        _i1.RouteConfig(GruposScreen.name, path: '/grupos-screen'),
        _i1.RouteConfig(HistoryInspeccionesRoute.name,
            path: '/history-inspecciones-page')
      ];
}

class SplashRoute extends _i1.PageRouteInfo {
  const SplashRoute() : super(name, path: '/');

  static const String name = 'SplashRoute';
}

class LoginRoute extends _i1.PageRouteInfo {
  const LoginRoute() : super(name, path: '/login-page');

  static const String name = 'LoginRoute';
}

class CreacionFormRoute extends _i1.PageRouteInfo<CreacionFormRouteArgs> {
  CreacionFormRoute(
      {_i2.Key? key,
      _i12.Cuestionario cuestionario,
      _i12.CuestionarioConContratista cuestionarioDeModelo,
      List<_i12.IBloqueOrdenable> bloques})
      : super(name,
            path: '/creacion-form-page',
            args: CreacionFormRouteArgs(
                key: key,
                cuestionario: cuestionario,
                cuestionarioDeModelo: cuestionarioDeModelo,
                bloques: bloques));

  static const String name = 'CreacionFormRoute';
}

class CreacionFormRouteArgs {
  const CreacionFormRouteArgs(
      {this.key, this.cuestionario, this.cuestionarioDeModelo, this.bloques});

  final _i2.Key? key;

  final _i12.Cuestionario cuestionario;

  final _i12.CuestionarioConContratista cuestionarioDeModelo;

  final List<_i12.IBloqueOrdenable> bloques;
}

class BorradoresRoute extends _i1.PageRouteInfo {
  const BorradoresRoute() : super(name, path: '/borradores-page');

  static const String name = 'BorradoresRoute';
}

class LlenadoFormRoute extends _i1.PageRouteInfo<LlenadoFormRouteArgs> {
  LlenadoFormRoute({_i2.Key key, int activo, int cuestionarioId})
      : super(name,
            path: '/llenado-form-page',
            args: LlenadoFormRouteArgs(
                key: key, activo: activo, cuestionarioId: cuestionarioId));

  static const String name = 'LlenadoFormRoute';
}

class LlenadoFormRouteArgs {
  const LlenadoFormRouteArgs({this.key, this.activo, this.cuestionarioId});

  final _i2.Key key;

  final int activo;

  final int cuestionarioId;
}

class SincronizacionRoute extends _i1.PageRouteInfo {
  const SincronizacionRoute() : super(name, path: '/sincronizacion-page');

  static const String name = 'SincronizacionRoute';
}

class CuestionariosRoute extends _i1.PageRouteInfo {
  const CuestionariosRoute() : super(name, path: '/cuestionarios-page');

  static const String name = 'CuestionariosRoute';
}

class GruposScreen extends _i1.PageRouteInfo {
  const GruposScreen() : super(name, path: '/grupos-screen');

  static const String name = 'GruposScreen';
}

class HistoryInspeccionesRoute extends _i1.PageRouteInfo {
  const HistoryInspeccionesRoute()
      : super(name, path: '/history-inspecciones-page');

  static const String name = 'HistoryInspeccionesRoute';
}
