import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page_example.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.path(AppRoutes.login),
    routes: [
      GoRoute(
        path: AppRoutes.path(AppRoutes.root),
        redirect: (context, state) => AppRoutes.path(AppRoutes.login),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.login),
        name: AppRoutes.login,
        builder: (context, state) => const LoginPageExample(),
      ),
      // Add more routes here as needed
      // GoRoute(
      //   path: AppRoutes.path(AppRoutes.home),
      //   name: AppRoutes.home,
      //   builder: (context, state) => const HomePage(),
      // ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
    // You can add redirect logic here for authentication
    // redirect: (context, state) {
    //   final isLoggedIn = // check auth state
    //   final isGoingToLogin = state.uri.path == AppRoutes.path(AppRoutes.login);
    //   if (!isLoggedIn && !isGoingToLogin) {
    //     return AppRoutes.path(AppRoutes.login);
    //   }
    //   if (isLoggedIn && isGoingToLogin) {
    //     return AppRoutes.path(AppRoutes.home);
    //   }
    //   return null;
    // },
  );
}
