import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/colors.dart';
import 'pages/home_page.dart';
import 'pages/confirmation_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/confirmation',
      builder: (_, state) {
        final prenom = state.uri.queryParameters['prenom'] ?? '';
        final place = int.tryParse(state.uri.queryParameters['place'] ?? '') ?? 0;
        return ConfirmationPage(prenom: prenom, place: place);
      },
    ),
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
