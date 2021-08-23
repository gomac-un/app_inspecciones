// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import 'mvvc/creacion_form_page.dart' as _i6;
import 'mvvc/edicion_form_page.dart' as _i7;
import 'presentation/pages/cuestionarios_screen.dart' as _i5;
import 'presentation/pages/login_page.dart' as _i3;
import 'presentation/pages/sincronizacion_screen.dart' as _i4;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    AuthenticatedRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    LoginRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i3.LoginPage();
        }),
    SincronizacionRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i4.SincronizacionPage();
        }),
    CuestionariosRouter.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    CuestionariosRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i5.CuestionariosPage();
        }),
    CreacionFormRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i6.CreacionFormPage();
        }),
    EdicionFormRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<EdicionFormRouteArgs>(
              orElse: () => EdicionFormRouteArgs(
                  cuestionarioId: pathParams.optInt('cuestionarioId')));
          return _i7.EdicionFormPage(
              key: args.key, cuestionarioId: args.cuestionarioId);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(AuthenticatedRouter.name, path: '/', children: [
          _i1.RouteConfig('#redirect',
              path: '', redirectTo: 'sincronizacion', fullMatch: true),
          _i1.RouteConfig(SincronizacionRoute.name, path: 'sincronizacion'),
          _i1.RouteConfig(CuestionariosRouter.name,
              path: 'cuestionarios',
              children: [
                _i1.RouteConfig(CuestionariosRoute.name, path: ''),
                _i1.RouteConfig(CreacionFormRoute.name, path: 'nuevo'),
                _i1.RouteConfig(EdicionFormRoute.name, path: ':cuestionarioId'),
                _i1.RouteConfig('*#redirect',
                    path: '*', redirectTo: '', fullMatch: true)
              ])
        ]),
        _i1.RouteConfig(LoginRoute.name, path: '/login'),
        _i1.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

class AuthenticatedRouter extends _i1.PageRouteInfo {
  const AuthenticatedRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'AuthenticatedRouter';
}

class LoginRoute extends _i1.PageRouteInfo {
  const LoginRoute() : super(name, path: '/login');

  static const String name = 'LoginRoute';
}

class SincronizacionRoute extends _i1.PageRouteInfo {
  const SincronizacionRoute() : super(name, path: 'sincronizacion');

  static const String name = 'SincronizacionRoute';
}

class CuestionariosRouter extends _i1.PageRouteInfo {
  const CuestionariosRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'cuestionarios', initialChildren: children);

  static const String name = 'CuestionariosRouter';
}

class CuestionariosRoute extends _i1.PageRouteInfo {
  const CuestionariosRoute() : super(name, path: '');

  static const String name = 'CuestionariosRoute';
}

class CreacionFormRoute extends _i1.PageRouteInfo {
  const CreacionFormRoute() : super(name, path: 'nuevo');

  static const String name = 'CreacionFormRoute';
}

class EdicionFormRoute extends _i1.PageRouteInfo<EdicionFormRouteArgs> {
  EdicionFormRoute({_i2.Key? key, int? cuestionarioId})
      : super(name,
            path: ':cuestionarioId',
            args:
                EdicionFormRouteArgs(key: key, cuestionarioId: cuestionarioId),
            rawPathParams: {'cuestionarioId': cuestionarioId});

  static const String name = 'EdicionFormRoute';
}

class EdicionFormRouteArgs {
  const EdicionFormRouteArgs({this.key, this.cuestionarioId});

  final _i2.Key? key;

  final int? cuestionarioId;
}
