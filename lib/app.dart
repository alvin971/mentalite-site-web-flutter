import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/colors.dart';
import 'pages/home_page.dart';
import 'pages/confirmation_page.dart';
import 'pages/splash_screen.dart';
import 'pages/confidentialite_page.dart';

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/confirmation',
      builder: (_, state) {
        final prenom = state.uri.queryParameters['prenom'] ?? '';
        final place = int.tryParse(state.uri.queryParameters['place'] ?? '') ?? 0;
        return ConfirmationPage(prenom: prenom, place: place);
      },
    ),
    GoRoute(path: '/confidentialite', builder: (_, __) => const ConfidentialitePage()),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mental E.T. — La première plateforme de psychologie complète et gratuite',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          surface: AppColors.bg,
        ),
        scrollbarTheme: const ScrollbarThemeData(
          thumbVisibility: WidgetStatePropertyAll(false),
        ),
      ),
    );
  }
}
