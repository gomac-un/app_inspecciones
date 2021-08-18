// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import 'presentation/pages/login_page.dart' as _i3;
import 'presentation/pages/sincronizacion_screen.dart' as _i4;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    EmptyRouterRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
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
          return _i4.SincronizacionPage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(EmptyRouterRoute.name,
            path: '/',
            children: [_i1.RouteConfig(SincronizacionRoute.name, path: '')]),
        _i1.RouteConfig(LoginRoute.name, path: '/login')
      ];
}

class EmptyRouterRoute extends _i1.PageRouteInfo {
  const EmptyRouterRoute({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'EmptyRouterRoute';
}

class LoginRoute extends _i1.PageRouteInfo {
  const LoginRoute() : super(name, path: '/login');

  static const String name = 'LoginRoute';
}

class SincronizacionRoute extends _i1.PageRouteInfo {
  const SincronizacionRoute() : super(name, path: '');

  static const String name = 'SincronizacionRoute';
}
