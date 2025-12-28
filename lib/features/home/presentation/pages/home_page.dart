import 'package:coloncare/core/navigation/app_router.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:coloncare/features/auth/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:coloncare/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:coloncare/features/home/presentation/blocs/home_bloc/home_event.dart';
import 'package:coloncare/features/home/presentation/blocs/home_bloc/home_state.dart';
import 'package:coloncare/features/home/presentation/widgets/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 80, color: Colors.red[400]),
                    const SizedBox(height: 24),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      onPressed: () {
                        context.read<HomeBloc>().add(HomeDataRefreshed());
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is HomeLoaded) {
            return HomeContent(user: state.user);
          }

          // Default / fallback
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}