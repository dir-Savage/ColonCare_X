import 'package:coloncare/core/navigation/app_router.dart';
import 'package:coloncare/features/splash/presentation/splash_bloc/splash_bloc.dart';
import 'package:coloncare/features/splash/presentation/splash_bloc/splash_event.dart';
import 'package:coloncare/features/splash/presentation/splash_bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger splash check when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashBloc>().add(const SplashAuthCheckRequested());
    });

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.navbar,
                (route) => false,
          );
        } else if (state is SplashUnauthenticated || state is SplashError) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.login,
                (route) => false,
          );
        }
      },
      child: const _SplashContent(),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Colon Care',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}