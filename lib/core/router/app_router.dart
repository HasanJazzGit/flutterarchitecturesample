import 'package:flutter/material.dart';
import 'package:fluttersampleachitecture/features/example_clean/presentation/pages/clean_structure_guide_page.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/example_mvvm/view/pages/mvvm_structure_guide_page.dart';
import '../../features/examples/presentation/pages/examples_page.dart';
import '../../features/examples/presentation/pages/shimmer_examples_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';
import 'router_observer.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.path(AppRoutes.splash),
    observers: [GoRouterObserver()], // Router debug logging
    routes: [
      GoRoute(
        path: AppRoutes.path(AppRoutes.root),
        redirect: (context, state) => AppRoutes.path(AppRoutes.splash),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.splash),
        name: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.login),
        name: AppRoutes.login,
        // AuthCubit is provided at app-level, no need to create here
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.examples),
        name: AppRoutes.examples,
        builder: (context, state) => const ExamplesPage(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.shimmerExamples),
        name: AppRoutes.shimmerExamples,
        builder: (context, state) => const ShimmerExamplesPage(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.products),
        name: AppRoutes.products,
        builder: (context, state) => const ProductsPage(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.exampleClean),
        name: AppRoutes.exampleClean,
        builder: (context, state) => const CleanStructureGuidePage(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.exampleMvvm),
        name: AppRoutes.exampleMvvm,
        builder: (context, state) => const MvvmStructureGuidePage(),
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
