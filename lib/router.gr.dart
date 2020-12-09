// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'mvvc/creacion_form_page.dart';

class Routes {
  static const String creacionFormPage = '/';
  static const all = <String>{
    creacionFormPage,
  };
}

class AutoRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.creacionFormPage, page: CreacionFormPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    CreacionFormPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const CreacionFormPage().wrappedRoute(context),
        settings: data,
      );
    },
  };
}
