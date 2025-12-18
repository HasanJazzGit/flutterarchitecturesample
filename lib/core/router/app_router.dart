import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/dependency_injection.dart';
import '../../features/auth/presentation/pages/login_page_example.dart';
import '../../features/dashboard/presentation/manager/dashboard_cubit.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.path(AppRoutes.dashboard),
    routes: [
      GoRoute(
        path: AppRoutes.path(AppRoutes.root),
        redirect: (context, state) => AppRoutes.path(AppRoutes.dashboard),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.login),
        name: AppRoutes.login,
        builder: (context, state) => const LoginPageExample(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.dashboard),
        name: AppRoutes.dashboard,
        builder: (context, state) => BlocProvider.value(
          // Use singleton instance - same as MyApp
          value: sl<DashboardCubit>(),
          child: const DashboardPage(),
        ),
      ),
      // Add more routes here as needed
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
