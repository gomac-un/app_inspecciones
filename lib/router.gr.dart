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

class AutoRouter extends _i1.RootStackRouter {
  AutoRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.SplashPage();
        }),
    LoginScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i4.LoginScreen();
        }),
    CreacionFormPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<CreacionFormPageRouteArgs>(
              orElse: () => const CreacionFormPageRouteArgs());
          return _i5.CreacionFormPage(
              key: args.key,
              cuestionario: args.cuestionario,
              cuestionarioDeModelo: args.cuestionarioDeModelo,
              bloques: args.bloques);
        }),
    BorradoresPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i6.BorradoresPage();
        }),
    LlenadoFormPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<LlenadoFormPageRouteArgs>(
              orElse: () => const LlenadoFormPageRouteArgs());
          return _i7.LlenadoFormPage(
              key: args.key,
              activo: args.activo,
              cuestionarioId: args.cuestionarioId);
        }),
    SincronizacionPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i8.SincronizacionPage();
        }),
    CuestionariosPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i9.CuestionariosPage();
        }),
    GruposScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i10.GruposScreen();
        }),
    HistoryInspeccionesPageRoute.name: (routeData) =>
        _i1.MaterialPageX<dynamic>(
            routeData: routeData,
            builder: (_) {
              return _i11.HistoryInspeccionesPage();
            })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashPageRoute.name, path: '/'),
        _i1.RouteConfig(LoginScreenRoute.name, path: '/login-screen'),
        _i1.RouteConfig(CreacionFormPageRoute.name,
            path: '/creacion-form-page'),
        _i1.RouteConfig(BorradoresPageRoute.name, path: '/borradores-page'),
        _i1.RouteConfig(LlenadoFormPageRoute.name, path: '/llenado-form-page'),
        _i1.RouteConfig(SincronizacionPageRoute.name,
            path: '/sincronizacion-page'),
        _i1.RouteConfig(CuestionariosPageRoute.name,
            path: '/cuestionarios-page'),
        _i1.RouteConfig(GruposScreenRoute.name, path: '/grupos-screen'),
        _i1.RouteConfig(HistoryInspeccionesPageRoute.name,
            path: '/history-inspecciones-page')
      ];
}

class SplashPageRoute extends _i1.PageRouteInfo {
  const SplashPageRoute() : super(name, path: '/');

  static const String name = 'SplashPageRoute';
}

class LoginScreenRoute extends _i1.PageRouteInfo {
  const LoginScreenRoute() : super(name, path: '/login-screen');

  static const String name = 'LoginScreenRoute';
}

class CreacionFormPageRoute
    extends _i1.PageRouteInfo<CreacionFormPageRouteArgs> {
  CreacionFormPageRoute(
      {_i2.Key key,
      dynamic cuestionario,
      _i12.CuestionarioConContratista cuestionarioDeModelo,
      List<_i12.IBloqueOrdenable> bloques})
      : super(name,
            path: '/creacion-form-page',
            args: CreacionFormPageRouteArgs(
                key: key,
                cuestionario: cuestionario,
                cuestionarioDeModelo: cuestionarioDeModelo,
                bloques: bloques));

  static const String name = 'CreacionFormPageRoute';
}

class CreacionFormPageRouteArgs {
  const CreacionFormPageRouteArgs(
      {this.key, this.cuestionario, this.cuestionarioDeModelo, this.bloques});

  final _i2.Key key;

  final dynamic cuestionario;

  final _i12.CuestionarioConContratista cuestionarioDeModelo;

  final List<_i12.IBloqueOrdenable> bloques;
}

class BorradoresPageRoute extends _i1.PageRouteInfo {
  const BorradoresPageRoute() : super(name, path: '/borradores-page');

  static const String name = 'BorradoresPageRoute';
}

class LlenadoFormPageRoute extends _i1.PageRouteInfo<LlenadoFormPageRouteArgs> {
  LlenadoFormPageRoute({_i2.Key key, int activo, int cuestionarioId})
      : super(name,
            path: '/llenado-form-page',
            args: LlenadoFormPageRouteArgs(
                key: key, activo: activo, cuestionarioId: cuestionarioId));

  static const String name = 'LlenadoFormPageRoute';
}

class LlenadoFormPageRouteArgs {
  const LlenadoFormPageRouteArgs({this.key, this.activo, this.cuestionarioId});

  final _i2.Key key;

  final int activo;

  final int cuestionarioId;
}

class SincronizacionPageRoute extends _i1.PageRouteInfo {
  const SincronizacionPageRoute() : super(name, path: '/sincronizacion-page');

  static const String name = 'SincronizacionPageRoute';
}

class CuestionariosPageRoute extends _i1.PageRouteInfo {
  const CuestionariosPageRoute() : super(name, path: '/cuestionarios-page');

  static const String name = 'CuestionariosPageRoute';
}

class GruposScreenRoute extends _i1.PageRouteInfo {
  const GruposScreenRoute() : super(name, path: '/grupos-screen');

  static const String name = 'GruposScreenRoute';
}

class HistoryInspeccionesPageRoute extends _i1.PageRouteInfo {
  const HistoryInspeccionesPageRoute()
      : super(name, path: '/history-inspecciones-page');

  static const String name = 'HistoryInspeccionesPageRoute';
}
