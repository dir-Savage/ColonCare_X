import 'package:coloncare/core/navigation/navigation_service.dart';
import 'package:coloncare/core/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/di/app_bloc_providers.dart';
import 'core/di/injector.dart';
import 'core/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize dependencies (GetIt)
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocProviders(
      child: MaterialApp(
        title: 'Colon Care',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.generateRoute,
        navigatorKey: NavigationService().navigatorKey,
      ),
    );
  }
}