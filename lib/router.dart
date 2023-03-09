//LoggedIn
//LoggedOut

import 'package:flutter/material.dart';
import 'package:reddittdemo/features/home/screens/home_screen.dart';
import 'package:reddittdemo/features/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
});