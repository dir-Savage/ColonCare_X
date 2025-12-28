import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_form_bloc/auth_form_bloc.dart';
import 'package:coloncare/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:coloncare/features/splash/presentation/splash_bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injector.dart';

class AppBlocProviders extends StatelessWidget {
  final Widget child;

  const AppBlocProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Get all BLoCs from GetIt
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<AuthFormBloc>(create: (_) => getIt<AuthFormBloc>()),
        BlocProvider<HomeBloc>(create: (_) => getIt<HomeBloc>()),
        BlocProvider<SplashBloc>(create: (_) => getIt<SplashBloc>()),
      ],
      child: child,
    );
  }
}