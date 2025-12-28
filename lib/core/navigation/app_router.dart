import 'package:coloncare/features/home/presentation/pages/navbar.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';

  //home
  static const String home = '/home';
  static const String navbar = '/navbar';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashPage(), settings);
      case login:
        return _buildRoute(const LoginPage(), settings);
      case register:
        return _buildRoute(const RegisterPage(), settings);
      case home:
        return _buildRoute(const HomePage(), settings);
      case resetPassword:
        return _buildRoute(const ResetPasswordPage(), settings);
      case navbar:
        return _buildRoute(MainNavigation(), settings);

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  // Helper method for building routes
  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }

  // Navigation helpers
  static Future<dynamic> pushNamed(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> pushReplacementNamed(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(context).pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
          (route) => false,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }
}