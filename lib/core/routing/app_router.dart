import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/login/presentation/screens/login_screen.dart';
import '../../features/login/presentation/screens/welcome_screen.dart';


class RouterApp {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String home = '/home';

  static GoRouter goRoute = GoRouter(
    initialLocation: welcome,
    routes: [
      GoRoute(
          path: welcome,
          builder: (context, state) {
            return const WelcomeScreen();
          }),
      GoRoute(
          path: login,
          builder: (context, state) {
            return const LoginScreen();
          }),
      GoRoute(
          path: home,
          builder: (context, state) {
            return HomeScreen();
          }),
    ],
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
    ),
  );
}
